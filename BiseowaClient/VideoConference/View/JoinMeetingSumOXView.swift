//
//  JoinMeetingSumOX.swift
//  BiseowaClient
//
//  Created by 정수인 on 6/5/25.
//

import SwiftUI

struct JoinMeetingSumOXView: View {
    @StateObject private var meetingService = MeetingService()
    @EnvironmentObject var authViewModel: AuthViewModel
    // ① 앞 화면에서 받아올 데이터
    let receivedAddress: String
    let receivedPassword: String

    // ② 다음 화면(ConferenceView)으로 넘어갈지 여부를 제어하는 상태
    @State private var goToConference: Bool = false
    /// 요약 생성 여부를 전달하기 위한 상태 변수
    @State private var shouldCreateSummary: Bool = true

    
    var body: some View {
        ZStack(alignment: .top) {
            // 배경
            Color("BackgroundMint")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // ─── 상단 로고/메시지 ───────────────────────────────
                VStack(spacing: 12) {
                    Spacer().frame(height: 60)

                    Image("logo")
                        .resizable()
                        .frame(width: 64, height: 75)

                    Text("비서가")
                        .font(.custom("Pretendard-Bold", size: 24))

                    Text("요약해드릴까요?")
                        .font(.custom("Pretendard-Light", size: 15))
                        .foregroundColor(.gray)

                    HStack(spacing: 6) {
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.gray.opacity(0.4))
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.mint)
                    }
                    .padding(.top, 8)
                }
                .frame(maxWidth: .infinity)

                Spacer()

                // ─── 하단 카드 ───────────────────────────────────────
                ZStack {
                    Color.white
                        .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                        .shadow(radius: 3)
                        .ignoresSafeArea(edges: .bottom)

                    VStack(spacing: 24) {
                        // (선택) 전달받은 주소/비밀번호를 UI에 보여주고 싶다면 아래를 언주석
                        // Text("회의방 주소: \(receivedAddress)")
                        //     .font(.custom("Pretendard-Regular", size: 14))
                        //     .foregroundColor(.black)
                        //
                        // Text("비밀번호: \(receivedPassword)")
                        //     .font(.custom("Pretendard-Regular", size: 14))
                        //     .foregroundColor(.black)

                        HStack(spacing: 24) {
                            // “네” 버튼 누르면 goToConference를 true로
                            Button(action: {
                                shouldCreateSummary = true
                                goToConference = true
                            }) {
                                Text("네")
                                    .font(.custom("Pretendard-SemiBold", size: 16))
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 44)
                                    .background(Color("BackgroundMint"))
                                    .cornerRadius(10)
                            }

                            // “아니요” 버튼도 동일하게 ConferenceView로 보냄
                            Button(action: {
                                shouldCreateSummary = false
                                goToConference = true
                            }) {
                                Text("아니요")
                                    .font(.custom("Pretendard-SemiBold", size: 16))
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 44)
                                    .background(Color(.systemGray5))
                                    .cornerRadius(10)
                            }
                        }
                        .padding(.top, 32)

                        Spacer()
                    }
                    .padding(.top, 32)
                }
                .frame(height: 500)
            }
        }
        .navigationBarBackButtonHidden(false)
        .navigationBarHidden(false)

        NavigationLink(
            destination: ConferenceView(createSummary: shouldCreateSummary)
                .environmentObject(meetingService)
                .environmentObject(authViewModel),
            isActive: $goToConference
        ) {
            EmptyView()
        }
        .hidden()
    }
}


#Preview {
    JoinMeetingSumOXView(
        receivedAddress: "https://example.com/testRoom",
        receivedPassword: "1234"
    )
}
