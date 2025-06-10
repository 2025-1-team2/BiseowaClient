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

    @State private var meetingURL: String
    @State private var meetingPassword: String

    @State private var showCopyToast = false
    @State private var navigateToConference = false

    let receivedAddress: String
    let receivedPassword: String

    init(roomName: String, password: String) {
        self.receivedAddress = roomName
        self.receivedPassword = password
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
                        Image("logo").resizable().frame(width: 64, height: 75)
                        Text("비서와").font(.custom("Pretendard-Bold", size: 24))
                        Text("회의를 생성해볼까요?")
                            .font(.custom("Pretendard-Light", size: 15))
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    // 입력 카드: 복사/생성 액션 분리
                    MeetingFormCard(
                        showCopy: true,
                        url: $meetingURL,
                        password: $meetingPassword,
                        buttonTitle: "회의 생성하기",
                        onCopy: {
                            // 복사만!
                            let combined = "회의방 주소: \(meetingURL)\n회의방 비밀번호: \(meetingPassword)"
                            UIPasteboard.general.string = combined
                            withAnimation { showCopyToast = true }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                withAnimation { showCopyToast = false }
                            }
                        },
                        onSubmit: {
                            // 회의 생성 & 이동만!

                            navigateToConference = true
                        }
                    )

                    // 생성 성공 시 바로 ConferenceView 로 이동
                    NavigationLink(
                        destination: ConferenceView(
                            //participants: [authViewModel.user?.id ?? "guest"],
                            createSummary: false,roomName: receivedAddress,password: receivedPassword
                        )
                        .environmentObject(meetingService)
                        .environmentObject(authViewModel),
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
        .environmentObject(AuthViewModel())
}
