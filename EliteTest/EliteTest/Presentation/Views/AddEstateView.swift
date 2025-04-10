//
//  AddEstateView.swift
//  EliteTest
//
//  Created by Wilson Ricardo Erira  on 8/04/25.
//

import SwiftUI
import Combine
import SwiftUI
import PhotosUI


enum Field {
    case title
    case description
}

struct AddEstateView: View {
    @StateObject var viewModel: AddEstateViewModel
    @FocusState private var focusedField: Field?
    @State var pickerItems: [PhotosPickerItem] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            gradientView()
            VStack(spacing: 0) {
                HeaderView().ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 24) {
                        titleView()
                        formView()
                            .disabled(viewModel.isLoading)
                                        .blur(radius: viewModel.isLoading ? 3 : 0)
                    }
                    .padding(.horizontal)
                }
                
                if viewModel.isLoading {
                    VStack {
                        ProgressView("Guardando propiedad...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .padding()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                            .shadow(radius: 10)
                    }
                    .transition(.opacity)
                    .zIndex(1)
                }
            }

        }
        .animation(.easeInOut, value: viewModel.isLoading)
        .sheet(isPresented: $viewModel.showPhotoPicker) {
            PhotoPicker(selectedImages: $viewModel.selectedImages)
            
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(
                title: Text(viewModel.isSuccessAlert ? "Éxito" : "Error"),
                message: Text(viewModel.alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    @ViewBuilder private func titleView() -> some View {
        HStack {
            Spacer()
            VStack(spacing: 8) {
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.white.opacity(0.9))
                Text("Nueva Propiedad")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            Spacer()
        }
        .padding()
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
    }

    @ViewBuilder private func formView() -> some View {
        typeEstatePicker()
        stepperSection()
        textFieldsSection()
        googleMapsView()
        imagePicker()
        registerButton()
    }
    
    @ViewBuilder private func gradientView() -> some View {
        LinearGradient(gradient: Gradient(colors:
                                            [Color("AccentBlue"),
                                             Color("AccentBlue"),
                                             Color("AccentBlue"),
                                             Color("PrimaryBlue"),
                                             Color("PrimaryBlue"),
                                             Color("PrimaryBlue")]),
                       startPoint: .top,
                       endPoint: .bottomTrailing).ignoresSafeArea()
    }
    
    @ViewBuilder private func typeEstatePicker() -> some View {
        Text("Tipo de propiedad")
            .foregroundColor(.white)
            .font(.subheadline.bold())
        Picker("Tipo de propiedad", selection: $viewModel.type) {
            ForEach(viewModel.estateTypes, id: \.self) {
                Text($0)
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .background(.ultraThinMaterial)
        .cornerRadius(8)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.white.opacity(0.3), lineWidth: 1))
    }
    
    @ViewBuilder private func textFieldsSection() -> some View {
        TextEditorView(title: "Título de la propiedad",
                       errorMessage: "El título debe tener al menos 3 caracteres.",
                       isValid: $viewModel.isTitleValid,
                       value: $viewModel.title)
        
        TextEditorView(title: "Descripción de la propiedad",
                       errorMessage: "La descripción debe tener al menos 20 caracteres.",
                       isValid: $viewModel.isDescriptionValid,
                       value: $viewModel.description)
    }
    
    @ViewBuilder private func stepperSection() -> some View {
        StepperFieldView(
            title: "Máximo de Viajeros",
            value: $viewModel.maxGuests,
            min: 1,
            max: 20
        )
        
        StepperFieldView(
            title: "Camas por propiedad",
            value: $viewModel.beds,
            min: 1,
            max: 20
        )
        
        StepperFieldView(
            title: "Cantidad de baños",
            value: $viewModel.bathrooms,
            min: 1,
            max: 20
        )
    }
    
    @ViewBuilder private func googleMapsView() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Ubicación de la Propiedad")
                .font(.title3.bold())
                .foregroundColor(.white)
            GoogleMapView(selectedCoordinate: $viewModel.estateLocation)
                .frame(height: 300)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1))
                .padding(.vertical)
            if !viewModel.isLocationValid {
                Image(systemName: "exclamationmark.triangle.fill")
                Text("Localiza tu propiedad")
                    .foregroundColor(.red)
                    .font(.subheadline).bold()
                
            }
        }
    }
    
    @ViewBuilder private func imagePicker() -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Fotos de la Propiedad")
                .font(.title3.bold())
                .foregroundColor(.white)
            Button(action: {
                viewModel.showPhotoPicker = true
            }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white.opacity(0.8))
            }
            ImageGridView(images: $viewModel.selectedImages, draggedItem: viewModel.selectedImages.first)
            
            if !viewModel.isPhotosValid {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                Text("Agrega al menos 5 fotos")
                    .foregroundColor(.red)
                    .font(.subheadline).bold()
                
            }
        }
    }
    
    @ViewBuilder private func registerButton() -> some View {
        Button(action: {
            viewModel.createEstate()
        }) {
            Text("Guardar Propiedad")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(viewModel.isFormValid ? Color("AccentBlue") : Color("AccentBlue").opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 6)
        }
        .disabled(!viewModel.isFormValid)
    }
}

struct AddEstateView_Previews: PreviewProvider {
    static var previews: some View {
        AddEstateView(viewModel: AddEstateViewModel())
            .preferredColorScheme(.light)
        
    }
    
}
