//
//  VoiceVC.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 15/09/2023.
//

import UIKit
import Speech
import AVFoundation

protocol VoiceRecordingAuthDelegate {
    func setAuthResults(result: Bool)
}

final class VoiceVC: UIViewController, SFSpeechRecognizerDelegate {
    /*
        * The status variable is used because there's a weird glitch that happen when I stop the audio recording. The device takes a final iteration and set the recorded text to what the microphone got, when its already having that value. So when I decide to clear it exactly when the audio recording is stopped that final iteration kicks in and reseted again.
     */
    
    enum Status {
        case isRecording
        case notRecording
    }
    
    private var status: Status = .notRecording
    var voiceRecordingAuthDelegate: VoiceRecordingAuthDelegate?
    private var targetLanguageIndex: Int = 0
    private let languages: [Language] = DataManager.shared.getLanguages()
    
    private lazy var targetLanguageView: UIView = ViewManager.shared.getTargetLanguageView(textView: targetLanguageTextField)
    private let sourceLanguageView: UIView = ViewManager.shared.getSourceLanguageView()
    
    private let targetLanguageTapRegion: UIView = ViewManager.shared.getTapRegion()
    
    private let translateIcon: UIImageView = ViewManager.shared.getIcon(named: "arrow.forward", isLabelColored: true)
    private let copyIcon: UIImageView = ViewManager.shared.getIcon(named: "square.on.square")
    private let speakIcon: UIImageView = ViewManager.shared.getIcon(named: "speaker.wave.2")
    private let checkIcon: UIImageView = ViewManager.shared.getIcon(named: "checkmark.circle")
    
    private let copyTapRegion: UIView = ViewManager.shared.getTapRegion()
    private let speakTapRegion: UIView = ViewManager.shared.getTapRegion()
    private let checkTapRegion: UIView = ViewManager.shared.getTapRegion()
    
    
    private lazy var translationView: UIView = ViewManager.shared.getPrimaryView(parentView: self.view, height: 350, textView: translationTextView, icons: [copyIcon, speakIcon, checkIcon], tapRegions: [copyTapRegion, speakTapRegion, checkTapRegion])
    
