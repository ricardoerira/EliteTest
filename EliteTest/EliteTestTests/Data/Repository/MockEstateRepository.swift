//
//  MockEstateRepository.swift
//  EliteTestTests
//
//  Created by Wilson Ricardo Erira  on 9/04/25.
//

import Foundation
import Combine
@testable import EliteTest

class MockEstateRepository: EstateRepositoryProtocol {
    var shouldSucceed = true

    func save(estate: EstateModel) -> AnyPublisher<Void, EstateRepositoryError> {
        if shouldSucceed {
            return Just(())
                .setFailureType(to: EstateRepositoryError.self)
                .eraseToAnyPublisher()
        } else {
            return Fail(error: EstateRepositoryError.saveFailed)
                .eraseToAnyPublisher()
        }
    }
}
