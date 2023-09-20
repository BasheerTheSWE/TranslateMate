//
//  TranslationCell.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 20/09/2023.
//

import UIKit

final class TranslationCell: UITableViewCell {
    static let id: String = "TranslationCell"
    
    // MARK: - INIT
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
