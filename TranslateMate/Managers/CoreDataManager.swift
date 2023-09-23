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
    
    
    func saveObject(target: String, translation: String, sourceText: String, completion: @escaping ((Error?) -> Void)) {
        var errorToReturn: Error? = nil
        
        let newObject = Translation(context: context)
        newObject.target = target
        newObject.translation = translation
        newObject.sourceText = sourceText
        
        do {
            try context.save()
        } catch {
            errorToReturn = error
        }
        
        completion(errorToReturn)
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
