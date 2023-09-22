//
//  ViewManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 20/09/2023.
//

import UIKit

final class ViewManager {
    static let shared = ViewManager()
    
    func getIcon(named imageName: String, tintColor: UIColor = .systemGray) -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.tintColor = tintColor
        
        return imageView
    }
    
    
    func getTapRegion() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        return view
    }
    
    
    func animateIcon(icon imageView: UIImageView, tapRegion: UIView) {
        UIView.animate(withDuration: 0.1) {
            imageView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        } completion: { _ in
            UIView.animate(withDuration: 0.1) {
                imageView.transform = .identity
            }
        }
    }
}
