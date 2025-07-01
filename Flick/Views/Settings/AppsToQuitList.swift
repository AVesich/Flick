
import SwiftUI
import SwiftData

struct AppsToQuitList: View {
    
    @EnvironmentObject private var search: Search
    @Query private var apps: [AppData] = []
    @State private var selectedApp: AppData?
    @State private var searchingForApp: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            List(apps, id: \.self, selection: $selectedApp) { app in
                HStack(spacing: 16.0) {
                    IconImage(icon: app.icon)
                    Text(app.name)
                    Spacer()
                }
                .withDetectableBackground()
            }
            .scrollContentBackground(.hidden)
            .frame(height: 256.0)
            
            Divider()
            
            HStack(spacing: 8) {
                Button(action: {
                    searchingForApp.toggle()
                }) {
                    Image(systemName: "plus")
                        .frame(width: 24.0, height: 24.0)
                }
                .buttonStyle(.borderless)
                
                Divider()
                
                Button {
                    BlockedAppList.shared.unblockApp(selectedApp!)
                } label: {
                    Image(systemName: "minus")
                        .frame(width: 24.0, height: 24.0)
                }
                .buttonStyle(.borderless)
                .disabled(selectedApp == nil)
            }
            .frame(height: 24.0)
            .padding([.leading, .bottom], 8.0)
        }
        .clipShape(.rect(cornerRadius: VisualConfigConstants.smallCornerRadius))
        .overlay {
            RoundedRectangle(cornerRadius: VisualConfigConstants.smallCornerRadius)
                .stroke(.separator)
        }
        .fileImporter(isPresented: $searchingForApp,
                      allowedContentTypes: [.application]) { result in
            // If the operation fails, nothing needs to happen, so try? here
            guard let url = try? result.get() else { return }
            BlockedAppList.shared.blockApp(AppData(url: url))
        }
    }
}

#Preview {
    AppsToQuitList()
        .environmentObject(Search(appList: AllAppList.shared, windowList: ActiveWindowList.shared))
}
