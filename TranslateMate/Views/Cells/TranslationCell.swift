//
//  TranslationCell.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 20/09/2023.
//

import UIKit

final class TranslationCell: UITableViewCell {
    static let id: String = "TranslationCell"
    
    private lazy var container: UIView = {
        let view = UIView()
        view.frame.size = CGSize(width: container.frame.width, height: container.frame.height)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        
        // Shadows
        view.layer.shadowColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 3
        
        view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: 12).cgPath
        
        // Components
        view.addSubview(targetLanguageTitle)
        view.addSubview(translationLabel)
        view.addSubview(separator)
        view.addSubview(sourceLabel)
        
        NSLayoutConstraint.activate([
            targetLanguageTitle.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            targetLanguageTitle.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            
            translationLabel.topAnchor.constraint(equalTo: targetLanguageTitle.bottomAnchor, constant: 8),
            translationLabel.leadingAnchor.constraint(equalTo: targetLanguageTitle.leadingAnchor),
            translationLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            
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
    
    private let targetLanguageTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "English"
        
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.textColor = .link
        label.numberOfLines = 0
        
        return label
    }()
    
    private let translationLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hello my friend my name is basheer and I am an iOS engineer who is currently working on an app called Avatalk"
        
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .label
        
        return view
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "hello my friend my name is basheer and I am an iOS engineer who is currently working on an app called Avatalk"
        
        label.font = .systemFont(ofSize: 12)
        label.numberOfLines = 0
        label.textColor = .systemGray
        
        return label
    }()
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        
        configureSubviews()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SUBVIEWS
    private func configureSubviews() {
        addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor)
        ])
    }
}
