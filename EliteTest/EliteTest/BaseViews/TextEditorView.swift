//
//  TextField.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import SwiftUI

struct TextEditorView: View {
    let title: String
    let errorMessage: String

    @Binding var isValid: Bool
    @Binding var value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
            
            TextField("", text: $value).multilineTextAlignment(.leading)
                .foregroundColor(.white)
                .font(.subheadline.bold())
                .frame(maxWidth: .infinity)
                .frame(maxHeight: 80)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1))
            if !isValid {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.subheadline)
                Image(systemName: "exclamationmark.triangle.fill")
            }
        }

    }
}
