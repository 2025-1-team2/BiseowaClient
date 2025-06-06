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
    
    var body: some View {
        VStack {
            Button(action: createAndJoinRoom) {
                HStack {
                    Image(systemName: "plus")
                    Text("회의 생성하기")
                        .font(.headline)
                }
                .padding()
                .background(Color.teal)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .disabled(isConnecting)

            if isConnecting {
                ProgressView("연결 중...")
                    .padding()
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }

    func createAndJoinRoom() {
        isConnecting = true
        errorMessage = nil

        // 예: 방 이름은 UUID로 생성하거나 사용자 입력 등으로 설정 가능
        let roomName = "room_" + UUID().uuidString.prefix(6)

        // 백엔드 토큰 서버에서 JWT 받아오기
        fetchToken(for: roomName) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.connectToRoom(token: token)
                case .failure(let error):
                    self.errorMessage = "토큰 가져오기 실패: \(error.localizedDescription)"
                    self.isConnecting = false
                }
            }
        }
    }

    func connectToRoom(token: String) {
        Task {
            isConnecting = true
            errorMessage = nil

            let room = Room()

            do {
                try await room.connect(
                    url: "wss://team2test-mzfuicbo.livekit.cloud",
                    token: token
                )
                self.room = room
                isConnecting = false
                print("✅ 회의 연결 성공")
                // TODO: 회의 화면으로 전환
            } catch {
                errorMessage = "연결 실패: \(error.localizedDescription)"
                isConnecting = false
            }
        }
    }


    func fetchToken(for roomName: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "https://your-token-server.com/join?room=\(roomName)&identity=user123") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data, let token = String(data: data, encoding: .utf8) else {
                completion(.failure(URLError(.cannotParseResponse)))
                return
            }

            completion(.success(token))
        }.resume()
    }
}
