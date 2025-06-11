//
//  ConferenceView.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/4/25.
//

//
//  ConferenceView.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/4/25.
//

import SwiftUI
import LiveKit

struct ConferenceView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @EnvironmentObject var meetingService: MeetingService
    let createSummary: Bool
    let roomName: String
    let password: String
    
    @State private var showSummaryPopup = false
    @State private var showSummaryToast = false
    @State private var showChatPopup = false
    @State private var currentChat = ""
    @State private var isCameraOn = true
    @State private var isMicOn = true
    @State private var isExiting = false
    
    @State private var chatMessages: [ChatMessage] = [
        ChatMessage(sender: "Jeongseok Kim", content: "모든 참여자분들이 참석할때까지 기다려주세요."),
        ChatMessage(sender: "정수인", content: "잠깐 개인사정 때문에 참석이 힘들다고 연락주셨습니다.")
    ]
    
    @State private var summaryList = [
        "회의 장소 : 경북대학교 융복합관",
        "회의 시간 : 11:30",
        "보고\n-개발현황 : 40% (Demo 완료, UI 작업진행중)",
        "요약 항목 4"
    ]
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()
                
                VStack(spacing: 16) {
                    ZStack {
                        Text("회의방")
                            .font(.custom("Pretendard-Bold", size: 24))
                            .foregroundColor(.white)
                        
                        HStack {
                            Spacer()
                            if createSummary {
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
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
                    participantGrid
                    Spacer()
                    
                    HStack(spacing: 40) {
                        Image(systemName: isCameraOn ? "video.fill" : "video.slash.fill")
                            .onTapGesture {
                                isCameraOn.toggle()
                                toggleCameraStream(enabled: isCameraOn)
                            }
                        
                        Image(systemName: isMicOn ? "mic.fill" : "mic.slash.fill")
                            .onTapGesture {
                                isMicOn.toggle()
                                toggleMicStream(enabled: isMicOn)
                            }
                        
                        Image(systemName: "text.bubble.fill")
                            .onTapGesture {
                                withAnimation {
                                    showChatPopup.toggle()
                                }
                            }
                        Image(systemName: "phone.down.fill")
                            .onTapGesture {
                                meetingService.disconnect()
                                isExiting = true
                            }
                    }
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                }
                
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
            .navigationDestination(isPresented: $isExiting) {
                ExitView()
            }
        }
        .onAppear {
            Task {
                try? await meetingService.joinMeeting(
                    identity: authViewModel.user?.id ?? "guest",
                    roomName: roomName,
                    password: password
                )
            }
            guard createSummary else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation { showSummaryToast = true }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation { showSummaryToast = false }
                }
            }
        }
        .onDisappear {
            Task {
                try? await meetingService.room.localParticipant.setCamera(enabled: false)
                try? await meetingService.room.localParticipant.setMicrophone(enabled: false)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
    }
    
    /// MeetingService.ParticipantInfo 전용 래퍼
    struct VideoViewWrapper: UIViewRepresentable {
        let info: MeetingService.ParticipantInfo

        func makeUIView(context: Context) -> VideoView {
            let view = VideoView()
            view.contentMode = .scaleAspectFit
            // 최초 트랙 연결
            if let track = primaryVideoTrack {
                view.track = track
            }
            return view
        }

        func updateUIView(_ uiView: VideoView, context: Context) {
            // 트랙이 바뀌었을 수 있으니 매번 최신값 갱신
            uiView.track = primaryVideoTrack
        }

        /// info에서 첫 번째 활성 VideoTrack을 꺼내는 헬퍼
        private var primaryVideoTrack: VideoTrack? {
            info.participant
                .videoTracks
                .compactMap { $0.track as? VideoTrack }
                .first
        }
    }
    
    /// MeetingService.ParticipantInfo 전용 뷰
    struct ParticipantViewWrapper: View {
        let info: MeetingService.ParticipantInfo
        let cornerRadius: CGFloat = 20
        
        // ① 트랙 헬퍼에 print 추가
        private var primaryVideoTrack: VideoTrack? {
            let track = info.participant
                .videoTracks
                .compactMap { $0.track as? VideoTrack }
                .first
            return track
        }

        var body: some View {
            VStack {
                if let track = primaryVideoTrack {
                    VideoViewWrapper(info: info)   // ← VideoViewWrapper 호출
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .onAppear {
                                                print("✅ [\(info.id)] track detected:", track)
                                            }
                } else {
                    Color.gray
                        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                        .onAppear {
                            print("⚠️ [\(info.id)] no track – gray box shown")
                                            }
                    
                }

                Text(info.isLocal ? "나" : (info.name ?? info.id))
                    .foregroundColor(.white)
                    .font(.caption)
            }
            .onAppear {
                print("🖥️ ParticipantViewWrapper onAppear for \(info.id)")
                print("   ▶ primaryVideoTrack:", primaryVideoTrack as Any)
            }
        }


    }

    @ViewBuilder
    func participantViews(for list: [MeetingService.ParticipantInfo],
                          width: CGFloat,
                          height: CGFloat) -> some View {

        ForEach(list) { info in   // Identifiable이므로 id 전달 불필요
            ParticipantViewWrapper(info: info)      // ✅ 변경
                .frame(width: width, height: height)
        }
    }
    
    
    var participantGrid: some View {
        let list = meetingService.participants   // 🔄 Published 배열 사용
        let count = list.count
        print(list)
        return AnyView(
            Group {
                switch count {
                case 0:
                    Text("참가자를 기다리는 중...").foregroundColor(.white)
                case 1:
                    VStack {
                        Spacer()
                        participantViews(for: list, width: 200, height: 200)
                        Spacer()
                    }
                case 2:
                    VStack(spacing: 16) {
                        participantViews(for: list, width: 200, height: 200)
                    }
                case 3:
                    VStack(spacing: 12) {
                        participantViews(for: list, width: 180, height: 180)
                    }
                case 4:
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 80) {
                        participantViews(for: list, width: 140, height: 140)
                    }
                case 5...6:
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 80) {
                        participantViews(for: list, width: 120, height: 120)
                    }
                default:
                    EmptyView()
                }
            }
        )
    }
}

func toggleCameraStream(enabled: Bool) {
    print("🟢 카메라 \(enabled ? "ON" : "OFF") 상태 변경됨")
}

func toggleMicStream(enabled: Bool) {
    print("🔇 마이크 \(enabled ? "ON" : "MUTE") 상태 변경됨")
}

//#Preview {
    //ConferenceView(createSummary: true)
    //   .environmentObject(MeetingService())
    //  .environmentObject(AuthViewModel())
//}
