//
//  KeyboardKeyView.swift
//  Flick
//
//  Created by Austin Vesich on 6/21/25.
//

import SwiftUI

struct KeyboardKeyView: View {
    
    public let keyText: String
    
    var body: some View {
        Text(keyText)
            .font(.system(size: 18.0, weight: .semibold))
            .padding(.horizontal, 16.0)
            .padding(.vertical, 16.0)
            .background(.black)
            .clipShape(.rect(cornerRadius: 16.0))
    }
}

#Preview {
    VStack {
        KeyboardKeyView(keyText: "⌘")
        KeyboardKeyView(keyText: "tab")
    }
    .frame(width: 100.0)
}
