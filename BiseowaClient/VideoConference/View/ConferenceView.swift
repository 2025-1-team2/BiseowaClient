//
//  ConferenceView.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/4/25.
//

import SwiftUI

struct ConferenceView: View {
    let participants: [String] // ["User A", "User B", ...]

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                // 맨 위 중앙 고정 텍스트
                Text("경북대학교 회의방")
                    .font(.custom("Pretendard-Bold", size: 24))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)

                // 상단 우측 버튼
                HStack {
                    
                    ZStack{
                        //Spacer()
                       
                        Circle()
                            .fill(Color("BackgroundMint"))
                            .frame(width: 40, height: 40)
                        
                            Image(systemName: "envelope")
                                .font(.title2)
                                .foregroundColor(Color.black)
                                .padding()
                                .frame(width: 40,height: 40)
                                //.padding(.trailing,20)
                        
                    }
                    .offset(x:150)
                }
                Spacer()
                
                // 참가자 그리드
                participantGrid

                Spacer() // 아래로 밀기

                // 하단 아이콘 메뉴
                HStack(spacing: 40) {
                    Image(systemName: "video.fill")
                    Image(systemName: "mic.fill")
                    Image(systemName: "text.bubble.fill")
                    Image(systemName: "phone.down.fill")
                }
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 20)
            }
        }
    }

    // 유동적인 Grid 구성
    var participantGrid: some View {
        switch participants.count {
        case 1:
            return AnyView(
                VStack {
                    Spacer()
                    ParticipantView(name: participants[0], isLocalUser: participants[0] == "User C")
                        .frame(width: 200, height: 200)
                    Spacer()
                }
            )
        case 2:
            return AnyView(
                VStack(spacing: 16) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 200, height: 200)
                    }
                }
            )
        case 3:
            return AnyView(
                VStack(spacing: 12) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 180, height: 180)
                    }
                }
            )
        case 4:
            return AnyView(
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 2), spacing: 80) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 140, height: 140)
                    }
                }
            )
        case 5, 6:
            return AnyView(
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 1), count: 2), spacing: 80) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantView(name: name, isLocalUser: name == "User C")
                            .frame(width: 120, height: 120)
                    }
                }
            )
        default:
            return AnyView(EmptyView())
        }
    }

}


#Preview {
    Group {
        //ConferenceView(participants: ["User A"])
        //ConferenceView(participants: ["User A", "User B"])
        //ConferenceView(participants: ["User A", "User B", "User C"])
        //ConferenceView(participants: ["User A", "User B", "User C", "User D"])
        //ConferenceView(participants: ["User A", "User B", "User C", "User D", "User E"])
        ConferenceView(participants: ["User A", "User B", "User C", "User D", "User E", "User F"])
    }
}




