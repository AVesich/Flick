//
//  SelectableCell.swift
//  Flick
//
//  Created by Austin Vesich on 5/30/25.
//

import SwiftUI

struct HoverCell<Content: View>: View {
    
    public var hovering: Bool!
    public var content: (_ hovering: Bool) -> Content
    
    var body: some View {
        content(hovering)
    }
}

#Preview {
    HoverCell(hovering: true) { selected in
        Text("Hello World!")
    }
}
