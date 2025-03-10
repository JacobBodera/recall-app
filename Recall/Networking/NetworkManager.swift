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
        guard let url = URL(string: "https://fydp-backend-production.up.railway.app/CreateObject/"),
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
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    if let decodedData = try? JSONDecoder().decode([String: Int].self, from: data),
                       let objectID = decodedData["id"] {
                        DispatchQueue.main.async {
                            completion(objectID)
                        }
                    }
                }
            } else if let error = error {
                print("Error creating object: \(error.localizedDescription)")
            }
        }.resume()
    }
}


//import Foundation
//
//class NetworkManager: ObservableObject {
//    @Published var objects: [ObjectTracking] = []
//
//    func fetchAllData() {
//        guard let url = URL(string: "https://fydp-backend-production.up.railway.app/ObjectTracking/") else { return }
//
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            if let data = data {
//                do {
//                    let decodedData = try JSONDecoder().decode([ObjectTracking].self, from: data)
//                    DispatchQueue.main.async {
//                        self.objects = decodedData
//                    }
//                } catch {
//                    print("Error decoding JSON: \(error)")
//                }
//            }
//        }.resume()
//    }
//
//    func createObject(name: String, completion: @escaping (Int?) -> Void) {
//        guard let url = URL(string: "https://fydp-backend-production.up.railway.app/CreateObject/") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        let body = ["name": name]
//        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let data = data {
//                do {
//                    // Parse the response to get the id
//                    if let decodedData = try? JSONDecoder().decode([String: Int].self, from: data),
//                       let objectID = decodedData["id"] {
//                        DispatchQueue.main.async {
//                            completion(objectID)
//                        }
//                    }
//                }
//            }
//        }.resume()
//    }
//}
