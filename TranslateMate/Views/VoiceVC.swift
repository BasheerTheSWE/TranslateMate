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
    
    private let translateIcon: UIImageView = ViewManager.shared.getIcon(named: "arrow.forward", tintColor: .label)
    private let copyIcon: UIImageView = ViewManager.shared.getIcon(named: "square.on.square", tintColor: .link)
    private let speakIcon: UIImageView = ViewManager.shared.getIcon(named: "waveform.and.mic", tintColor: .link)
    private let hideIcon: UIImageView = ViewManager.shared.getIcon(named: "eye.slash", tintColor: .link)
    
    private let copyTapRegion: UIView = ViewManager.shared.getTapRegion()
    private let speakTapRegion: UIView = ViewManager.shared.getTapRegion()
    private let hideTapRegion: UIView = ViewManager.shared.getTapRegion()
    
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
    
    private lazy var translationContainerTargetLanguageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "Arabic"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 3
        label.textColor = .systemGray
        
        return label
    }()
    
    private lazy var translationContainerTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        
        // Components
        let title = UILabel()
        let imageView = UIImageView(image: UIImage(systemName: "chevron.down.circle"))
        
        title.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        title.text = "Translated Into"
        title.font = .systemFont(ofSize: 14)
        
        imageView.tintColor = .label
        
        view.addSubview(title)
        view.addSubview(translationContainerTargetLanguageLabel)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            title.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            title.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            
            translationContainerTargetLanguageLabel.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            translationContainerTargetLanguageLabel.leadingAnchor.constraint(equalTo: title.trailingAnchor, constant: 5),
            
            imageView.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            imageView.leadingAnchor.constraint(equalTo: translationContainerTargetLanguageLabel.trailingAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 14),
            imageView.heightAnchor.constraint(equalToConstant: 14)
        ])
        
        return view
    }()
    
    private lazy var translationContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
