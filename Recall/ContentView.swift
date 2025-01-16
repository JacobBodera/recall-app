//
//  ContentView.swift
//  Recall
//
//  Created by Jacob Bodera on 2024-11-22.
//

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

struct HomeView: View {
    let items = [
        (image: "laptopcomputer", name: "Laptop", location: "Living Room"),
        (image: "phone", name: "Phone", location: "Bedroom"),
        (image: "tv", name: "Television", location: "Family Room"),
        (image: "wallet.pass", name: "Wallet", location: "Dining Table"),
        (image: "cup.and.saucer", name: "Mug", location: "Kitchen"),
        (image: "eyeglasses", name: "Glasses", location: "Desk"),
        (image: "key", name: "Keys", location: "Entryway"),
        (image: "books.vertical", name: "Books", location: "Bookshelf"),
        (image: "lightbulb", name: "Lamp", location: "Side Table"),
        (image: "gamecontroller", name: "Game Controller", location: "Entertainment Center"),
        (image: "headphones", name: "Headphones", location: "Bedside Table"),
        (image: "backpack", name: "Backpack", location: "Closet")
    ]

    var body: some View {
        NavigationView {
            List(items, id: \.name) { item in
                HStack(spacing: 15) {
                    Image(systemName: item.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)

                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.headline)

                        Text("Location: \(item.location)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 5)
            }
            .navigationTitle("Home")
        }
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
