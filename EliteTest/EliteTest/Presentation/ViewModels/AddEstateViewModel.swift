//
//  AddEstateViewModel.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import Combine
import UIKit
import GoogleMaps
import PhotosUI

struct ImageItem: Identifiable, Equatable {
    let id: UUID
    var image: UIImage
}

class AddEstateViewModel: ObservableObject {
    @Published var estateTypes : [String] = ["Apartamento", "Casa", "Estudio"]
    @Published var type: String = "Apartamento"
    @Published var maxGuests: Int = 1
    @Published var beds: Int = 1
    @Published var bathrooms: Int = 1
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var propertyLocation: CLLocationCoordinate2D?
    @Published var isFormValid: Bool = false
    @Published var isTitleValid: Bool = true
    @Published var isLocationValid: Bool = true
    @Published var isPhotosValid: Bool = true
    @Published var isDescriptionValid: Bool = true
    @Published var selectedImages: [ImageItem] = []
    @Published var showPhotoPicker = false
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var isSuccessAlert: Bool = false
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let repository: EstateRepositoryProtocol
    
    init(repository: EstateRepositoryProtocol =  EstateRepository(persistentContainer: PersistenceController.shared.container)) {
        self.repository = repository
        self.observe()
    }
    
    func observe() {
        Publishers.CombineLatest4($title, $description, $selectedImages, $propertyLocation)
            .dropFirst()
            .sink { [weak self] title, description, selectedImages, location in
                self?.validateFields(title: title, description: description, selectedImages: selectedImages, location: location)
            }
            .store(in: &cancellables)
    }
    
    private func validateFields(title: String, description: String, selectedImages: [ImageItem], location: CLLocationCoordinate2D?) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedDescription = description.trimmingCharacters(in: .whitespacesAndNewlines)
        isLocationValid = location != nil
        isTitleValid = !trimmedTitle.isEmpty && trimmedTitle.count >= 3
        isDescriptionValid = !trimmedDescription.isEmpty && trimmedDescription.count >= 20
        isPhotosValid = selectedImages.count > 4
        isFormValid = isTitleValid && isDescriptionValid && isLocationValid && isPhotosValid
    }
    
    func clearForm() {
        type = ""
        maxGuests = 1
        beds = 1
        bathrooms = 1
        title = ""
        description = ""
        selectedImages = []
        propertyLocation = nil
    }
    
    func createProperty() {
        isLoading = true
        
        let estateModel = EstateModel(
            id: UUID(),
            type: type,
            maxGuests: maxGuests,
            beds: beds,
            bathrooms: bathrooms,
            title: title,
            description: description,
            photos: selectedImages.compactMap { $0.image.jpegData(compressionQuality: 0.8) }, location: "\(String(describing: propertyLocation?.latitude)),\(String(describing: propertyLocation?.longitude))"
        )
        
        repository.save(estate: estateModel)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .finished:
                    self?.isSuccessAlert = true
                    self?.alertMessage = "Propiedad registrada con éxito."
                    self?.showAlert = true
                    self?.clearForm()
                case .failure(let error):
                    self?.isSuccessAlert = false
                    self?.alertMessage = "Error: \(error.localizedDescription)"
                    self?.showAlert = true
                }
            } receiveValue: {}
            .store(in: &cancellables)
    }
}
