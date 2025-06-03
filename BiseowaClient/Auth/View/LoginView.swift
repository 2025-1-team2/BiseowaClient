//
//  LoginView.swift
//  MeetingApp
//
//  Created by 정수인 on 5/29/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // 로고
            Image("logo") // ← 피그마에서 넣은 이미지 이름
                .resizable()
                .scaledToFit()
                .frame(width: 80)

            // 앱 이름
            Text("비서와")
                .font(.custom("Pretendard-Bold", size: 24))

            // 설명 문구
            Text("함께, 효율적인 회의를 시작해요.")
                .font(.custom("Pretendard-Light", size: 15))
                .foregroundColor(.gray)

            Spacer().frame(height: 60)

            // 로그인 안내
            Text("로그인 / 회원가입")
                .font(.custom("Pretendard-SemiBold", size: 16))
            
            // 구글 로그인 버튼
            Button(action: {
                // 로그인 액션
            }) {
                HStack {
                    Image("googlelogo")
                        .resizable()
                        .frame(width: 40, height: 20)
                    
                    Text("Google로 시작하기")
                        .font(.custom("Pretendard-Regular", size: 16))
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.teal, lineWidth: 1)
                )
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 4)
            }
            .padding(.horizontal, 32)

            Spacer()
        }
        .padding()
    }
}


#Preview {
    LoginView()
}
