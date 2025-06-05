//
//  JoinMeetingSumOX.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/5/25.
//

import SwiftUI

struct JoinMeetingSumOXView: View {
    var body: some View {
        ZStack(alignment: .top) {
            Color("BackgroundMint")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // 상단 영역
                VStack(spacing: 12) {
                    Spacer().frame(height: 60)

                    Image("logo")
                        .resizable()
                        .frame(width: 64, height: 75)

                    Text("비서가")
                        .font(.custom("Pretendard-Bold", size: 24))

                    Text("요약해드릴까요?")
                        .font(.custom("Pretendard-Light", size: 15))
                        .foregroundColor(.gray)

                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.gray.opacity(0.4))
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.mint)
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity)

                Spacer()

                // 하단 카드
                ZStack {
                    Color.white
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .shadow(radius: 3)
                        .ignoresSafeArea(edges: .bottom)

                    HStack(spacing: 24) {
                        Button(action: {
                            // 네 버튼 로직
                        }) {
                            Text("네")
                                .font(.custom("Pretendard-SemiBold", size: 16))
                                .foregroundColor(.black)
                                .frame(width: 100, height: 44)
                                .background(Color("BackgroundMint"))
                                .cornerRadius(10)
                        }

                        Button(action: {
                            // 아니요 버튼 로직
                        }) {
                            Text("아니요")
                                .font(.custom("Pretendard-SemiBold", size: 16))
                                .foregroundColor(.black)
                                .frame(width: 100, height: 44)
                                .background(Color(.systemGray5))
                                .cornerRadius(10)
                        }
                    }
                    .padding(.top)
                }
                .frame(height: 500)
            }
        }
    }
}

#Preview {
    JoinMeetingSumOXView()
}
