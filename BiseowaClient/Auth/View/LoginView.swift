//
//  LoginView.swift
//  MeetingApp
//
//  Created by 정수인 on 5/29/25.
//

import SwiftUI

struct LoginView: View {
    // 로그인 상태를 관리하는 ViewModel
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        // 로그인 상태에 따라 다른 화면 표시
        switch viewModel.state {
        case .unauthenticated, .authenticating:
            // 로그인 전 또는 로그인 중인 상태
            loginContent
                .overlay {
                    if viewModel.state == .authenticating {
                        // 로그인 중이면 로딩 인디케이터 표시
                        ProgressView("로그인 중...")
                    }
                }

        case .authenticated:
            // 로그인 성공 시 홈 화면으로 전환
            HomeView()
        }
    }
    
    /// 로그인 화면 구성
    var loginContent: some View {
        VStack(spacing: 24) {
            Spacer()

            Image("logo")
                .resizable()
                .scaledToFit()
                .frame(width: 80)

            Text("비서와")
                .font(.custom("Pretendard-Bold", size: 24))

            Text("함께, 효율적인 회의를 시작해요.")
                .font(.custom("Pretendard-Light", size: 15))
                .foregroundColor(.gray)

            Spacer().frame(height: 60)

            Text("로그인 / 회원가입")
                .font(.custom("Pretendard-SemiBold", size: 16))

            // Google 로그인 버튼
            Button(action: {
                viewModel.googleLogin() // 구글 로그인 요청
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

            // 로그인 실패 시 에러 메시지 표시
            if let error = viewModel.errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
        .padding()
    }
}



#Preview {
    LoginView()
}
