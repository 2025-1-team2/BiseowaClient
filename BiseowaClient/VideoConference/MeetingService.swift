//
//  CreateMeetingButton.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/5/25.
//
import SwiftUI
import LiveKit

class MeetingService: ObservableObject, RoomDelegate {

    @Published var isConnecting = false
    @Published var errorMessage: String?
    @Published var roomName: String = ""
    @Published var meetingPassword: String = ""
    @Published var isConnected = false

    // 1) View가 바인딩할 Published 배열
    @Published var participants: [ParticipantInfo] = []

    // 2) non-optional Room
    let room: Room = Room()

    struct ParticipantInfo: Identifiable {
        let id: String
        let name: String?
        let isLocal: Bool
        let participant: Participant
    }

    // MARK: 초기화
    init() {
        //room = Room()
        room.delegates.add(delegate: self)   // ✅ optional-chaining 제거

        // 로컬 참가자 등록 (room.localParticipant 는 Optional 아님)
        let local = room.localParticipant
        participants.append(
            ParticipantInfo(
                id: String(describing: local.identity),
                name: local.name,
                isLocal: true,
                participant: local
            )
        )
    }

    // MARK: delegate
    func room(_ room: Room, participantDidConnect p: RemoteParticipant) {
        DispatchQueue.main.async { [weak self] in
            self?.participants.append(
                ParticipantInfo(
                    id: String(describing: p.identity),
                    name: p.name,
                    isLocal: false,
                    participant: p
                )
            )
        }
    }

    func room(_ room: Room, participantDidDisconnect p: RemoteParticipant) {
        DispatchQueue.main.async { [weak self] in
            self?.participants.removeAll { $0.id == String(describing: p.identity) }
        }
    }
    func createMeeting(identity: String,completion: @escaping (Result<(String, String), Error>) -> Void) {
        guard let url = URL(string: "http://3.34.130.191:3000/create-meeting") else {
            self.errorMessage = "잘못된 URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["identity": identity]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        isConnecting = true
        errorMessage = nil

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "방 생성 실패: \(error.localizedDescription)"
                    self.isConnecting = false
                    return
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                      let roomName = json["roomName"],
                      let password = json["password"] else {
                    self.errorMessage = "응답 파싱 실패"
                    self.isConnecting = false
                    return
                }

                self.roomName = roomName
                self.meetingPassword = password

                //self.joinMeeting(identity: identity, roomName: roomName, password: password)
                completion(.success((roomName, password)))
            }
        }.resume()
    }

    func joinMeeting(identity: String, roomName: String, password: String) {
        guard let url = URL(string: "http://3.34.130.191:3000/join-meeting") else {
            self.errorMessage = "잘못된 URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "roomName": roomName,
            "password": password,
            "identity": identity
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("📤 join-meeting 요청 보냄")
        print("➡️ 요청 바디: \(body)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "토큰 요청 실패: \(error.localizedDescription)"
                    self.isConnecting = false
                    print("❌ 요청 에러: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("✅ 응답 상태 코드: \(httpResponse.statusCode)")
                }

                if let data = data,let responseBody = String(data: data, encoding: .utf8) {
                    print("📥 응답 바디: \(responseBody)")
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                      let token = json["token"] else {
                    self.errorMessage = "토큰 파싱 실패"
                    self.isConnecting = false
                    print("❌ JSON 파싱 실패 또는 token 없음")
                    return
                }
                print("✅ 토큰 수신 완료: \(token.prefix(30))...")
                self.connectToRoom(token: token)
            }
        }.resume()
    }

    func connectToRoom(token: String) {
        Task {
            //let room = Room()
            do {
                try await self.room.connect(
                    url: "wss://team2test-mzfuicbo.livekit.cloud",
                    token: token,
                    connectOptions: ConnectOptions(
                        autoSubscribe: true
                    )
                )
                
                // 연결 이후 카메라/마이크 수동 활성화 (선택)
                try await self.room.localParticipant.setCamera(enabled: true)
                try await self.room.localParticipant.setMicrophone(enabled: true)
                
                // 3) participants 배열 갱신 (메인 스레드)
                let local = room.localParticipant
                let updatedLocalInfo = ParticipantInfo(
                    id: room.localParticipant.sid?.stringValue ?? "",
                    name: local.name ?? "나",
                    isLocal: true,
                    participant: local
                )
                // 기존 원격 참가자 유지
                let remoteInfos = room.remoteParticipants.values.map {
                    ParticipantInfo(
                        id: $0.sid?.stringValue ?? "",
                        name: $0.name,
                        isLocal: false,
                        participant: $0
                    )
                }
                // 배열을 새로 할당해야 @Published 알림이 감지됩니다.
                participants = [updatedLocalInfo] + remoteInfos

                //self.room = room
                self.isConnected = true
                self.isConnecting = false
                print("✅ 회의 연결 성공")
            } catch {
                self.errorMessage = "연결 실패: \(error.localizedDescription)"
                self.isConnecting = false
                self.isConnected = false
            }
        }
    }
    func disconnect() {
        Task {
            do {
                try await room.localParticipant.setCamera(enabled: false)
                try await room.localParticipant.setMicrophone(enabled: false)
                await room.disconnect()
                try await stopCaptureIfNeeded()   // ← try await
                isConnected = false
            } catch {
                // 캡처 정지 과정에서 나는 에러 로그만 남기고 흘려보내도 OK
                print("🔴 stopCaptureIfNeeded 오류: \(error)")
            }
        }
    }

    private func stopCaptureIfNeeded() async throws {
        let participant = room.localParticipant

        for pub in participant.videoTracks {
            if let videoTrack = pub.track as? LocalVideoTrack {
                try await videoTrack.stop()   // 여기는 그대로 try await
            }
        }
    }
}
