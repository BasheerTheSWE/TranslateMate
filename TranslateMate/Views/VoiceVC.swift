//
//  VoiceVC.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 15/09/2023.
//

import UIKit
import Speech

protocol VoiceRecordingAuthDelegate {
    func setAuthResults(result: Bool)
}

final class VoiceVC: UIViewController, SFSpeechRecognizerDelegate {
    var voiceRecordingAuthDelegate: VoiceRecordingAuthDelegate?
    private var targetLanguageIndex: Int = 0
    
    private let languages: [[String: String]] = [
        [
            "language" : "Arabic",
            "code": "ar"
        ],
        [
            "language" : "Armenian",
            "code": "hy"
        ],
        [
            "language" : "Bengali",
            "code": "bn"
        ],
        [
            "language" : "Chinese",
            "code": "zh"
        ],
        [
            "language" : "Croatian",
            "code": "hr"
        ],
        [
            "language" : "Czech",
            "code": "cs"
        ],
        [
            "language" : "English",
            "code": "en"
        ],
        [
            "language" : "Estonian",
            "code": "et"
        ],
        [
            "language" : "French",
            "code": "fr"
        ],
        [
            "language" : "German",
            "code": "de"
        ],
        [
            "language" : "Hausa",
            "code": "ha"
        ],
        [
            "language" : "Hebrew",
            "code": "he"
        ],
        [
            "language" : "Hindi",
            "code": "hi"
        ],
        [
            "language" : "Hungarian",
            "code": "hu"
        ],
        [
            "language" : "Icelandic",
            "code": "is"
        ],
        [
            "language" : "Indonesian",
            "code": "id"
        ],
        [
            "language" : "Irish",
            "code": "ga"
        ],
        [
            "language" : "Italian",
            "code": "it"
        ],
        [
            "language" : "Japanese",
            "code": "ja"
        ],
        [
            "language" : "Kongo",
            "code": "kg"
        ],
        [
            "language" : "Korean",
            "code": "ko"
        ],
        [
            "language" : "Latin",
            "code": "la"
        ],
        [
            "language" : "Mongolian",
            "code": "mn"
        ],
        [
            "language" : "Nepali",
            "code": "ne"
        ],
        [
            "language" : "Norwegian",
            "code": "no"
        ],
        [
            "language" : "Persian",
            "code": "fa"
        ],
        [
            "language" : "Polish",
            "code": "pl"
        ],
        [
            "language" : "Portuguese",
            "code": "pt"
        ],
        [
            "language" : "Punjabi",
            "code": "pa"
        ],
        [
            "language" : "Russian",
            "code": "ru"
        ],
        [
            "language" : "Sardinian",
            "code": "sc"
        ],
        [
            "language" : "Serbian",
            "code": "sr"
        ],
        [
            "language" : "Spanish",
            "code": "es"
        ],
        [
            "language" : "Swahili",
            "code": "sw"
        ],
        [
            "language" : "Swedish",
            "code": "sv"
        ],
        [
            "language" : "Thai",
            "code": "th"
        ],
        [
            "language" : "Turkish",
            "code": "tr"
        ],
        [
            "language" : "Ukrainian",
            "code": "uk"
        ],
        [
            "language" : "Urdu",
            "code": "ur"
        ],
        [
            "language" : "Vietnamese",
            "code": "vi"
        ],
        [
            "language" : "Welsh",
            "code": "cy"
        ],
        [
            "language" : "Sundanese",
            "code": "su"
        ],
    ]
    
    private let recordedTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        
        textView.font = .systemFont(ofSize: 25, weight: .medium)
        textView.textAlignment = .center
        
        return textView
    }()
    
    private let sourceLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        
        view.layer.cornerRadius = 8
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        view.layer.borderWidth = 1
        
        // Components
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = "English"
        label.font = .systemFont(ofSize: 17, weight: .medium)
        
        // AutoLayout
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
        ])
        
        return view
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
        
        field.text = languages[0]["language"]
        field.allowsEditingTextAttributes = false
        
        field.inputView = languagePicker
        field.textAlignment = .left
        field.font = .systemFont(ofSize: 17, weight: .medium)
        field.tintColor = .clear
        
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))

        return field
    }()
    
    private lazy var targetLanguageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        
        view.backgroundColor = .clear
        
        view.layer.cornerRadius = 8
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        view.layer.borderWidth = 1
        
        // Components
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "chevron.down.circle"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .systemGray
        
        // AutoLayout
        view.addSubview(targetLanguageTextField)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            targetLanguageTextField.topAnchor.constraint(equalTo: view.topAnchor),
            targetLanguageTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            targetLanguageTextField.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -5),
            targetLanguageTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }()
    
    private let targetLanguageTapRegion: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private let translateIcon: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "arrow.forward"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = .label
        
        return imageView
    }()
    
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
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
    }
    
    // MARK: - ACTIONS
    private func translate() {
        guard !recordedTextView.text.isEmpty,
              let text = recordedTextView.text,
              let target = languages[targetLanguageIndex]["code"] else { return }
        
        APIManager.shared.translate(text: text, target: target, source: "en") { data in
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
            targetLanguageTapRegion.bottomAnchor.constraint(equalTo: targetLanguageView.bottomAnchor)
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
        return languages[row]["language"]
    }
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        targetLanguageTextField.text = languages[row]["language"]
        targetLanguageIndex = row
        
        cancelLanguageChange()
    }
}


// MARK: - VOICEDELEGATE EXT
extension VoiceVC: VoiceDelegate {
    
    func startVoiceRecording() {
        do {
            try VoiceManager.shared.startRecording { text in
                self.recordedTextView.text = text
            }
        } catch {
            print("error")
        }
    }
    
    func stopVoiceRecording() {
        VoiceManager.shared.stopRecording {
            self.translate()
        }
    }
}
