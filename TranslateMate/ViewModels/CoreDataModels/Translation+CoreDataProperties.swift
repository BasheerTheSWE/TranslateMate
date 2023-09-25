//
//  Translation+CoreDataProperties.swift
//  TranslateMate
//
//  Created by Basheer Abdulmalik on 23/09/2023.
//
//

import Foundation
import CoreData


extension Translation {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Translation> {
        return NSFetchRequest<Translation>(entityName: "Translation")
    }

    @NSManaged public var sourceText: String?
    @NSManaged public var translation: String?
    @NSManaged public var target: String?

}

extension Translation : Identifiable {

}
