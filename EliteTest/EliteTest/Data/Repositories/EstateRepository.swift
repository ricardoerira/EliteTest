//
//  EstateRepository.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import Combine
import CoreData

enum EstateRepositoryError: Error {
    case saveFailed(String)
    case imageSaveFailed(String)
    case unknown
}

class EstateRepository: EstateRepositoryProtocol {
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func save(estate: EstateModel) -> AnyPublisher<Void, EstateRepositoryError> {
            let context = persistentContainer.newBackgroundContext()

            return Future<Void, EstateRepositoryError> { promise in
                context.perform {
                    let estateEntity = EstateEntity(context: context)
                    estateEntity.id = UUID()
                    estateEntity.type = estate.type
                    estateEntity.maxGuests = Int16(estate.maxGuests)
                    estateEntity.beds = Int16(estate.beds)
                    estateEntity.bathrooms = Int16(estate.bathrooms)
                    estateEntity.title = estate.title
                    estateEntity.desc = estate.description

                    // Save estate first
                    do {
                        try context.save()
                    } catch {
                        promise(.failure(.saveFailed("Failed to save estate: \(error.localizedDescription)")))
                        return
                    }

                    // Save images linked to estate
                    do {
                        try self.saveImages(photos: estate.photos, estateEntity: estateEntity, context: context)
                        promise(.success(()))
                    } catch {
                        promise(.failure(.imageSaveFailed("Failed to save images: \(error.localizedDescription)")))
                    }
                }
            }
            .eraseToAnyPublisher()
        }

        public func saveImages(photos: [Data], estateEntity: EstateEntity, context: NSManagedObjectContext) throws {
            for data in photos {
                let newPhotoEntity = EstatePhotoEntity(context: context)
                newPhotoEntity.id = UUID()
                newPhotoEntity.imageData = data
                newPhotoEntity.estate = estateEntity
            }

            try context.save()
        }
}