    private let recordedTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 25, weight: .medium)
        textView.textAlignment = .center
        
        return textView
    }()
    
    private lazy var languagePicker: UIPickerView = {
        let picker = UIPickerView()
        
        picker.delegate = self
        picker.dataSource = self
        
        return picker
    }()
    
    private lazy var targetLanguageTextField: UITextField = {
        let field = UITextField()
        field.translatesAutoresizingMaskIntoConstraints = false
        
        field.text = languages[0].language
        field.allowsEditingTextAttributes = false
        
        field.inputView = languagePicker
        field.textAlignment = .left
        field.font = .systemFont(ofSize: 17, weight: .medium)
        field.tintColor = .clear
        
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        
        return field
    }()
    
    private let translationTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.showsVerticalScrollIndicator = false
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 20, weight: .medium)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        
        return textView
    }()
    
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemGroupedBackground
        
        VoiceManager.shared.initiate(delegate: self)
        VoiceManager.shared.requestSpeechAuthorization { status in
            self.voiceRecordingAuthDelegate?.setAuthResults(result: true)
        }
        
        configureGestures()
    }
    
    
    override func viewDidLayoutSubviews() {
        view.addSubview(recordedTextView)
        view.addSubview(sourceLanguageView)
        view.addSubview(translateIcon)
        view.addSubview(targetLanguageView)
        view.addSubview(targetLanguageTapRegion)
        view.addSubview(translationView)
        
        configureAutoLayout()
    }
    
    
    func setTabBar(controller: UITabBarController) {
        guard let controller = controller as? MainTabBar else { fatalError() }
        controller.voiceDelegate = self
    }
    
    
    private func configureGestures() {
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(cancelLanguageChange))
        view.addGestureRecognizer(viewGesture)
        
        let targetLanguageGesture = UITapGestureRecognizer(target: self, action: #selector(changeLanguage))
        targetLanguageTapRegion.addGestureRecognizer(targetLanguageGesture)
        
        let textViewGesture = UITapGestureRecognizer(target: self, action: #selector(cancelLanguageChange))
        recordedTextView.addGestureRecognizer(textViewGesture)
        
        let copyGesture = UITapGestureRecognizer(target: self, action: #selector(copyTranslation))
        copyTapRegion.addGestureRecognizer(copyGesture)
        
        let speakGesture = UITapGestureRecognizer(target: self, action: #selector(speakTranslation))
        speakTapRegion.addGestureRecognizer(speakGesture)
        
        let checkGesture = UITapGestureRecognizer(target: self, action: #selector(clearTranslation))
        checkTapRegion.addGestureRecognizer(checkGesture)
    }
    
    // MARK: - ACTIONS
    private func translate() {
        guard !recordedTextView.text.isEmpty,
              let text = recordedTextView.text else { return }
        
        let target = languages[targetLanguageIndex].code
        
        recordedTextView.text = ""
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.translationView.frame.origin.y = self.view.center.y - 200
        }
        
        APIManager.shared.translate(text: text, target: target) { data in
            guard let data = try? JSONSerialization.jsonObject(with: data) else { return }
            print(data)
        }
    }
    
    
    @objc private func changeLanguage() {
        targetLanguageTextField.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.targetLanguageView.backgroundColor = .secondarySystemBackground
            self.targetLanguageTextField.textColor = .systemGray
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.sourceLanguageView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.targetLanguageView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            self.translateIcon.transform = CGAffineTransform(rotationAngle: .pi / 2)
        }
    }
    
    
    @objc private func cancelLanguageChange() {
        targetLanguageTextField.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.targetLanguageView.backgroundColor = .clear
            self.targetLanguageTextField.textColor = .label
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.sourceLanguageView.transform = .identity
            self.targetLanguageView.transform = .identity
            self.translateIcon.transform = .identity
        }
    }
    
    
    @objc private func copyTranslation() {
        UIPasteboard.general.string = translationTextView.text
        
        animateButton(copyIcon, tapRegion: copyTapRegion)
    }
    
    
    @objc private func speakTranslation() {
        let speechSynthesizer = AVSpeechSynthesizer()
        let speechUtterance = AVSpeechUtterance(string: translationTextView.text)
        
        // Configure the speech utterance as needed
        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate // Adjust speech rate
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Specify the desired language
        
        // Start speaking
        speechSynthesizer.speak(speechUtterance)
        
        animateButton(speakIcon, tapRegion: speakTapRegion)
    }
    
    
    @objc private func clearTranslation() {
        UIView.animate(withDuration: 0.25) {
            self.translationView.frame.origin.y = self.view.frame.height + 15
            self.translationTextView.text = ""
        }
        
        animateButton(checkIcon, tapRegion: checkTapRegion)
    }
    
    
    private func animateButton(_ imageView: UIImageView, tapRegion: UIView) {
        UIView.animate(withDuration: 0.1) {
            imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            tapRegion.backgroundColor = .systemGray6
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                imageView.transform = .identity
                tapRegion.backgroundColor = .clear
            }
        }
    }
    
    // MARK: - AUTOLAYOUT
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            recordedTextView.topAnchor.constraint(equalTo: sourceLanguageView.bottomAnchor, constant: 50),
            recordedTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            recordedTextView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            recordedTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200),
            
            sourceLanguageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 25),
            sourceLanguageView.trailingAnchor.constraint(equalTo: translateIcon.leadingAnchor, constant: -15),
            sourceLanguageView.widthAnchor.constraint(equalToConstant: 150),
            sourceLanguageView.heightAnchor.constraint(equalToConstant: 50),
            
            translateIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            translateIcon.centerYAnchor.constraint(equalTo: sourceLanguageView.centerYAnchor),
            translateIcon.widthAnchor.constraint(equalToConstant: 18),
            translateIcon.heightAnchor.constraint(equalToConstant: 18),
            
            targetLanguageView.topAnchor.constraint(equalTo: sourceLanguageView.topAnchor),
            targetLanguageView.leadingAnchor.constraint(equalTo: translateIcon.trailingAnchor, constant: 15),
            targetLanguageView.widthAnchor.constraint(equalToConstant: 150),
            targetLanguageView.heightAnchor.constraint(equalToConstant: 50),
            
            targetLanguageTapRegion.topAnchor.constraint(equalTo: targetLanguageView.topAnchor),
            targetLanguageTapRegion.leadingAnchor.constraint(equalTo: targetLanguageView.leadingAnchor),
            targetLanguageTapRegion.trailingAnchor.constraint(equalTo: targetLanguageView.trailingAnchor),
            targetLanguageTapRegion.bottomAnchor.constraint(equalTo: targetLanguageView.bottomAnchor),
            
            translationView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
            translationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37.5),
            translationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -37.5),
            translationView.heightAnchor.constraint(equalToConstant: 350)
        ])
    }
}


// MARK: - PICKER EXT
extension VoiceVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row].language
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        targetLanguageTextField.text = languages[row].language
        targetLanguageIndex = row
        
        cancelLanguageChange()
    }
}


// MARK: - VOICEDELEGATE EXT
extension VoiceVC: VoiceDelegate {
    
    func startVoiceRecording() {
        status = .isRecording
        
        UIView.animate(withDuration: 0.25) {
            self.translationView.frame.origin.y = self.view.frame.height + 15
            self.translationTextView.text = ""
        }
        
        do {
            try VoiceManager.shared.startRecording { text in
                if self.status == .isRecording {
                    self.recordedTextView.text = text
                }
            }
        } catch {
            print("error")
        }
    }
    
    
    func stopVoiceRecording() {
        status = .notRecording
        VoiceManager.shared.stopRecording {
            self.translate()
        }
    }
}
