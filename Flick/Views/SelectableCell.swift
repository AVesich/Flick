//
//  SelectableCell.swift
//  Flick
//
//  Created by Austin Vesich on 5/30/25.
//

import SwiftUI

struct SelectableCell<Content: View>: View {
    
    public var hovering: Bool!
    public var content: (_ hovering: Bool) -> Content
    
    var body: some View {
        content(hovering)
    }
}

#Preview {
    SelectableCell(hovering: true) { selected in
        Text("Hello World!")
    }
}
