import SwiftUI
import LiveKit

struct CreateMeetingView: View {
    @StateObject private var meetingService = MeetingService()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var meetingURL: String
    @State private var meetingPassword: String
    @State private var showCopyToast = false
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
                        Image("logo").resizable().frame(width: 64, height: 75)
                        Text("비서와")
                            .font(.custom("Pretendard-Bold", size: 24))
                        Text("회의를 생성해볼까요?")
                            .font(.custom("Pretendard-Light", size: 15))
                            .foregroundColor(.gray)
                        HStack(spacing: 6) {
                            Circle().frame(width: 6, height: 6).foregroundColor(.mint)
                            Circle().frame(width: 6, height: 6).foregroundColor(.gray.opacity(0.4))
                        }
                        .hidden() // 동그라미 안 보이게 함
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    // 카드 컴포넌트
                    MeetingFormCard(
                        showCopy: true,
                        url: $meetingURL,
                        password: $meetingPassword,
                        buttonTitle: "회의 생성하기"
                    ) {
                        // 복사 + 토스트
                        let combined = "회의방 주소: \(meetingURL)\n회의방 비밀번호: \(meetingPassword)"
                        UIPasteboard.general.string = combined
                        withAnimation { showCopyToast = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showCopyToast = false }
                        }

                        // 생성 로직
                        meetingService.meetingPassword = password
                        meetingService.joinMeeting(
                            identity: authViewModel.user?.id ?? "guest",
                            roomName: roomName,
                            password: password
                        )
                    }

                    NavigationLink(
                        destination: JoinMeetingSumOXView(
                            receivedAddress: meetingService.roomName,
                            receivedPassword: meetingService.meetingPassword
                        ),
                        isActive: $meetingService.isConnected
                    ) {
                        EmptyView()
                    }
                }

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
