import SwiftUI
import PhotosUI

struct TabViewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

struct DetailsView: View {
    var body: some View {
        Text("Here are the details!")
            .font(.title)
            .padding()
    }
}

#Preview {
    ContentView()
}
