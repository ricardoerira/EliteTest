//
//  ImagePicker.swift
//  EliteTest
//
//  Created by Wilson Ricardo Erira  on 8/04/25.
//

import SwiftUI
import PhotosUI

struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var selectedImages: [ImageItem]
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 5

        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            parent.presentationMode.wrappedValue.dismiss()
            parent.selectedImages.removeAll()

            let group = DispatchGroup()

            for result in results {
                group.enter()
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    defer { group.leave() }
                    if let uiImage = image as? UIImage {
                        DispatchQueue.main.async {
                            self.parent.selectedImages.append(ImageItem(id:  UUID(), image: uiImage))
                        }
                    } else {
                        print("Error loading image: \(error?.localizedDescription ?? "unknown error")")
                    }
                }
            }

            group.notify(queue: .main) {
            }
        }
    }
}
