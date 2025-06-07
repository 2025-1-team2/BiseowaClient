//
//  CreateMeetingView.swift
//  BiseowaClient
//
//  Created by minji on 6/8/25.
//

import SwiftUI
import LiveKit

struct CreateMeetingView: View {
    @StateObject private var meetingService = MeetingService()
    @EnvironmentObject var authViewModel: AuthViewModel

    // URL과 Password를 바인딩으로 받습니다.
    @State private var meetingURL: String
    @State private var meetingPassword: String

    @State private var showCopyToast = false
    // 바로 ConferenceView로 네비게이션할 플래그
    @State private var navigateToConference = false

    let roomName: String
    let password: String

    init(roomName: String, password: String) {
        self.roomName = roomName
        self.password = password
        _meetingURL = State(initialValue: roomName)
        _meetingPassword = State(initialValue: password)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("BackgroundMint").ignoresSafeArea()

                VStack(spacing: 0) {
                    // 상단 로고 & 인삿말
                    VStack(spacing: 12) {
                        Spacer().frame(height: 60)
                        Image("logo")
                            .resizable()
                            .frame(width: 64, height: 75)
                        Text("비서와")
                            .font(.custom("Pretendard-Bold", size: 24))
                        Text("회의를 생성해볼까요?")
                            .font(.custom("Pretendard-Light", size: 15))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    // MeetingFormCard 컴포넌트
                    MeetingFormCard(
                        showCopy: true,
                        url: $meetingURL,
                        password: $meetingPassword,
                        buttonTitle: "회의 생성하기"
                    ) {
                        // 1) 주소·비밀번호 복사 + 토스트 표시
                        let combined = "회의방 주소: \(meetingURL)\n회의방 비밀번호: \(meetingPassword)"
                        UIPasteboard.general.string = combined
                        withAnimation { showCopyToast = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showCopyToast = false }
                        }

                        // 2) LiveKit 회의 생성/접속 로직
                        meetingService.meetingPassword = password
                        meetingService.joinMeeting(
                            identity: authViewModel.user?.id ?? "guest",
                            roomName: roomName,
                            password: password
                        )
                        // 3) 연결이 성공하면 자동으로 ConferenceView로 이동
                        //    meetingService.isConnected 가 true가 되면 네비게이트
                        //    아래 NavigationLink 가 활성화됩니다.
                        navigateToConference = true

                    }

                    // 연결 완료되면 바로 ConferenceView 로 자동 네비게이션
                    NavigationLink(
                        destination:
                            ConferenceView(
                                participants: [ authViewModel.user?.id ?? "guest" ],
                                createSummary: false  // 요약을 항상 생성하고 싶다면 true, 아니면 false
                        ),
                        isActive: $navigateToConference
                    ) {
                        EmptyView()
                    }
                    .hidden()
                }

                // 복사 토스트
                if showCopyToast {
                    VStack {
                        Spacer()
                        Text("복사되었습니다.")
                            .padding()
                            .background(Color(.systemGray5))
                            .cornerRadius(12)
                            .foregroundColor(.black)
                            .padding(.bottom, 400)
                            .transition(.opacity)
                    }
                }
            }
        }
    }
}

#Preview {
    CreateMeetingView(roomName: "room_ABC123", password: "pass456")
}
