//
//  EstateRepositoryProtocol.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import Combine

protocol EstateRepositoryProtocol {
    func save(estate: EstateModel) -> AnyPublisher<Void, EstateRepositoryError>
}
