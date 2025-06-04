//
//  LoginView.swift
//  MeetingApp
//
//  Created by 정수인 on 5/29/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        switch viewModel.state {
        case .unauthenticated, .authenticating:
            loginContent
                .overlay {
                    if viewModel.state == .authenticating {
                        ProgressView("로그인 중...")
                    }
                }

        case .authenticated:
            HomeView()
        }
    }

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

            Button(action: {
                viewModel.googleLogin()
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
