import SwiftUI

struct ProfileView: View {
    @State private var access: String? // Store authentication token
    @State private var validationStatus: String = "" // Store validation result
    
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
                
                Section(header: Text("Account Actions")) {
                    Button("Validate") {
                        validateUser()
                    }
                    .foregroundColor(.blue)
                    
                    if !validationStatus.isEmpty {
                        Text(validationStatus)
                            .font(.caption)
                            .foregroundColor(access != nil ? .green : .red)
                    }
                    
                    Button("Logout") {
                        logout()
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Your Profile")
        }
        .onAppear {
            loadAccessToken()
        }
    }
    
    struct AuthResponse: Decodable {
        let access: String
    }

    func validateUser() {
        guard let credentials = loadCredentials() else {
            DispatchQueue.main.async {
                self.validationStatus = "Missing credentials."
            }
            return
        }

        guard let url = URL(string: "https://fydp-backend-production.up.railway.app/api/auth/login/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "email": credentials.email,
            "password": credentials.password
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let authResponse = try JSONDecoder().decode(AuthResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.access = authResponse.access
                        self.validationStatus = "Validation successful!"
                        KeychainHelper.shared.save(authResponse.access, forKey: "accessToken") // Save token in Keychain
                    }
                } catch {
                    if let rawString = String(data: data, encoding: .utf8) {
                        print("Raw Response: \(rawString)") // Debugging output
                    }
                    DispatchQueue.main.async {
                        self.validationStatus = "Error decoding response: \(error.localizedDescription)"
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.validationStatus = "Network error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
    
    func loadAccessToken() {
        self.access = KeychainHelper.shared.get(forKey: "accessToken")
    }
    
    func logout() {
        KeychainHelper.shared.delete(forKey: "accessToken")
        self.access = nil
        self.validationStatus = "Logged out successfully."
    }

    func loadCredentials() -> (email: String, password: String)? {
        guard let path = Bundle.main.path(forResource: "Secrets", ofType: "plist") else {
            print("Path for resource not found")
            return nil
        }
        
        guard let data = FileManager.default.contents(atPath: path) else {
            print("Data conversion failed")
            return nil
        }
        
        do {
            let propertyList = try PropertyListSerialization.propertyList(from: data, format: nil)
            guard let dict = propertyList as? [String: String],
                  let email = dict["email"],
                  let password = dict["password"] else {
                print("Dictionary casting or key extraction failed")
                return nil
            }
            
            return (email, password)
            
        } catch let error {
            print("Error serializing: \(error.localizedDescription)")
        }
        
        return nil
    }
}
