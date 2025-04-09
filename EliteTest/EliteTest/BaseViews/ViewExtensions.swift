//
//  ViewExtensions.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import SwiftUI

extension View {
    func glassFieldStyle() -> some View {
        self
            .padding()
            .foregroundColor(.white)
            .font(.subheadline.bold())
            .frame(maxWidth: .infinity)
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(8)
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.white.opacity(0.3), lineWidth: 1))
        
    }
}
