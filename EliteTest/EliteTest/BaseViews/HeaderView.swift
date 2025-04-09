//
//  HeaderView.swift
//  EliteTest
//
//  Created by andres on 8/04/25.
//

import Foundation
import SwiftUI

import SwiftUI

struct HeaderView: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
       

            
            Color("AccentBlue") // azul oscuro
                .ignoresSafeArea(edges: .top)
            
       
            WaveBackground()
                .fill(Color("PrimaryBlue")) // azul claro
                .frame(height: 180)
                .offset(y: -20)
            
            HStack {
                Image("elite_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                Spacer()
               
            }.padding(.top, -150)

            
      
        }
        .frame(height: 150)
    }
}

struct WaveBackground: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: 0, y: rect.height))
            path.addCurve(to: CGPoint(x: rect.width, y: rect.height * 0.3),
                          control1: CGPoint(x: rect.width * 0.25, y: rect.height * 1.2),
                          control2: CGPoint(x: rect.width * 0.75, y: rect.height * 0.1))
            path.addLine(to: CGPoint(x: rect.width, y: 0))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.closeSubpath()
        }
    }
}


struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HeaderView()
                .previewDisplayName("Default")
                .previewLayout(.sizeThatFits)
        }
        .background(Color.gray.opacity(0.1))
    }
}
