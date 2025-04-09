//
//  EstatePhotoEntity+CoreDataProperties.swift
//  EliteTest
//
//  Created by andres on 9/04/25.
//
//

import Foundation
import CoreData

@objc(EstatePhotoEntity)
public class EstatePhotoEntity: NSManagedObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EstatePhotoEntity> {
        return NSFetchRequest<EstatePhotoEntity>(entityName: "EstatePhotoEntity")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var imageData: Data?
    @NSManaged public var estate: EstateEntity?

}

extension EstatePhotoEntity : Identifiable {

}
