import SwiftUI

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

struct TrackedObject: Identifiable, Decodable {
    let id: Int
    let name: String
    let last_location: String
}

// Networking manager to fetch all objects
class NetworkManager: ObservableObject {
    @Published var objects: [TrackedObject] = []

    func fetchAllData() {
        guard let url = URL(string: "http://127.0.0.1:8000/ObjectTracking/") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([TrackedObject].self, from: data)
                    DispatchQueue.main.async {
                        self.objects = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}

struct HomeView: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        NavigationView {
            List(networkManager.objects) { object in
                ObjectCellView(object: object)
            }
            .listStyle(PlainListStyle())
            .refreshable {
                networkManager.fetchAllData() // Refresh when swiped down
            }
            .navigationTitle("Tracked Objects") // Uses default navigation title
            .onAppear {
                networkManager.fetchAllData()
            }
        }
    }
}


struct ObjectCellView: View {
    let object: TrackedObject

    var body: some View {
        HStack {
            Image(systemName: "location.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)

            VStack(alignment: .leading) {
                Text(object.name)
                    .font(.headline)
                Text("Last seen at: \(object.last_location)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.leading, 10) // Adds space between the image and text

            Spacer()
        }
        .padding(8)
    }
}

struct ProfileView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Profile Information")) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Jacob Bodera")
                                .font(.headline)
                            Text("jbodera@uwaterloo.ca")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Text("Phone: +1 (123) 456-7890")
                    Text("Address: 123 Main St, Waterloo, ON")
                }
                
                Section(header: Text("Account Settings")) {
                    Button("Edit Profile") {
                        print("Edit Profile tapped")
                    }
                    Button("Logout") {
                        print("Logout tapped")
                    }
                        .foregroundColor(.red)
                }
            }
            .navigationTitle("Your Profile")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Preferences")) {
                    Toggle("Enable Notifications", isOn: .constant(true))
                    Toggle("Dark Mode", isOn: .constant(false))
                }
                
                Section(header: Text("Account")) {
                    Button("Change Password") {
                        print("Change Password tapped")
                    }
                    Button("Privacy Settings") {
                        print("Privacy Settings tapped")
                    }
                }
                
                Section(header: Text("About")) {
                    Button("Terms of Service") {
                        print("Terms of Service tapped")
                    }
                    Button("Help & Support") {
                        print("Help & Support tapped")
                    }
                }
            }
            .navigationTitle("Settings")
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
