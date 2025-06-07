import SwiftUI
import LiveKit

struct JoinMeetingView: View {
    @State private var meetingURL: String = ""
    @State private var meetingPassword: String = ""
    @State private var goToSumOX: Bool = false
    @State private var showAlert: Bool = false

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
                        Text("회의에 참가해볼까요?")
                            .font(.custom("Pretendard-Light", size: 15))
                            .foregroundColor(.gray)
                        HStack(spacing: 6) {
                            Circle().frame(width: 6, height: 6).foregroundColor(.mint)
                            Circle().frame(width: 6, height: 6).foregroundColor(.gray.opacity(0.4))
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)

                    Spacer()

                    // 카드 컴포넌트 (복사 버튼 없음)
                    MeetingFormCard(
                        showCopy: false,
                        url: $meetingURL,
                        password: $meetingPassword,
                        buttonTitle: "회의 참가하기"
                    ) {
                        if meetingURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                           meetingPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showAlert = true
                        } else {
                            goToSumOX = true
                        }
                    }
                }
                .alert("입력 오류", isPresented: $showAlert) {
                    Button("확인", role: .cancel) { }
                } message: {
                    Text("회의 링크와 비밀번호를 모두 입력해주세요.")
                }
                .navigationDestination(isPresented: $goToSumOX) {
                    JoinMeetingSumOXView(
                        receivedAddress: meetingURL,
                        receivedPassword: meetingPassword
                    )
                }
            }
            .navigationBarBackButtonHidden(false)
            .navigationBarHidden(false)
        }
    }
}

#Preview {
    JoinMeetingView()
}
