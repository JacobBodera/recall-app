struct CreateObjectResponse: Decodable {
    let id: Int
    let created_at: String
    let name: String
    let location_image: String?
    let location_description: String?
}
