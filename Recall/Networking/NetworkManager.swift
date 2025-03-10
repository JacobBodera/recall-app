import Foundation

class NetworkManager: ObservableObject {
    @Published var objects: [ObjectTracking] = []
    
    private var accessToken: String? {
        KeychainHelper.shared.get(forKey: "accessToken")
    }
    
    func fetchAllData() {
        guard let url = URL(string: "https://fydp-backend-production.up.railway.app/ObjectTracking/"),
              let token = accessToken else {
            print("Missing access token")
            return
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let decodedData = try JSONDecoder().decode([ObjectTracking].self, from: data)
                    DispatchQueue.main.async {
                        self.objects = decodedData
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            } else if let error = error {
                print("Network error: \(error.localizedDescription)")
            }
        }.resume()
    }

    func createObject(name: String, completion: @escaping (Int?) -> Void) {
        guard let url = URL(string: "https://fydp-backend-production.up.railway.app/ObjectTracking/"),
              let token = accessToken else {
            print("Missing access token")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        let body = ["name": name]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        print("Sending request to \(url) with body: \(body)")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error creating object: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned from server")
                completion(nil)
                return
            }
            
            print("Received response data: \(String(data: data, encoding: .utf8) ?? "")")
            
            do {
                let decodedData = try JSONDecoder().decode(CreateObjectResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(decodedData.id)
                }
            } catch {
                print("Failed to decode response: \(error)")
                completion(nil)
            }
        }.resume()
    }
}
