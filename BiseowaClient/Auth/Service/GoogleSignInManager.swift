//
//  GoogleSignInManager.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/4/25.
//
// Auth/Service/GoogleSignInManager.swift

import UIKit
import FirebaseAuth
import FirebaseCore
import GoogleSignIn

enum GoogleAuthError: Error {
    case missingClientID
    case missingToken
    case noRootViewController
}

final class GoogleAuthService {
    static let shared = GoogleAuthService()
    
    /// Google 로그인 → Firebase 사용자 반환
    func signIn(completion: @escaping (Result<User, Error>) -> Void) {
        print("1️⃣ [GoogleAuthService] signIn() called")
        // 1. Firebase 프로젝트의 clientID 가져오기
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            print("❌ [GoogleAuthService] Missing clientID")
            completion(.failure(GoogleAuthError.missingClientID))
            return
        }

  
        let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
       

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first,
                  let rootViewController = window.rootViewController else { return }
        print("3️⃣ [GoogleAuthService] Presenting Google Sign-In UI")
        // 4. OAuth 플로우 시작
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] result, error in
                    
                if let error {
                    completion(.failure(error))
                    return
                }
            // 5. 토큰 꺼내기
            guard let user = result?.user, let idToken = user.idToken?.tokenString else {
                        completion(.failure(GoogleAuthError.missingToken))
                        return
                    }
            let accessToken = user.accessToken.tokenString
            // 6. Firebase 자격증명 생성 & 로그인
            print("[GoogleAuthService]")
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: accessToken
            )

            self?.authenticateWithFirebase(credential, completion: completion)
        }
    }

    // FirebaseAuth 로그인 헬퍼
    private func authenticateWithFirebase(
        _ credential: AuthCredential,
        completion: @escaping (Result<User, Error>) -> Void
    ) {
        Auth.auth().signIn(with: credential) { result, error in
            if let error { completion(.failure(error)); return }

            guard let user = result?.user else {
                completion(.failure(GoogleAuthError.missingToken))
                return
            }

            let appUser = User(
                id: user.uid,
                name: user.displayName ?? "",
                phoneNumber: user.phoneNumber,
                profileURL: user.photoURL?.absoluteString
            )
            completion(.success(appUser))
        }
    }
}

/// 간단한 App-내 User 모델
struct User {
    let id: String
    let name: String
    let phoneNumber: String?
    let profileURL: String?
}

