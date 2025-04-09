//
//  StepperField.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import SwiftUI

struct StepperFieldView: View {
    let title: String
    let subtitle: String = ""
    @Binding var value: Int
    let min: Int
    let max: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title3.bold())
                .foregroundColor(.white)
            
            if !subtitle.isEmpty {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            HStack {
                Text("\(value)")
                    .foregroundColor(.white)
                    .font(.subheadline.bold())
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.white.opacity(0.3), lineWidth: 1))
                
                HStack(spacing: 0) {
                    Button(action: {
                        if value > min { value -= 1 }
                    }) {
                        Image(systemName: "minus")
                            .padding()
                            .foregroundColor(.white.opacity(0.9))

                    }

                    Divider().frame(width: 1).background(Color.white.opacity(0.3))

                    Button(action: {
                        if value < max { value += 1 }
                    }) {
                        Image(systemName: "plus")
                            .padding()
                            .foregroundColor(.white.opacity(0.9))

                    }
                }
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.white.opacity(0.3), lineWidth: 1))
            }
        }
        .padding(.vertical, 7)
    }
}
