//
//  MeetingFormCard.swift
//  BiseowaClient
//
//  Created by minji on 6/8/25.
//

import SwiftUI

struct MeetingFormCard: View {
    let showCopy: Bool
    @Binding var url: String
    @Binding var password: String

    let buttonTitle: String
    let onCopy: () -> Void
    let onSubmit: () -> Void

    var body: some View {
        ZStack {
            Color.white
                .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                .shadow(radius: 3)
                .ignoresSafeArea(edges: .bottom)

            VStack(alignment: .leading, spacing: 20) {

                // ─── ① 고정 높이 HStack ───────────────────────────
                HStack {
                    Text("회의방 주소")
                        .font(.custom("Pretendard-Regular", size: 14))
                    Spacer()
                    if showCopy {
                        Button(action: onCopy) {
                            Image(systemName: "doc.on.doc.fill")
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color("MypageButtonGreen"))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    } else {
                        // 복사 아이콘 대신 동일 크기의 빈 뷰
                        Color.clear
                            .frame(width: 32, height: 32)
                    }
                }
                // ★ 이 높이를 조정해서 label+button 영역의 높이를 고정 ★
                .frame(height: 32)

                // ─── ② 입력란 ──────────────────────────────────────
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .frame(height: 40)
                    .overlay(
                        TextField("회의 링크를 입력하세요", text: $url)
                            .font(.custom("Pretendard-Light", size: 14))
                            .padding(.horizontal, 12),
                        alignment: .leading
                    )

                // ─── ③ 비밀번호 라벨 & 입력란 ───────────────────────
                Text("회의방 비밀번호")
                    .font(.custom("Pretendard-Regular", size: 14))

                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(.systemGray6))
                    .frame(height: 40)
                    .overlay(
                        SecureField("비밀번호 입력", text: $password)
                            .font(.custom("Pretendard-Light", size: 14))
                            .padding(.horizontal, 12),
                        alignment: .leading
                    )

                // ─── ④ 제출 버튼 ───────────────────────────────────
                Button(action: onSubmit) {
                    Text(buttonTitle)
                        .font(.custom("Pretendard-Bold", size: 16))
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonNavy"))
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
        }
        .frame(height: 500)
    }
}
