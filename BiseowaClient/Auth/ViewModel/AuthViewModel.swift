//
//  AuthViewModel.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/4/25.
//


import Combine
import SwiftUI

enum AuthState { case unauthenticated, authenticating, authenticated }

@MainActor
final class AuthViewModel: ObservableObject {

    @Published var state: AuthState = .unauthenticated
    @Published var user: User?
    @Published var errorMessage: String?
    
    // 한국어로 된 오류 메시지 처리
    private func koreanErrorMessage(for error: Error) -> String {
        let nsError = error as NSError

        switch nsError.code {
        case 17020: // network error
            return "네트워크 오류가 발생했어요. 인터넷 연결을 확인해주세요."
        case 17005: // user-disabled
            return "이 계정은 비활성화되어 있어요."
        case 17009: // wrong-password
            return "비밀번호가 틀렸어요."
        case 17008: // invalid-email
            return "이메일 형식이 잘못되었어요."
        case 17004: // account-exists-with-different-credential
            return "다른 로그인 방식으로 이미 가입된 계정이에요."
        default:
            return "로그인에 실패했어요. 다시 시도해주세요."
        }
    }

    func googleLogin() {
        state = .authenticating

        GoogleAuthService.shared.signIn { [weak self] (result: Result<User, Error>) in
            switch result {
            case .success(let user):
                self?.user  = user
                self?.state = .authenticated
            case .failure(let error):
                self?.errorMessage = self?.koreanErrorMessage(for: error) 
                self?.state = .unauthenticated
            }
        }
    }
}
