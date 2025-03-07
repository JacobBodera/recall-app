import SwiftUI

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
