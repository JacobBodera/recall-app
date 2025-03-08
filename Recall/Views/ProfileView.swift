import SwiftUI

struct ProfileView: View {
    @State private var authToken: String? // Store authentication token
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
                            .foregroundColor(authToken != nil ? .green : .red)
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
    
    func validateUser() {
        guard let url = URL(string: "http://127.0.0.1:8000/login/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String: String] = [
            "email": "capstone@gmail.com",
            "password": "password123"
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let jsonResponse = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let token = jsonResponse["authentication_token"] as? String {
                        DispatchQueue.main.async {
                            self.authToken = token
                            self.validationStatus = "Validation successful!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.validationStatus = "Invalid credentials or server error."
                        }
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.validationStatus = "Error decoding response."
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.validationStatus = "Network error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}
