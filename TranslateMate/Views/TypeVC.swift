//
//  TypeVC.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 16/09/2023.
//

import UIKit

final class TypeVC: UIViewController {
    private let languages: [Language] = DataManager.shared.getLanguages()
    private var targetLanguageIndex: Int = 0
    
    private var translations: [Translation] = []
    
    // MARK: - VIEWS
    private let targetLanguageTapRegion: UIView = ViewManager.shared.getTapRegion()
    private let translateIcon: UIImageView = ViewManager.shared.getIcon(named: "arrow.forward", tintColor: .link)
    
    
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
    
    private let textViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UITableView(frame: .zero, style: .insetGrouped).backgroundColor
        view.alpha = 0
        
        return view
    }()
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        textView.delegate = self
        
        textView.backgroundColor = .secondarySystemGroupedBackground
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 8
        textView.layer.borderColor = CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.2)
        textView.layer.borderWidth = 1
        
        textView.alpha = 0
        textView.isUserInteractionEnabled = false
        textView.returnKeyType = .go
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        
        return textView
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(TranslationCell.self, forCellReuseIdentifier: TranslationCell.id)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        tableView.keyboardDismissMode = .onDrag
        tableView.contentInset.bottom = 150
        tableView.separatorStyle = .none
        
        return tableView
    }()
    
    // MARK: - VDL
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = tableView.backgroundColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(inputViewDismissed), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        configureGestures()
        fetchData()
    }
    
    
    override func viewDidLayoutSubviews() {
        view.addSubview(tableView)
        view.addSubview(textViewContainer)
        view.addSubview(textView)
        view.addSubview(sourceLanguageView)
        view.addSubview(translateIcon)
        view.addSubview(targetLanguageView)
        view.addSubview(targetLanguageTapRegion)
        
        configureAutoLayout()
    }
    
    
    private func configureGestures() {
        let targetLanguageGesture = UITapGestureRecognizer(target: self, action: #selector(changeLanguage))
        targetLanguageTapRegion.addGestureRecognizer(targetLanguageGesture)
    }
    
    
    func setTabBar(controller: UITabBarController) {
        guard let controller = controller as? MainTabBar else { fatalError() }
        controller.typeDelegate = self
    }
    
    // MARK: - DATA-ACTIONS
    private func fetchData() {
        CoreDataManager.shared.fetchData { error, data in
            guard error == nil else {
                return
            }
            
            self.translations = data
            self.tableView.reloadData()
        }
    }
    
    // MARK: - ACTIONS
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
        if textView.isUserInteractionEnabled {
            textView.becomeFirstResponder()
        }
        
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
    
    
    private func startTranslation() {
        textView.isUserInteractionEnabled = true
        textView.becomeFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.textView.alpha = 1
            self.textViewContainer.alpha = 1
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [.allowUserInteraction]) {
            self.textView.transform = CGAffineTransform(translationX: 0, y: 60)
            self.textViewContainer.transform  = CGAffineTransform(translationX: 0, y: 60)
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 75)
        }
    }
    
    
    private func endTranslation() {
        textView.text = ""
        textView.isUserInteractionEnabled = false
        textView.resignFirstResponder()
        
        UIView.animate(withDuration: 0.2) {
            self.textView.alpha = 0
            self.textViewContainer.alpha = 0
        }
        
        UIView.animate(withDuration: 0.5) {
            self.textView.transform = .identity
            self.textViewContainer.transform  = .identity
            self.tableView.transform = .identity
        }
    }
    
    
    @objc private func inputViewDismissed() {
        endTranslation()
        cancelLanguageChange()
    }
    
    
    private func clearHistory() {
        let alert = UIAlertController(title: "Clear History", message: "Are you sure you want to clear your translation history? This action cannot be undone.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
            self.translations.forEach { translation in
                CoreDataManager.shared.deleteObject(object: translation)
                self.fetchData()
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        
        present(alert, animated: true)
    }
    
    // MARK: - AUTOLAYOUT
    private func configureAutoLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: sourceLanguageView.bottomAnchor, constant: 5),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
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
            
            textViewContainer.topAnchor.constraint(equalTo: textView.topAnchor),
            textViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            textViewContainer.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 8),
            
            textView.topAnchor.constraint(equalTo: targetLanguageView.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            textView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
}


// MARK: - PICKER EXT
extension TypeVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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


// MARK: - TABLEVIEW EXT
extension TypeVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return translations.count > 0 ? 2 : 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? 1 : translations.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        
        switch section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TranslationCell.id, for: indexPath) as? TranslationCell else { fatalError() }
            
            cell.set(translation: translations[row])
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            var info = cell.defaultContentConfiguration()
            info.text = "Clear History"
            info.textProperties.color = .systemBackground
            info.textProperties.alignment = .center
            info.textProperties.font = .systemFont(ofSize: 15, weight: .medium)
            info.image = UIImage(systemName: "trash")
            info.imageProperties.tintColor = .systemBackground
            
            cell.contentConfiguration = info
            cell.backgroundColor = .label
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            clearHistory()
        }
        cancelLanguageChange()
        endTranslation()
    }
}


// MARK: - TEXTVIEW EXT
extension TypeVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            endTranslation()
            return false
        }
        
        return true
    }
}


// MARK: - TYPE DELEGATE
extension TypeVC: TypeDelegate {
    func startTyping() {
        startTranslation()
    }
}
