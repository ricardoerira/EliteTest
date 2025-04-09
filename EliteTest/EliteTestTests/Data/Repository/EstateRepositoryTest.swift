//
//  EstateRepositoryTest.swift
//  EliteTestTests
//
//  Created by andres on 9/04/25.
//

import XCTest
import CoreData
import Combine
@testable import EliteTest

final class EstateRepositoryTests: XCTestCase {
    var cancellables: Set<AnyCancellable> = []
    var repository: EstateRepository!
    var persistentContainer: NSPersistentContainer!
    
    override func setUp() {
        super.setUp()
   
        persistentContainer = PersistenceController.shared.container
        repository = EstateRepository(persistentContainer: persistentContainer)
    }
    
    func testSaveEstateSuccessfully() {
        let dummyImage = UIImage(systemName: "house")!.pngData()!
        let estate = EstateModel(
            id: UUID(),
            type: "Casa",
            maxGuests: 4,
            beds: 2,
            bathrooms: 1,
            title: "Bonita casa",
            description: "Casa cerca de la playa",
            photos: [dummyImage],
            location: ""
        )

        let expectation = self.expectation(description: "Saving estate succeeds")

        repository.save(estate: estate)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    XCTFail("Expected success but got error: \(error)")
                }
            }, receiveValue: {})
            .store(in: &cancellables)

        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSaveEstateFailsOnMainSave() {
        let mockContext = MockFailingContext(concurrencyType: .privateQueueConcurrencyType)
        mockContext.failType = .onSave

        let repo = TestableEstateRepository(container: persistentContainer, testContext: mockContext)

        let estate = EstateModel(
            id: UUID(), type: "Casa", maxGuests: 2, beds: 1, bathrooms: 1,
            title: "Test", description: "Test", photos: [], location: ""
        )

        let expectation = expectation(description: "Should fail on estate save")

        repo.save(estate: estate)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .saveFailed = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected failure type: \(error)")
                    }
                } else {
                    XCTFail("Expected failure, got success")
                }
            }, receiveValue: {})
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }

    func testSaveEstateFailsOnImageSave() {
        let mockContext = MockFailingContext(concurrencyType: .privateQueueConcurrencyType)
        mockContext.failType = .onImageSave

        let repo = TestableEstateRepository(container: persistentContainer, testContext: mockContext)

        let photoData = UIImage(systemName: "photo")!.pngData()!
        let estate = EstateModel(
            id: UUID(), type: "Casa", maxGuests: 2, beds: 1, bathrooms: 1,
            title: "Test", description: "Test", photos: [photoData], location: ""
        )

        let expectation = expectation(description: "Should fail on image save")

        repo.save(estate: estate)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    if case .imageSaveFailed = error {
                        expectation.fulfill()
                    } else {
                        XCTFail("Unexpected failure type: \(error)")
                    }
                } else {
                    XCTFail("Expected failure, got success")
                }
            }, receiveValue: {})
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2)
    }


    override func tearDown() {
        repository = nil
        persistentContainer = nil
        cancellables = []
        super.tearDown()
    }
    
}


final class MockFailingContext: NSManagedObjectContext {
    enum FailType {
        case onSave
        case onImageSave
    }

    var failType: FailType?
    var didCreatePhoto = false

    override func save() throws {
        if failType == .onSave && !didCreatePhoto {
            throw NSError(domain: "MockCoreData", code: 1, userInfo: [NSLocalizedDescriptionKey: "Mock save failed"])
        }

        if failType == .onImageSave && didCreatePhoto {
            throw NSError(domain: "MockCoreData", code: 2, userInfo: [NSLocalizedDescriptionKey: "Mock image save failed"])
        }

        // success
    }
}

final class TestableEstateRepository: EstateRepository {
    let testContext: MockFailingContext

    init(container: NSPersistentContainer, testContext: MockFailingContext) {
        self.testContext = testContext
        super.init(persistentContainer: container)
    }

    override func save(estate: EstateModel) -> AnyPublisher<Void, EstateRepositoryError> {
        let context = testContext // inject failing context

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

                do {
                    try context.save()
                } catch {
                    promise(.failure(.saveFailed("Failed to save estate: \(error.localizedDescription)")))
                    return
                }

                do {
                    context.didCreatePhoto = true
                    try self.saveImages(photos: estate.photos, estateEntity: estateEntity, context: context)
                    promise(.success(()))
                } catch {
                    promise(.failure(.imageSaveFailed("Failed to save images: \(error.localizedDescription)")))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
