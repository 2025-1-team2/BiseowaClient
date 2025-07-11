//
//  BiseowaClient.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/3/25.
//

// App/App.swift 또는 BiseowaClientApp.swift
import SwiftUI

@main //메인 함수(시작!)
struct BiseowaClientApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()
    
    var body: some Scene {
        WindowGroup {
            SplashView()
                .environmentObject(authViewModel)
        }
    }
}

