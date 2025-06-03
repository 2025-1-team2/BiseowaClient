//
//  ParticipantView.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/4/25.
//

import SwiftUI

struct ParticipantView: View {
    let name: String
    let isLocalUser: Bool

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                // 더 큰 네모 박스
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.white)
                    .frame(width: 150, height: 150) // 네모 크기 키움

                // 사람 아이콘을 작게 (여백 생기도록)
                Image(systemName: "person.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80) // 👈 작게 줄임
                    .foregroundColor(isLocalUser ? Color("BackgroundMint") : .black)
            }
            Text(name)
                .font(.caption)
                .foregroundColor(.black)
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color(.systemGray5))
                .cornerRadius(10)
        }
        .padding(6)
    }
}


