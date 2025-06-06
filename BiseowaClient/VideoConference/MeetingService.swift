//
//  CreateMeetingButton.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/5/25.
//
import SwiftUI
import LiveKit

class MeetingService: ObservableObject {
    @Published var room: Room?
    @Published var isConnecting = false
    @Published var errorMessage: String?
    @Published var roomName: String = ""
    @Published var meetingPassword: String = ""
    @Published var isConnected = false

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

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.errorMessage = "토큰 요청 실패: \(error.localizedDescription)"
                    self.isConnecting = false
                    return
                }

                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: String],
                      let token = json["token"] else {
                    self.errorMessage = "토큰 파싱 실패"
                    self.isConnecting = false
                    return
                }

                self.connectToRoom(token: token)
            }
        }.resume()
    }

    func connectToRoom(token: String) {
        Task {
            let room = Room()
            do {
                try await room.connect(
                    url: "wss://team2test-mzfuicbo.livekit.cloud",
                    token: token
                )
                self.room = room
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
}
