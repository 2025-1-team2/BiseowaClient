//
//  ConferenceView.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/4/25.
//


import SwiftUI

struct ConferenceView: View {
    let participants: [String]

    @State private var showSummaryPopup = false
    @State private var showSummaryToast = false
    @State private var summaryList = [
        "회의 장소 : 경북대학교 융복합관",
        "회의 시간 : 11:30",
        "보고\n-개발현황 : 40% (Demo 완료, UI 작업진행중)",
        "요약 항목 4"
    ]
    
    @State private var showChatPopup = false
    @State private var chatMessages: [ChatMessage] = [
        ChatMessage(sender: "Jeongseok Kim", content: "모든 참여자분들이 참석할때까지 기다려주세요."),
        ChatMessage(sender: "정수인", content: "잠깐 개인사정 때문에 참석이 힘들다고 연락주셨습니다.")
    ]
    @State private var currentChat = ""
    

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                // 상단 제목 + 편지 버튼
                ZStack {
                    Text("회의방")
                        .font(.custom("Pretendard-Bold", size: 24))
                        .foregroundColor(.white)

                    HStack {
                        Spacer()
                        Button(action: {
                            withAnimation {
                                showSummaryPopup = true
                            }
                        }) {
                            Image(systemName: "envelope")
                                .font(.title2)
                                .foregroundColor(.black)
                                .padding()
                                .background(Circle().fill(Color("BackgroundMint")))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()

                // 참가자 그리드
                participantGrid

                Spacer()

                // 하단 메뉴 아이콘
                HStack(spacing: 40) {
                    Image(systemName: "video.fill")
                    Image(systemName: "mic.fill")
                    Image(systemName: "text.bubble.fill")
                        .onTapGesture {
                            withAnimation {
                                showChatPopup.toggle()
                            }
                        }
                    Image(systemName: "phone.down.fill")
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }

            // 요약 팝업
            if showSummaryPopup {
                VStack {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("📝 비서가 회의내용을 요약해드릴게요.")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    showSummaryPopup = false
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .foregroundColor(.black)
                            }
                        }

                        ScrollView {
                            VStack(alignment: .leading, spacing: 6) {
                                ForEach(summaryList, id: \.self) { item in
                                    Text("• \(item)")
                                        .foregroundColor(.black)
                                        .font(.body)
                                }
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }

                    }
                    .padding()
                    .background(Color(.systemGray6).opacity(0.9))
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .padding(.horizontal, 24)
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.4)
                    .transition(.move(edge: .top))
                    .zIndex(1)

                    Spacer()
                }
                .padding(.top, 60)
                .animation(.easeInOut, value: showSummaryPopup)
            }

            // ✅ 요약본 알림 토스트
            if showSummaryToast {
                VStack {
                    Spacer()
                    Text("회의 요약본이 생성되었습니다.")
                        .padding()
                        .background(Color(.systemGray5))
                        .cornerRadius(16)
                        .foregroundColor(.black)
                        .padding(.bottom, 60)
                        .transition(.opacity)
                        .animation(.easeInOut, value: showSummaryToast)
                }
            }
            if showChatPopup {
                ChatPopupView(messages: $chatMessages, newMessage: $currentChat, isVisible: $showChatPopup)
                    .zIndex(2)
            }
        }
        .onAppear {
            // ✅ 진입 2초 후 토스트 자동 표시(임시)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    showSummaryToast = true
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        showSummaryToast = false
                    }
                }
            }
        }
    }

    // 유동적인 그리드 구성
    var participantGrid: some View {
        switch participants.count {
        case 1:
            return AnyView(
                VStack {
                    Spacer()
                    ParticipantView(name: participants[0], isLocalUser: participants[0] == "User C")
                        .frame(width: 200, height: 200)
                    Spacer()
                }
            )
        case 2:
            return AnyView(
                VStack(spacing: 16) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 200, height: 200)
                    }
                }
            )
        case 3:
            return AnyView(
                VStack(spacing: 12) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 180, height: 180)
                    }
                }
            )
        case 4:
            return AnyView(
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 2), spacing: 80) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 140, height: 140)
                    }
                }
            )
        case 5, 6:
            return AnyView(
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 2), spacing: 80) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 120, height: 120)
                    }
                }
            )
        default:
            return AnyView(EmptyView())
        }
    }
}



#Preview {
    Group {
        //ConferenceView(participants: ["User A"])
        //ConferenceView(participants: ["User A", "User B"])
        //ConferenceView(participants: ["User A", "User B", "User C"])
        //ConferenceView(participants: ["User A", "User B", "User C", "User D"])
        //ConferenceView(participants: ["User A", "User B", "User C", "User D", "User E"])
        ConferenceView(participants: ["User A", "User B", "User C", "User D", "User E", "User F"])
    }
}






