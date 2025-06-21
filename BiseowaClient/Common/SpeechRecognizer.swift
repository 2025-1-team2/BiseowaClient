//
//  SpeechRecognizer.swift
//  BiseowaClient
//
//  Created by minji on 6/22/25.
//  음성 인식본을 '.' 마다 전송하는 버전


import Foundation
import Speech
import AVFoundation

class SpeechRecognizer: ObservableObject {
    private let audioEngine = AVAudioEngine()
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?

    // 1) didSet 추가
    @Published var recognizedText: String = "" {
        didSet {
            // 2) 마침표가 들어오면
            if recognizedText.contains(".") {
                // 전체 텍스트를 마침표 단위로 split
                let parts = recognizedText.split(separator: ".")
                // 맨 마지막 부분(미완성 문장)을 제외한 나머지 문장들만 보낸다
                let sentencesToSend = parts.dropLast()
                    .map { String($0).trimmingCharacters(in: .whitespaces) + "." }

                for sentence in sentencesToSend {
                    sendSentence(sentence)
                }

                // 3) 이미 보낸 문장 제거하고, 미완성 문장만 남기기
                if let last = parts.last {
                    recognizedText = String(last)
                } else {
                    recognizedText = ""
                }
            }
        }
    }

    func startRecording() {
        SFSpeechRecognizer.requestAuthorization { status in
            guard status == .authorized else { return }
            DispatchQueue.main.async { self.startRecognition() }
        }
    }

    private func startRecognition() {
        let session = AVAudioSession.sharedInstance()
        try? session.setCategory(.record, mode: .measurement)
        try? session.setActive(true)

        request = SFSpeechAudioBufferRecognitionRequest()
        request?.requiresOnDeviceRecognition = true
        request?.shouldReportPartialResults = true

        guard let request = request else { return }
        let inputNode = audioEngine.inputNode


        recognitionTask = recognizer.recognitionTask(with: request) { result, error in
            if let result = result {
                DispatchQueue.main.async {
                    self.recognizedText = result.bestTranscription.formattedString
                }
            }
            if error != nil || (result?.isFinal ?? false) {
                self.stopRecording()
            }
        }

        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, when in
            self.request?.append(buffer)
        }

        audioEngine.prepare()
        try? audioEngine.start()
    }

    func stopRecording() {
        audioEngine.stop()
        request?.endAudio()
        recognitionTask?.cancel()
    }
    
    // MARK: - 문장 단위 전송 헬퍼
    private func sendSentence(_ sentence: String) {
        NetworkManager.shared.sendSummaryRequest(text: sentence) { result in
            switch result {
            case .success(let summary):
                print("✅ 보낸 문장: \(sentence)")
                print("   → 받은 요약: \(summary)")
                // 필요하면 @Published var summaryList.append(summary) 등 추가
            case .failure(let error):
                print("❌ 전송 실패 (\(sentence)): \(error)")
            }
        }
    }
}


/*
 //
 //  SpeechRecognizer.swift
 //  BiseowaClient
 //
 //  Created by minji on 6/22/25.
 //  음성 인식본을 5초마다 자동 전송하는 버전

 import Foundation
 import Speech
 import AVFoundation

 class SpeechRecognizer: ObservableObject {
     // MARK: – 음성 인식 관련
     private let audioEngine = AVAudioEngine()
     private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "ko-KR"))!
     private var request: SFSpeechAudioBufferRecognitionRequest?
     private var recognitionTask: SFSpeechRecognitionTask?
     
     // MARK: – 주기 전송 타이머
     private var sendTimer: Timer?
     private let sendInterval: TimeInterval = 5  // 초 단위 주기

     // MARK: – 퍼블리시 텍스트
     @Published var recognizedText: String = ""

     // MARK: – 녹음/인식 시작
     func startRecording() {
         SFSpeechRecognizer.requestAuthorization { status in
             guard status == .authorized else { return }
             DispatchQueue.main.async {
                 self.startRecognition()
                 self.startSendingInterval()
             }
         }
     }

     private func startRecognition() {
         let session = AVAudioSession.sharedInstance()
         try? session.setCategory(.record, mode: .measurement)
         try? session.setActive(true)

         request = SFSpeechAudioBufferRecognitionRequest()
         request?.requiresOnDeviceRecognition = true
         request?.shouldReportPartialResults = true

         guard let request = request else { return }
         let inputNode = audioEngine.inputNode

         recognitionTask = recognizer.recognitionTask(with: request) { result, error in
             if let result = result {
                 DispatchQueue.main.async {
                     self.recognizedText = result.bestTranscription.formattedString
                 }
             }
             if error != nil || (result?.isFinal ?? false) {
                 self.stopRecording()
             }
         }

         let format = inputNode.outputFormat(forBus: 0)
         inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
             self.request?.append(buffer)
         }

         audioEngine.prepare()
         try? audioEngine.start()
     }

     // MARK: – 녹음/인식 중지
     func stopRecording() {
         audioEngine.stop()
         request?.endAudio()
         recognitionTask?.cancel()
         stopSendingInterval()
     }

     // MARK: – 타이머로 주기 전송
     private func startSendingInterval() {
         sendTimer = Timer.scheduledTimer(withTimeInterval: sendInterval, repeats: true) { [weak self] _ in
             guard let self = self,
                   !self.recognizedText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
             else { return }

             let textToSend = self.recognizedText
             NetworkManager.shared.sendSummaryRequest(text: textToSend) { result in
                 switch result {
                 case .success(let summary):
                     print("✅ Sent: “\(textToSend)”")
                     print("   ↳ Summary: \(summary)")
                 case .failure(let error):
                     print("❌ Send failed:", error)
                 }
             }
         }
         RunLoop.main.add(sendTimer!, forMode: .common)
     }

     private func stopSendingInterval() {
         sendTimer?.invalidate()
         sendTimer = nil
     }
 }

 */
