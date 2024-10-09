//
//  SelectableScrollView.swift
//  Mini
//
//  Created by Austin Vesich on 10/8/24.
//

import SwiftUI

struct AppList: View {
    @State private var selectedRow: Int? = nil
    public var apps: [AppData]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack(spacing: 4.0) {
                ForEach(Array(apps.enumerated()), id: \.offset) { (offset, app) in
                    AppCell(app: app, index: offset)
                }
            }
        }
    }
}

//#Preview {
//    SelectableList(elements: [IdentifiableString(text: "Austin"), IdentifiableString(text: "Thomas"), IdentifiableString(text: "John")])
//}
