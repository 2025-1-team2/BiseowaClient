import SwiftUI

struct JoinMeetingView: View {
    // ① 사용자 입력을 바인딩할 @State 변수
    @State private var meetingURL: String = ""
    @State private var meetingPassword: String = ""
    
    // ② 화면 전환 트리거용 상태 변수
    @State private var goToSumOX: Bool = false
    
    // ③ 입력값 검증용 얼럿 상태 변수
    @State private var showAlert: Bool = false
    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경색
            Color("BackgroundMint")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // ─── 상단 로고 및 인삿말 ─────────────────────
                VStack(spacing: 12) {
                    Spacer().frame(height: 60)
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 64, height: 75)
                    
                    Text("비서와")
                        .font(.custom("Pretendard-Bold", size: 24))
                    
                    Text("회의에 참가해볼까요?")
                        .font(.custom("Pretendard-Light", size: 15))
                        .foregroundColor(.gray)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.mint)
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.gray.opacity(0.4))
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // ─── 하단 흰색 카드 ─────────────────────────────
                ZStack {
                    Color.white
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .shadow(radius: 3)
                        .ignoresSafeArea(edges: .bottom)
                    
                    VStack(alignment: .leading, spacing: 20) {
                        // 회의방 주소
                        Text("회의방 주소")
                            .font(.custom("Pretendard-Regular", size: 14))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(height: 40)
                            .overlay(
                                TextField("회의 링크를 입력하세요", text: $meetingURL)
                                    .font(.custom("Pretendard-Light", size: 14))
                                    .padding(.horizontal, 12),
                                alignment: .leading
                            )
                        
                        // 회의방 비밀번호
                        Text("회의방 비밀번호")
                            .font(.custom("Pretendard-Regular", size: 14))
                        
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(height: 40)
                            .overlay(
                                SecureField("비밀번호 입력", text: $meetingPassword)
                                    .font(.custom("Pretendard-Light", size: 14))
                                    .padding(.horizontal, 12),
                                alignment: .leading
                            )
                        
                        // ─── “회의 참가하기” 버튼 ───────────────────
                        Button(action: {
                            // 1) 입력값 검증
                            if meetingURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                                meetingPassword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                showAlert = true
                            } else {
                                // 2) 둘 다 채워졌을 때 다음 화면으로 이동
                                goToSumOX = true
                            }
                        }) {
                            Text("회의 참가하기")
                                .font(.custom("Pretendard-Bold", size: 16))
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 150)
                                .background(Color("ButtonNavy"))
                                .cornerRadius(12)
                                .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 8)
                        // 3) 얼럿 띄우기
                        .alert("입력 오류", isPresented: $showAlert) {
                            Button("확인", role: .cancel) { }
                        } message: {
                            Text("회의 링크 и 비밀번호를 모두 입력해주세요.")
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                }
                .frame(height: 500)
            }
        }
        // 상위 NavigationStack의 Back 버튼을 숨기지 않도록 설정
        .navigationBarBackButtonHidden(false)
        // 네비게이션 바 전체를 보여줌
        .navigationBarHidden(false)
        
        // ─── navigationDestination으로 JoinMeetingSumOXView 호출 ──
        .navigationDestination(isPresented: $goToSumOX) {
            JoinMeetingSumOXView(
                receivedAddress: meetingURL,
                receivedPassword: meetingPassword
            )
        }
    }
}

#Preview {
    JoinMeetingView()
}
