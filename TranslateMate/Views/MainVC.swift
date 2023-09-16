//
//  MainVC.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 15/09/2023.
//

import UIKit

final class MainVC: UIViewController {
    enum Mode {
        case voice
        case type
    }
    
    enum Status {
        case isRecording
        case notRecording
    }
        
    private var currentMode: Mode = .voice
    private var recordingStatus : Status = .notRecording
    
    private let voiceVC: UIViewController = VoiceVC()
    
    private lazy var voiceButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame.size = CGSize(width: 100, height: 100)
        view.isUserInteractionEnabled = true
        
        view.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 50
        
        view.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
//        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 50).cgPath
        
        
        return view
    }()
    
    private lazy var voiceImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "mic.fill"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        view.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 50
        
        view.layer.shadowColor = CGColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
//        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 5
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 50).cgPath
        
        
        return view
    }()
    
    private lazy var typeImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "keyboard"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        imageView.tintColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        navigationController?.navigationBar.tintColor = .systemGray
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis"), style: .plain, target: self, action: nil)
        
        configureGestures()
    }
    
    
    override func viewDidLayoutSubviews() {
        addChild(voiceVC)
        voiceVC.didMove(toParent: self)
        view.addSubview(voiceVC.view)
        
        view.addSubview(voiceButtonView)
        view.addSubview(voiceImageView)
        view.addSubview(typeButtonView)
        view.addSubview(typeImageView)
        
        configureAutoLayout()
    }
    
    
    private func configureGestures() {
        let voiceGesture = UITapGestureRecognizer(target: self, action: #selector(activateVoiceMode))
        voiceButtonView.addGestureRecognizer(voiceGesture)
        
        let typeGesture = UITapGestureRecognizer(target: self, action: #selector(activateTypeMode))
        typeButtonView.addGestureRecognizer(typeGesture)
    }
    
    // MARK: - ACTIONS
    private func startedRecording() {
        voiceImageView.tintColor = .systemRed
        voiceButtonView.layer.shadowColor = CGColor(red: 1, green: 0.5, blue: 0.5, alpha: 1)
        voiceButtonView.layer.shadowRadius = 10
    }
    
    
    private func stoppedRecording() {
        voiceImageView.tintColor = .systemGray
        voiceButtonView.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        voiceButtonView.layer.shadowRadius = 5
    }
    
    
    @objc private func activateVoiceMode() {
        switch currentMode {
        case .voice:
            recordingStatus = recordingStatus == .isRecording ? .notRecording : .isRecording
            
            // Should start or stop recording
            switch recordingStatus {
            case .isRecording:
                startedRecording()
                
            case .notRecording:
                stoppedRecording()
            }
            
            break
            
        case .type:
            break
        }
        
        currentMode = .voice
        
        UIView.animate(withDuration: 0.2) {
            self.voiceImageView.tintColor = self.recordingStatus == .isRecording ? .systemRed : .systemGray
            self.typeImageView.tintColor = .systemGray5
        }
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.voiceButtonView.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
            self.voiceImageView.transform = CGAffineTransform(translationX: self.view.frame.width/4, y: 0)
            
            self.typeButtonView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.typeImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            
        }
    }
    
    
    @objc private func activateTypeMode() {
        guard recordingStatus == .notRecording else { return }
        
        currentMode = .type
//        recordingStatus = .notRecording
        
        UIView.animate(withDuration: 0.2) {
            self.voiceImageView.tintColor = .systemGray5
            self.typeImageView.tintColor = .systemGray
        }
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.typeButtonView.transform = CGAffineTransform(translationX: -self.view.frame.width/4, y: 0)
            self.typeImageView.transform = CGAffineTransform(translationX: -self.view.frame.width/4, y: 0)
            
            self.voiceButtonView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.voiceImageView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        } completion: { _ in
            
        }
    }
    
    // MARK: - AUTOLAYOUT
    private func configureAutoLayout() {
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
