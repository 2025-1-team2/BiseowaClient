//
//  AppDelegate.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/4/25.
//

import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import UIKit

// 앱의 전반적인 생명주기와 푸시 알림 설정 등을 관리하는 클래스
class AppDelegate: NSObject, UIApplicationDelegate {
    
    // 앱이 실행될 때 호출되는 메서드 (초기 설정을 여기서 수행)
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        // 원격 알림(푸시 알림) 등록 -> 아직 필요없음
        application.registerForRemoteNotifications()
        // 알림 수신 시 동작을 처리할 대리자(delegate) 지정 -> 이것도 필요없음
        UNUserNotificationCenter.current().delegate = self
        // Firebase 초기화 (필수)
        FirebaseApp.configure()
        
        return true
    }
    // 구글 로그인 등의 인증 콜백을 처리하는 메서드 (OAuth 인증 후 앱으로 돌아올 때 호출됨)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        // 구글 로그인 인증 결과 처리
      return GIDSignIn.sharedInstance.handle(url)
    }
}

// 푸시 알림 관련 처리
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 실행 중일 때 알림이 도착하면 어떤 방식으로 표시할지 지정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .banner])// 배지와 배너 형태로 표시
    }
    // 사용자가 알림을 클릭했을 때의 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()// 사용자가 알림을 클릭했을 때의 처리
    }
}
