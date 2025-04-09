//
//  EstateEntity+CoreDataClass.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//
//

import Foundation
import CoreData

@objc(EstateEntity)
public class EstateEntity: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<EstateEntity> {
        return NSFetchRequest<EstateEntity>(entityName: "EstateEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var type: String?
    @NSManaged public var maxGuests: Int16
    @NSManaged public var beds: Int16
    @NSManaged public var bathrooms: Int16
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
}


