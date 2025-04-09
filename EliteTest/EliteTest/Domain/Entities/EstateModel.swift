//
//  EstateModel.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation

struct EstateModel: Identifiable {
    let id: UUID
    var type: String
    var maxGuests: Int
    var beds: Int
    var bathrooms: Int
    var title: String
    var description: String
    var photos: [Data]
    var location: String
}
