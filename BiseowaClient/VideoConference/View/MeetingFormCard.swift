//
//  MeetingFormCard.swift
//  BiseowaClient
//
//  Created by minji on 6/8/25.
//

import SwiftUI

// 공통으로 쓰일 회의 입력 카드 컴포넌트
struct MeetingFormCard: View {
    let showCopy: Bool
    @Binding var url: String
    @Binding var password: String
    let buttonTitle: String
    let buttonAction: () -> Void

    var body: some View {
        ZStack {
            Color.white
                .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                .shadow(radius: 3)
                .ignoresSafeArea(edges: .bottom)

            VStack(alignment: .leading, spacing: 20) {
                Text("회의방 주소")
                    .font(.custom("Pretendard-Regular", size: 14))

                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(.systemGray6))
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            TextField("회의 링크를 입력하세요", text: $url)
                                .font(.custom("Pretendard-Light", size: 14))
                                .padding(.horizontal, 12),
                            alignment: .leading
                        )

                    if showCopy {
                        Button(action: buttonAction) {
                            Image(systemName: "doc.on.doc.fill")
                                .foregroundColor(.white)
                                .padding(10)
                                .background(Color("MypageButtonGreen"))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                        .offset(y: -60)
                        .padding(.trailing, 8)
                    } else {
                        Color.clear.frame(width: 40, height: 40)
                    }
                }

                Text("회의방 비밀번호")
                    .font(.custom("Pretendard-Regular", size: 14))

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .overlay(
                        SecureField("비밀번호 입력", text: $password)
                            .font(.custom("Pretendard-Light", size: 14))
                            .padding(.horizontal, 12),
                        alignment: .leading
                    )

                Button(action: buttonAction) {
                    Text(buttonTitle)
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

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
        .frame(height: 500)
    }
}
