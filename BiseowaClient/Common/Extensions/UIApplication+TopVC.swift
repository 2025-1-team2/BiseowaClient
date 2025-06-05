//
//  UIApplication+TopVC.swift
//  BiseowaClient
//
//  Created by 김수진 on 6/4/25.
//

import UIKit

// UIApplication 확장을 통해 현재 화면 상단에 표시되고 있는 UIViewController를 찾는 기능을 제공
extension UIApplication {
    
    /// 현재 앱에서 가장 상위에 위치한 UIViewController를 반환
    /// - Parameter base: 탐색을 시작할 루트 뷰 컨트롤러 (기본값은 앱의 최상단 루트 뷰 컨트롤러)
    /// - Returns: 최상단에서 표시되고 있는 UIViewController
    func topViewController(base: UIViewController? =
        // 현재 활성화된 UIWindowScene의 keyWindow에서 루트 뷰 컨트롤러를 가져옴
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first?.rootViewController) -> UIViewController? {

        // 네비게이션 컨트롤러인 경우, 현재 화면에 표시되는 뷰 컨트롤러를 재귀적으로 찾음
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }

        // 탭바 컨트롤러인 경우, 선택된 탭의 뷰 컨트롤러를 기준으로 다시 탐색
        if let tab = base as? UITabBarController,
           let selected = tab.selectedViewController {
            return topViewController(base: selected)
        }

        // 모달로 표시된 뷰 컨트롤러가 있다면, 그 컨트롤러를 기준으로 다시 탐색
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }

        // 더 이상 탐색할 뷰 컨트롤러가 없다면, 현재 뷰 컨트롤러 반환
        return base
    }
}


