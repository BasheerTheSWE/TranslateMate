//
//  VoiceManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import UIKit
import Speech

final class VoiceManager {
    // The VoiceManager is used to record the user's voice and extract text from it to translate.
    
    static let shared = VoiceManager()
    
    private let audioEngine      = AVAudioEngine()
    private let speechRecognizer = SFSpeechRecognizer()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    
    func initiate(delegate: UIViewController) {
        speechRecognizer?.delegate = delegate as? any SFSpeechRecognizerDelegate
    }
    
    
    func requestSpeechAuthorization(completion: @escaping ((SFSpeechRecognizerAuthorizationStatus) -> Void)) {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                if authStatus == .authorized {
                    completion(authStatus)
                }
            }
        }
    }
    
    
    func stopRecording(completion: @escaping (() -> Void)) {
        audioEngine.stop()
        recognitionRequest?.endAudio()
        completion()
    }
    
    
    func startRecording(completion: @escaping ((String) -> Void)) throws {
        // Cancel the previous task if it's running
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for recording
        let audioSession = AVAudioSession.sharedInstance()
        
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                completion(result.bestTranscription.formattedString)
                isFinal = result.isFinal
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
}
