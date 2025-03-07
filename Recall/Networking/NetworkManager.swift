import Foundation

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

    func createObject(name: String, completion: @escaping (Int?) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8000/CreateObject/") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["name": name]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    // Parse the response to get the id
                    if let decodedData = try? JSONDecoder().decode([String: Int].self, from: data),
                       let objectID = decodedData["id"] {
                        DispatchQueue.main.async {
                            completion(objectID)
                        }
                    }
                }
            }
        }.resume()
    }
}
