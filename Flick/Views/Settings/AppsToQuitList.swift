import SwiftUI

struct AppListView: View {
    @State private var apps: [String] = ["App 1", "App 2"]
    @State private var selectedApp: String?
    
    var body: some View {
        VStack(alignment: .leading) {
            List(selection: $selectedApp) {
                ForEach(apps, id: \.self) { app in
                    Text(app)
                }
            }
            .listStyle(.inset)

            Divider()
            
            HStack(spacing: 8) {
                Button(action: {
                    // Add app logic here
                    apps.append("New App")
                }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderlessButtonStyle())
                
                Divider()
                
                Button(action: {
                    // Remove selected app logic here
                    if let selectedApp = selectedApp,
                        let index = apps.firstIndex(of: selectedApp) {
                        apps.remove(at: index)
                    }
                }) {
                    Image(systemName: "minus")
                }
                .buttonStyle(BorderlessButtonStyle())
                .disabled(selectedApp == nil)
            }
            .frame(height: 16.0)
        }
        .padding()
    }
}

#Preview {
    AppListView()
}
