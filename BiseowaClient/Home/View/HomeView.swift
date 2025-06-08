import SwiftUI

struct HomeView: View {
    @State private var showCreate = false
    @State private var showJoin = false
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var isLoggingOut = false
    @StateObject private var meetingService = MeetingService()
    @State private var createdRoomInfo: (roomName: String, password: String)? = nil

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                VStack(spacing: 0) {

                    // MARK: - 상단 민트 배경
                    ZStack(alignment: .topLeading) {
                        Color("BackgroundMint")
                            .frame(height: geometry.size.height * 0.45)
                            .edgesIgnoringSafeArea(.top)
                            .shadow(radius: 1, y: 1)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("비서와")
                                .font(.custom("Pretendard-Bold", size: 24))
                                .bold()
                                .padding(.leading, 16)

                            Text("함께, 효율적인 회의를")
                                .font(.custom("Pretendard-Light", size: 17))
                                .foregroundColor(.gray)
                                .padding(.leading, 16)

                            Spacer().frame(height: 60)

                            HStack {
                                Spacer()
                                VStack(alignment: .trailing, spacing: 6) {
                                    (
                                        Text(authViewModel.user?.name ?? "사용자")
                                        .font(.custom("Pretendard-SemiBold", size: 30))
                                        .bold()
                                     +
                                     Text("님,")
                                        .font(.custom("Pretendard-Light", size: 30)))
                                    Text("반가워요.")
                                        .font(.custom("Pretendard-Light", size: 30))
                                        .foregroundColor(.gray)
                                }
                                Image("logo")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60)
                                    //.aspectRatio(contentMode: .fit)   // or .scaledToFit()
                                    //.frame(width: 60, height: 60)
                                    //.frame(width: 60, height: 64)
                                    .foregroundColor(.teal)
                            }
                        }
                        .padding()
                    }

                    // MARK: - 회의 버튼들
                    VStack(spacing: 16) {
                        Button(action: {
                            showJoin = true
                        }) {
                            HStack {
                                Image(systemName: "video.fill")
                                Text("회의 참가")
                                    .font(.custom("Pretendard-Light", size: 17))
                            }
                            .frame(width: 242, height: 40)
                            .padding()
                            .background(Color(red: 34/255, green: 48/255, blue: 112/255))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 1, y: 1)
                        }

                        Button(action: {
                            // 회의 생성 요청
                                if let identity = authViewModel.user?.id {
                                    meetingService.createMeeting(identity: identity) { result in
                                        switch result {
                                        case .success(let (roomName, password)):
                                            self.createdRoomInfo = (roomName, password)
                                            self.showCreate = true
                                        case .failure(let error):
                                            print("❌ 회의 생성 실패: \(error)")
                                        }  
                                    }
                                }
                        }) {
                            HStack {
                                Image(systemName: "plus")
                                Text("회의 생성")
                                    .font(.custom("Pretendard-Light", size: 17))
                            }
                            .frame(width: 242, height: 40)
                            .padding()
                            .background(Color(red: 102/255, green: 180/255, blue: 180/255))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: 1, y: 1)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 32)

                    // MARK: - 마이페이지 / 회의록
                    HStack(spacing: 16) {
                        VStack {
                            Image(systemName: "person.fill")
                                .font(.largeTitle)
                            Text("마이페이지")
                        }
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Color(red: 50/255, green: 130/255, blue: 130/255))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 1, y: 1)

                        VStack {
                            Image(systemName: "calendar")
                                .font(.largeTitle)
                            Text("회의록")
                        }
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(Color(red: 50/255, green: 130/255, blue: 130/255))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                        .shadow(radius: 1, y: 1)
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    
                    
                    // MARK: - 로그아웃
                    if isLoggingOut {
                        ProgressView("로그아웃 중...")
                            .padding(.bottom, 30)
                    } else {
                        Button(action: {
                            isLoggingOut = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                authViewModel.user = nil
                                authViewModel.state = .unauthenticated
                                isLoggingOut = false
                            }
                        }) {
                            Text("로그아웃")
                                .foregroundColor(.black)
                                .font(.custom("Pretendard-Regular", size: 10))
                                .padding()
                        }
                        .padding()
                        Spacer()
                    }
                }
                .navigationDestination(isPresented: $showCreate) {
                    if let info = createdRoomInfo {
                        CreateMeetingView(roomName: info.roomName, password: info.password)
                    }
                }
                .navigationDestination(isPresented: $showJoin) {
                    JoinMeetingView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
