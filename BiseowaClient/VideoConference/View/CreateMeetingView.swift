import SwiftUI

struct CreateMeetingView: View {
    @State private var meetingURL: String = ""
    @State private var meetingPassword: String = ""

    var body: some View {
        ZStack(alignment: .top) {
            Color("BackgroundMint")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 로고 및 인삿말
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

                // 하단 흰색 카드
                ZStack {
                    Color.white
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .shadow(radius: 3)
                        .ignoresSafeArea(edges: .bottom)

                    VStack(alignment: .leading, spacing: 20) {
                        // 회의방 주소
                        Text("회의방 주소")
                            .font(.custom("Pretendard-Regular", size: 14))

                        ZStack(alignment: .trailing) {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .frame(height: 40)
                                .overlay(
                                    TextField("회의 링크를 입력하세요", text: $meetingURL)
                                        .font(.custom("Pretendard-Light", size: 14))
                                        .padding(.horizontal, 12),
                                    alignment: .leading
                                )

                            Text(meetingURL)
                                .font(.custom("Pretendard-Light", size: 14))
                                .padding(.leading, 12)
                                .frame(maxWidth: .infinity, alignment: .leading)

                            Button(action: {
                                UIPasteboard.general.string = meetingURL
                            }) {
                                Image(systemName: "doc.on.doc.fill")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Color("MypageButtonGreen"))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                    
                            }
                            .offset(y:-60)
                            .padding(.trailing, 8)
                        }

                        // 회의방 비밀번호
                        Text("회의방 비밀번호")
                            .font(.custom("Pretendard-Regular", size: 14))

                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color(.systemGray6))
                            .frame(height: 40)
                            .overlay(
                                Text(meetingPassword)
                                    .font(.custom("Pretendard-Light", size: 14))
                                    .padding(.leading, 12),
                                alignment: .leading
                            )
                            .overlay(
                                TextField("회의 비밀번호를 입력하세요", text: $meetingURL)
                                    .font(.custom("Pretendard-Light", size: 14))
                                    .padding(.horizontal, 12),
                                alignment: .leading
                            )

                        // 회의 참가 버튼
                        Button(action: {
                            // 참가 로직
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
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 32)
                }
                .frame(height: 500)
            }
        }
    }
}

#Preview {
    CreateMeetingView()
}
