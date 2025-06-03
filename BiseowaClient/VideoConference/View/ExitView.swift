//
//  ExitView.swift
//  MeetingApp
//
//  Created by 정수인 on 5/29/25.
//

import SwiftUI


struct ExitView: View {
    var body: some View {
        ZStack {
            Color("BackgroundMint")
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 64, height: 75)
                
                Text("비서가")
                    .font(.custom("Pretendard-Bold", size: 24))
                
                Text("회의 내용 요약본을\n메일로 전송했어요!")
                    .font(.custom("Pretendard-Light", size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .padding()
        }
    }
}



#Preview {
    ExitView()
}
