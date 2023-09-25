//
//  MainTabBar.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import UIKit

protocol VoiceDelegate {
    func startVoiceRecording()
    func stopVoiceRecording()
}

protocol TypeDelegate {
    func startTyping()
}

final class MainTabBar: UITabBarController {
    enum Status {
        case isRecording
        case notRecording
    }
    
    var voiceDelegate: VoiceDelegate?
    var typeDelegate: TypeDelegate?
    
    private var isVoiceRecordingAuthorized: Bool = false
    private var recordingStatus: Status = .notRecording
    
    private lazy var voiceButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = CGSize(width: 100, height: 100)
        view.isUserInteractionEnabled = true
        
        // UI Configuration
        view.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 50
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        view.layer.borderWidth = 1
        
        // Shadows
        view.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 0

        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 50).cgPath
        
        // Components
        let innerView = UIView()
        innerView.translatesAutoresizingMaskIntoConstraints = false
        innerView.backgroundColor = view.backgroundColor
        
        voiceButtonViewRing.layer.cornerRadius = 40
        innerView.layer.cornerRadius = 35
        
        view.addSubview(voiceButtonViewRing)
        view.addSubview(innerView)
        
        // AutoLayout
        NSLayoutConstraint.activate([
            voiceButtonViewRing.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            voiceButtonViewRing.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            voiceButtonViewRing.widthAnchor.constraint(equalToConstant: 80),
            voiceButtonViewRing.heightAnchor.constraint(equalToConstant: 80),
            
            innerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            innerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            innerView.widthAnchor.constraint(equalToConstant: 70),
            innerView.heightAnchor.constraint(equalToConstant: 70),
        ])
        
        
        return view
    }()
    
    private let voiceButtonViewRing: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        // UI Configuration
        view.backgroundColor = .secondarySystemBackground
        
        return view
    }()
    
    private lazy var voiceImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mic.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // UI Configuration
        imageView.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
        
        imageView.tintColor = .systemGray
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private lazy var typeButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = CGSize(width: 100, height: 100)
        view.isUserInteractionEnabled = true
        
        // UI Configuration
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 50
        view.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.3)
        view.layer.borderWidth = 1
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 50).cgPath
        
        
        return view
    }()
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "keyboard"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // UI Configuration
        imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Defining the ViewControllers
        let voiceVC = VoiceVC()
        let typeVC = TypeVC()
        
        // Assigning tags
        voiceVC.tabBarItem.tag = 0
        typeVC.tabBarItem.tag = 1
        
        // Setting up the custom delegates
        voiceVC.setTabBar(controller: self)
        voiceVC.voiceRecordingAuthDelegate = self
        voiceVC.translationsDelegate = typeVC
        
        typeVC.setTabBar(controller: self)
        
        viewControllers = [
            voiceVC,
            typeVC
        ]
        
        configureTabBar()
        configureGestures()
        configureSubviews()
    }
    
    
    private func configureTabBar() {
        tabBar.isHidden = true
    }
    
    
    private func configureGestures() {
        let voiceGesture = UITapGestureRecognizer(target: self, action: #selector(activateVoiceMode))
        voiceButtonView.addGestureRecognizer(voiceGesture)
        
        let typeGesture = UITapGestureRecognizer(target: self, action: #selector(activateTypeMode))
        typeButtonView.addGestureRecognizer(typeGesture)
    }
    
    // MARK: - ACTIONS
    private func startedRecording() {
        voiceDelegate?.startVoiceRecording()
        
        voiceImageView.tintColor = .systemRed
        voiceButtonView.layer.shadowColor = CGColor(red: 1, green: 0.25, blue: 0.25, alpha: 1)
        voiceButtonView.layer.shadowRadius = 20
        
        voiceButtonViewRing.backgroundColor = .systemRed
    }
    
    
    private func stoppedRecording() {
        voiceDelegate?.stopVoiceRecording()
        
        voiceImageView.tintColor = .systemGray
        voiceButtonView.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        voiceButtonView.layer.shadowRadius = 0
        
        voiceButtonViewRing.backgroundColor = .secondarySystemBackground
    }
    
    
    @objc private func activateVoiceMode() {
        if isVoiceRecordingAuthorized {
            if selectedIndex == 0 {
                // This clause will be activate if the Voice button was clicked while on the VoiceVC.
                
                recordingStatus = recordingStatus == .isRecording ? .notRecording : .isRecording
                
                switch recordingStatus {
                case .isRecording:
                    startedRecording()
                    
                case .notRecording:
                    stoppedRecording()
                }
            }
        }
        
        selectedIndex = 0
        
        UIView.animate(withDuration: 0.2) {
            self.voiceImageView.tintColor = self.recordingStatus == .isRecording ? .systemRed : .systemGray
            self.typeImageView.tintColor = .systemGray5
        }
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.voiceButtonView.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
            self.voiceImageView.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
            
            self.typeButtonView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.typeImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    
    @objc private func activateTypeMode() {
        // If the voice recording was on, the user can't switch to the TypeVC.
        guard recordingStatus == .notRecording else { return }
        
        if selectedIndex == 1 {
            typeDelegate?.startTyping()
        }
        
        selectedIndex = 1
        
        UIView.animate(withDuration: 0.2) {
            self.voiceImageView.tintColor = .systemGray5
            self.typeImageView.tintColor = .systemGray
        }
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.typeButtonView.transform = CGAffineTransform(translationX: -self.view.frame.width/4, y: 0)
            self.typeImageView.transform = CGAffineTransform(translationX: -self.view.frame.width/4, y: 0)
            
            self.voiceButtonView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.voiceImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        }
    }
    
    // MARK: - AUTOLAYOUT
    private func configureSubviews() {
        view.addSubview(voiceButtonView)
        view.addSubview(voiceImageView)
        view.addSubview(typeButtonView)
        view.addSubview(typeImageView)
        
        NSLayoutConstraint.activate([
            voiceButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -view.frame.width/4),
            voiceButtonView.widthAnchor.constraint(equalToConstant: 100),
            voiceButtonView.heightAnchor.constraint(equalToConstant: 100),
            voiceButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),

            voiceImageView.centerYAnchor.constraint(equalTo: voiceButtonView.centerYAnchor),
            voiceImageView.centerXAnchor.constraint(equalTo: voiceButtonView.centerXAnchor),
            voiceImageView.widthAnchor.constraint(equalToConstant: 45),
            voiceImageView.heightAnchor.constraint(equalToConstant: 45),

            typeButtonView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: view.frame.width/4),
            typeButtonView.widthAnchor.constraint(equalToConstant: 100),
            typeButtonView.heightAnchor.constraint(equalToConstant: 100),
            typeButtonView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),

            typeImageView.centerYAnchor.constraint(equalTo: typeButtonView.centerYAnchor),
            typeImageView.centerXAnchor.constraint(equalTo: typeButtonView.centerXAnchor),
            typeImageView.widthAnchor.constraint(equalToConstant: 45),
            typeImageView.heightAnchor.constraint(equalToConstant: 45),
        ])
    }
}


// MARK: - VOICEAUTHRESULTS EXT
extension MainTabBar: VoiceRecordingAuthDelegate {
    
    func setAuthResults(result: Bool) {
        self.isVoiceRecordingAuthorized = result
    }
}
