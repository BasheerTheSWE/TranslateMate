//
//  ViewManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 20/09/2023.
//

import UIKit

final class ViewManager {
    static let shared = ViewManager()
    
    func getIcon(named imageName: String, isLabelColored: Bool = false) -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = isLabelColored ? .label : .systemGray
        
        return imageView
    }
    
    
    func getTapRegion() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        return view
    }
    
    
    func getPrimaryView(parentView: UIView, height: CGFloat, textView: UITextView, icons: [UIImageView], tapRegions: [UIView]) -> UIView {
        let view = UIView()
        view.frame.size = CGSize(width: parentView.frame.width - 75, height: height)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 8
        
        view.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 8).cgPath
        
        // Components
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.backgroundColor = .systemGray3
        
        view.addSubview(textView)
        view.addSubview(separator)
        view.addSubview(icons[0])
        view.addSubview(icons[1])
        view.addSubview(icons[2])
        view.addSubview(tapRegions[0])
        view.addSubview(tapRegions[1])
        view.addSubview(tapRegions[2])
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            textView.bottomAnchor.constraint(equalTo: separator.topAnchor),
            
            separator.heightAnchor.constraint(equalToConstant: 0.5),
            separator.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            separator.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            separator.bottomAnchor.constraint(equalTo: icons[1].topAnchor, constant: -15),
            
            icons[0].centerYAnchor.constraint(equalTo: icons[1].centerYAnchor),
            icons[0].trailingAnchor.constraint(equalTo: icons[1].leadingAnchor, constant: -45),
            icons[0].widthAnchor.constraint(equalToConstant: 20),
            icons[0].heightAnchor.constraint(equalToConstant: 20),
            
            icons[1].centerXAnchor.constraint(equalTo: view.centerXAnchor),
            icons[1].bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            icons[1].widthAnchor.constraint(equalToConstant: 20),
            icons[1].heightAnchor.constraint(equalToConstant: 20),
            
            icons[2].centerYAnchor.constraint(equalTo: icons[1].centerYAnchor),
            icons[2].leadingAnchor.constraint(equalTo: icons[1].trailingAnchor, constant: 45),
            icons[2].widthAnchor.constraint(equalToConstant: 20),
            icons[2].heightAnchor.constraint(equalToConstant: 20),
            
            tapRegions[0].topAnchor.constraint(equalTo: separator.bottomAnchor),
            tapRegions[0].centerXAnchor.constraint(equalTo: icons[0].centerXAnchor),
            tapRegions[0].widthAnchor.constraint(equalToConstant: 60),
            tapRegions[0].bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tapRegions[1].topAnchor.constraint(equalTo: separator.bottomAnchor),
            tapRegions[1].centerXAnchor.constraint(equalTo: icons[1].centerXAnchor),
            tapRegions[1].widthAnchor.constraint(equalToConstant: 60),
            tapRegions[1].bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tapRegions[2].topAnchor.constraint(equalTo: separator.bottomAnchor),
            tapRegions[2].centerXAnchor.constraint(equalTo: icons[2].centerXAnchor),
            tapRegions[2].widthAnchor.constraint(equalToConstant: 60),
            tapRegions[2].bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }
    
    
    func getSourceLanguageView() -> UIView {
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
    }
    
    
    func getTargetLanguageView(textView: UITextField) -> UIView {
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
        view.addSubview(textView)
        view.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: -5),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            imageView.widthAnchor.constraint(equalToConstant: 20),
            imageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        return view
    }
}
