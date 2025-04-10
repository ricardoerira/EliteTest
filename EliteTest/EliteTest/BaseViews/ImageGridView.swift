//
//  ImageGridView.swift
//  EliteTest
//
//  Created by Wilson Ricardo Erira  on 8/04/25.
//

import Foundation
import SwiftUI

struct ImageGridView: View {
    @Binding var images: [ImageItem]
    @State var draggedItem: ImageItem?
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(images) { item in
                    Image(uiImage: item.image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 4)
                        .onDrag {
                            self.draggedItem = item
                            return NSItemProvider(object: item.id.uuidString as NSString)
                        }
                        .onDrop(of: [.text], delegate: DropViewDelegate(currentItem: item, items: $images, draggedItem: $draggedItem))
                }
            }
            .padding()
        }
    }
}

struct DropViewDelegate: DropDelegate {
    let currentItem: ImageItem
    @Binding var items: [ImageItem]
    @Binding var draggedItem: ImageItem?
    
    func performDrop(info: DropInfo) -> Bool {
        self.draggedItem = nil
        return true
    }
    
    func dropEntered(info: DropInfo) {
        guard let draggedItem = draggedItem, draggedItem != currentItem else { return }
        
        if let fromIndex = items.firstIndex(of: draggedItem),
           let toIndex = items.firstIndex(of: currentItem) {
            withAnimation {
                let fromItem = items.remove(at: fromIndex)
                items.insert(fromItem, at: toIndex)
            }
        }
    }
}
