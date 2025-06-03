//
//  SplashView.swift
//  런치 화면 
//  Created by 정수인 on 5/29/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            // 배경 색
            Color(red: 224/255, green: 242/255, blue: 241/255)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Spacer()

                // 로고 이미지
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60)

                // 텍스트
                Text("비서와")
                    .font(.custom("Pretendard-Bold", size: 36))
                    .foregroundColor(Color(red: 0/255, green: 153/255, blue: 136/255))
                    

                Spacer()
            }

        }
    }
}

#Preview{
    SplashView()
}
