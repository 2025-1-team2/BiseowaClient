//
//  CreateMeetingView.swift
//  MeetingApp
//
//  Created by 정수인 on 5/29/25.
//

import SwiftUI


struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


struct CreateMeetingView: View {
    @State private var address: String = ""
    @State private var password: String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // 상단 민트 배경 영역
                ZStack(alignment: .top) {
                    // 민트색 배경
                    Color("BackgroundMint")
                        .ignoresSafeArea()

                    VStack(spacing: 16) {
                        Spacer().frame(height: 40) // 상단 여백

                        // 로고 + 텍스트
                        VStack(spacing: 4) {
                            Image("logo")
                                .resizable()
                                .frame(width: 64, height: 64)

                            Text("비서와")
                                .font(.custom("Pretendard-Bold", size: 24))

                            Text("회의를 만들어볼까요?")
                                .font(.custom("Pretendard-Light", size: 15))
                                .foregroundColor(.gray)
                        }

                        Spacer()
                    }

                    // 아래 흰색 카드 영역
                    VStack(spacing: 24) {
                        TextField("주소", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        SecureField("비밀번호", text: .constant(""))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)

                        Button(action: {
                            // 회의 생성 액션
                        }) {
                            Text("회의 생성하기")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("ButtonNavy"))
                                .cornerRadius(12)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(24, corners: [.topLeft, .topRight]) // ✨ 핵심
                    .ignoresSafeArea(edges: .bottom)
                    .padding(.top, 240) // 로고 영역 피해서 아래로 내림
                }

            }
        }
    }
}

#Preview {
    CreateMeetingView()
}
