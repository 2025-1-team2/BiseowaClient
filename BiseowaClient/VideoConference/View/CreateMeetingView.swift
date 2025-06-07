import SwiftUI
import LiveKit

struct CreateMeetingView: View {
    @StateObject private var meetingService = MeetingService()
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var navigateToNext = false
    @State private var meetingURL: String
    @State private var meetingPassword: String
    let receivedAddress: String
    let receivedPassword: String
    let roomName: String
    let password: String
        
    @State private var room: Room? = nil
    @State private var isConnecting = false
    @State private var errorMessage: String? = nil

    init(roomName: String, password: String) {
        self.roomName = roomName
        self.password = password
        self.receivedAddress = roomName         // 추가
        self.receivedPassword = password        // 추가
        _meetingURL = State(initialValue: roomName)
        _meetingPassword = State(initialValue: password)
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                Color("BackgroundMint")
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // 상단 로고 및 인삿말
                    VStack(spacing: 12) {
                        Spacer().frame(height: 60)
                        
                        Image("logo")
                            .resizable()
                            .frame(width: 64, height: 75)
                        
                        Text("비서와")
                            .font(.custom("Pretendard-Bold", size: 24))
                        
                        Text("회의를 생성해볼까요?")
                            .font(.custom("Pretendard-Light", size: 15))
                            .foregroundColor(.gray)
                        
                        HStack(spacing: 6) {
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.mint)
                            Circle()
                                .frame(width: 6, height: 6)
                                .foregroundColor(.gray.opacity(0.4))
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                    // 하단 카드
                    ZStack {
                        Color.white
                            .clipShape(RoundedCorner(radius: 24, corners: [.topLeft, .topRight]))
                            .shadow(radius: 3)
                            .ignoresSafeArea(edges: .bottom)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("회의방 주소")
                                .font(.custom("Pretendard-Regular", size: 14))
                            
                            ZStack(alignment: .trailing) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 40)
                                    .overlay(
                                        TextField("회의 링크를 입력하세요", text: $meetingURL)
                                            .font(.custom("Pretendard-Light", size: 14))
                                            .padding(.horizontal, 12),
                                        alignment: .leading
                                    )
                                
                                Button(action: {
                                    UIPasteboard.general.string = meetingURL
                                }) {
                                    Image(systemName: "doc.on.doc.fill")
                                        .foregroundColor(.white)
                                        .padding(10)
                                        .background(Color("MypageButtonGreen"))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .offset(y: -60)
                                .padding(.trailing, 8)
                            }
                            
                            Text("회의방 비밀번호")
                                .font(.custom("Pretendard-Regular", size: 14))
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(.systemGray6))
                                .frame(height: 40)
                                .overlay(
                                    TextField("회의 비밀번호를 입력하세요", text: $meetingPassword)
                                        .font(.custom("Pretendard-Light", size: 14))
                                        .padding(.horizontal, 12),
                                    alignment: .leading
                                )
                            
                            // ✅ 회의 생성하기 버튼 (텍스트만 변경됨)
                            Button(action: {
                                meetingService.meetingPassword = password
                                meetingService.joinMeeting(
                                    identity: authViewModel.user?.id ?? "guest",
                                    roomName: roomName,
                                    password: password
                                )
                            }) {
                                Text("회의 생성하기") // ✅ 여기만 바뀜!
                                    .font(.custom("Pretendard-Bold", size: 16))
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(width: 150)
                                    .background(Color("ButtonNavy"))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.15), radius: 2, y: 1)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 8)
                            
                            NavigationLink(
                                destination: JoinMeetingSumOXView(
                                    receivedAddress: meetingService.roomName,
                                    receivedPassword: meetingService.meetingPassword
                                ),
                                isActive: $meetingService.isConnected
                            ) {
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 32)
                    }
                    .frame(height: 500)
                }
            }
        }
    }
}


#Preview {
    CreateMeetingView(roomName: "room_ABC123", password: "pass456")
}