//        view.backgroundColor = UITableView(frame: .zero, style: .insetGrouped).backgroundColor
        
        view.layer.cornerRadius = 8
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        view.layer.borderWidth = 1
        
        // Components
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .link
        
        translationLabel.text = "hello there my name is basheer and I am an ios developer hoping to be very rich in the future"
        sourceLabel.text = "hello there my name is basheer and I am an ios developer hoping to be very rich in the future"
        
        view.addSubview(translationLabel)
        view.addSubview(separator)
        view.addSubview(sourceLabel)
        
        NSLayoutConstraint.activate([
            translationLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            translationLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            translationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
//            translationTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 200),
            
            separator.topAnchor.constraint(equalTo: sourceLabel.topAnchor),
            separator.leadingAnchor.constraint(equalTo: translationLabel.leadingAnchor, constant: 2),
            separator.widthAnchor.constraint(equalToConstant: 1),
            separator.bottomAnchor.constraint(equalTo: sourceLabel.bottomAnchor),
            
            sourceLabel.topAnchor.constraint(equalTo: translationLabel.bottomAnchor, constant: 15),
            sourceLabel.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 15),
            sourceLabel.trailingAnchor.constraint(equalTo: translationLabel.trailingAnchor),
            sourceLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15)
        ])
        
        return view
    }()
    
    private lazy var translationActionsContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 20
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        view.layer.borderWidth = 1
        
        // Components
        view.addSubview(copyIcon)
        view.addSubview(speakIcon)
        view.addSubview(hideIcon)
        view.addSubview(copyTapRegion)
        view.addSubview(speakTapRegion)
        view.addSubview(hideTapRegion)
        
        NSLayoutConstraint.activate([
            copyIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            copyIcon.widthAnchor.constraint(equalToConstant: 18),
            copyIcon.heightAnchor.constraint(equalToConstant: 18),
            copyIcon.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            copyIcon.trailingAnchor.constraint(equalTo: speakIcon.leadingAnchor, constant: -45),
            
            speakIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            speakIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            speakIcon.widthAnchor.constraint(equalToConstant: 18),
            speakIcon.heightAnchor.constraint(equalToConstant: 18),
            
            hideIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hideIcon.widthAnchor.constraint(equalToConstant: 18),
            hideIcon.heightAnchor.constraint(equalToConstant: 18),
            hideIcon.leadingAnchor.constraint(equalTo: speakIcon.trailingAnchor, constant: 45),
            hideIcon.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            copyTapRegion.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            copyTapRegion.centerXAnchor.constraint(equalTo: copyIcon.centerXAnchor),
            copyTapRegion.widthAnchor.constraint(equalToConstant: 44),
            copyTapRegion.heightAnchor.constraint(equalToConstant: 40),
            
            speakTapRegion.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            speakTapRegion.centerXAnchor.constraint(equalTo: speakIcon.centerXAnchor),
            speakTapRegion.widthAnchor.constraint(equalToConstant: 44),
            speakTapRegion.heightAnchor.constraint(equalToConstant: 40),
            
            hideTapRegion.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            hideTapRegion.centerXAnchor.constraint(equalTo: hideIcon.centerXAnchor),
            hideTapRegion.widthAnchor.constraint(equalToConstant: 44),
            hideTapRegion.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        return view
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        indicator.hidesWhenStopped = true
        
        return indicator
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
//        view.addSubview(translationView)
        view.addSubview(translationContainerTitleView)
        view.addSubview(translationContainer)
        view.addSubview(activityIndicator)
        view.addSubview(translationActionsContainer)
        
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
        hideTapRegion.addGestureRecognizer(checkGesture)
    }
    
    // MARK: - ACTIONS
    private func translate() {
        guard !recordedTextView.text.isEmpty,
              let text = recordedTextView.text else { return }
        
        let target = languages[targetLanguageIndex].code
        prepareToTranslate()
        
        APIManager.shared.translate(text: text, target: target) { data, error in
            guard error == nil,
                  let data = data else {
                self.clearWindowToRecord()
                return
            }
            
            self.parse(JSON: data)
        }
    }
    
    
    private func parse(JSON: Data) {
        let JSONDecoder = JSONDecoder()
        
        if let responses = try? JSONDecoder.decode(Response.self, from: JSON) {
            guard let text = responses.matches.first?.translation as? String else { return }
            DispatchQueue.main.async {
                self.showTranslationResults()
//                self.translationTextView.text = text
            }
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
//        UIPasteboard.general.string = translationTextView.text
        
        ViewManager.shared.animateIcon(icon: copyIcon, tapRegion: copyTapRegion)
    }
    
    
    @objc private func speakTranslation() {
//        let speechSynthesizer = AVSpeechSynthesizer()
//        let speechUtterance = AVSpeechUtterance(string: translationTextView.text)
//
//        // Configure the speech utterance as needed
//        speechUtterance.rate = AVSpeechUtteranceDefaultSpeechRate // Adjust speech rate
//        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US") // Specify the desired language
//
//        // Start speaking
//        speechSynthesizer.speak(speechUtterance)
        
        ViewManager.shared.animateIcon(icon: speakIcon, tapRegion: speakTapRegion)
    }
    
    
    @objc private func clearTranslation() {
        UIView.animate(withDuration: 0.25) {
//            self.translationView.frame.origin.y = self.view.frame.height + 15
//            self.translationTextView.text = ""
        }
        
        ViewManager.shared.animateIcon(icon: hideIcon, tapRegion: hideTapRegion)
    }
    
    
    private func prepareToTranslate() {
        recordedTextView.textColor = .systemGray3
        activityIndicator.startAnimating()
    }
    
    
    private func endTranslationPreparations() {
        recordedTextView.text = ""
        recordedTextView.textColor = .label
        activityIndicator.stopAnimating()
    }
    
    
    private func showTranslationResults() {
        endTranslationPreparations()
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
//            self.translationView.frame.origin.y = self.view.center.y - 200
        }
    }
    
    
    private func clearWindowToRecord() {
        endTranslationPreparations()
        
        UIView.animate(withDuration: 0.25) {
//            self.translationView.frame.origin.y = self.view.frame.height + 15
//            self.translationTextView.text = ""
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
            
//            translationView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 15),
//            translationView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 37.5),
//            translationView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -37.5),
//            translationView.heightAnchor.constraint(equalToConstant: 350),
            
            translationContainerTitleView.leadingAnchor.constraint(equalTo: translationContainer.leadingAnchor, constant: 15),
            translationContainerTitleView.trailingAnchor.constraint(equalTo: translationContainer.trailingAnchor),
//            translationContainerTitleView.bottomAnchor.constraint(equalTo: translationContainer.topAnchor, constant: -5),
            translationContainerTitleView.bottomAnchor.constraint(equalTo: translationContainer.topAnchor),
            
            translationContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            translationContainer.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            translationContainer.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
//            translationContainer.heightAnchor.constraint(equalToConstant: 100),
            
            translationActionsContainer.topAnchor.constraint(equalTo: translationContainer.bottomAnchor, constant: 25),
            translationActionsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            translationActionsContainer.heightAnchor.constraint(equalToConstant: 40),
            
            activityIndicator.centerXAnchor.constraint(equalTo: recordedTextView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: recordedTextView.centerYAnchor)
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
        clearWindowToRecord()
        
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
