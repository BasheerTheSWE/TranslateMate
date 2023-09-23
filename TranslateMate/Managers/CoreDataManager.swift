//
//  CoreDataManager.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 23/09/2023.
//

import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // MARK: - FUNCTIONS
    func fetchData(completion: @escaping ((_ error: Error?, _ data: [Translation]) -> Void)) {
        var errorToShow: Error?
        var data: [Translation] = []
        
        do {
            data = try context.fetch(Translation.fetchRequest())
        } catch {
            errorToShow = error
        }
        
        completion(errorToShow, data)
    }
    
    
    func saveObject(parent: UIViewController, target: String, translation: String, sourceText: String) {
        let newObject = Translation(context: context)
        newObject.target = target
        newObject.translation = translation
        newObject.sourceText = sourceText
        
        do {
            try context.save()
        } catch {
            let alert = UIAlertController(title: "Error", message: "Unable to save this translation to your device due to unknown reasons.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default))
            
            parent.present(alert, animated: true)
        }
    }
    
    
    func deleteObject(object: Translation) {
        context.delete(object)
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
}
