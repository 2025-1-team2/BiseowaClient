//
//  ConferenceChat.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/5/25.
//

import SwiftUI

struct ChatPopupView: View {
    @Binding var messages: [ChatMessage]
    @Binding var newMessage: String
    @Binding var isVisible: Bool

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(alignment: .leading, spacing: 8) {
                // ✅ 나가기 버튼
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isVisible = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                }

                // ✅ 채팅 메시지
                ScrollView {
                    ForEach(messages) { message in
                        HStack(alignment: .top, spacing: 6) {
                            Image(systemName: "person.fill")
                                .resizable()
                                .frame(width: 16, height: 16) // ⬅ 아이콘 작게
                                .foregroundColor(.black)
                                .padding(.top, 2)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(message.sender)
                                    .font(.system(size: 10))
                                    .foregroundColor(.black.opacity(0.7))
                                Text(message.content)
                                    .font(.system(size: 12))
                                    .foregroundColor(.black)
                            }
                            Spacer()
                        }
                        .padding(8)
                        .background(Color.white)
                        .cornerRadius(10)
                    }
                }

                // ✅ 입력창
                HStack {
                    TextField(" 메시지를 입력하세요", text: $newMessage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Send") {
                        if !newMessage.trimmingCharacters(in: .whitespaces).isEmpty {
                            messages.append(ChatMessage(sender: "나", content: newMessage))
                            newMessage = ""
                        }
                    }
                    .padding(.leading, 8)
                }
                .padding(.top, 8)

            }
            .padding()
            .background(Color.gray.opacity(0.93))
            .frame(height: UIScreen.main.bounds.height * 0.6)
            .cornerRadius(20)
            .padding(.horizontal)

            // ✅ 하단 버튼 바 위로 여백 추가 (ex. 80 높이 확보)
            Spacer().frame(height: 60)
        }
        .transition(.move(edge: .bottom))
    }
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let sender: String
    let content: String
}
