//
//  EstateRepository.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import Combine
import CoreData

final class EstateRepository: EstateRepositoryProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func save(estate: EstateModel) {
        let context = persistentContainer.newBackgroundContext()
        let entity = EstateEntity(context: context)
        entity.type = estate.type
        entity.maxGuests = Int16(estate.maxGuests)
        entity.beds = Int16(estate.beds)
        entity.bathrooms = Int16(estate.bathrooms)
        entity.title = estate.title
        entity.desc = estate.description
        try? context.save()
    }
}
