//
//  AddEstateViewModelTests.swift
//  EliteTestTests
//
//  Created by Wilson Ricardo Erira  on 9/04/25.
//

import XCTest
import Combine
import CoreLocation
@testable import EliteTest

final class AddEstateViewModelTests: XCTestCase {
    
    var viewModel: AddEstateViewModel!
    var mockRepository: MockEstateRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockEstateRepository()
        viewModel = AddEstateViewModel(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        viewModel = nil
        mockRepository = nil
        cancellables = nil
        super.tearDown()
    }

    func testFormValidation_success() {
        viewModel.title = "Casa Bonita"
        viewModel.description = String(repeating: "a", count: 20)
        viewModel.selectedImages = (0..<5).map { _ in ImageItem(id: UUID(), image: UIImage()) }
        viewModel.estateLocation = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)

        let expectation = self.expectation(description: "Validation triggered")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertTrue(self.viewModel.isFormValid)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func testCreateEstate_successfulSave() {
        mockRepository.shouldSucceed = true

        viewModel.title = "Title"
        viewModel.description = String(repeating: "a", count: 20)
        viewModel.selectedImages = (0..<5).map { _ in ImageItem(id: UUID(), image: UIImage()) }
        viewModel.estateLocation = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)

        let expectation = self.expectation(description: "Estate saved")

        viewModel.$showAlert
            .dropFirst()
            .sink { show in
                if show {
                    XCTAssertTrue(self.viewModel.isSuccessAlert)
                    XCTAssertEqual(self.viewModel.alertMessage, "Propiedad registrada con éxito.")
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.createEstate()

        wait(for: [expectation], timeout: 2.0)
    }

    func testCreateEstate_failureSave() {
        mockRepository.shouldSucceed = false

        viewModel.title = "Title"
        viewModel.description = String(repeating: "a", count: 20)
        viewModel.selectedImages = (0..<5).map { _ in ImageItem(id: UUID(), image: UIImage()) }
        viewModel.estateLocation = CLLocationCoordinate2D(latitude: 1.0, longitude: 1.0)

        let expectation = self.expectation(description: "Failed to save estate")

        viewModel.$showAlert
            .dropFirst()
            .sink { show in
                if show {
                    XCTAssertFalse(self.viewModel.isSuccessAlert)
                    XCTAssertTrue(self.viewModel.alertMessage.contains("No se ha podido guardar la propiedad"))
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)

        viewModel.createEstate()

        wait(for: [expectation], timeout: 4.0)
    }
}
