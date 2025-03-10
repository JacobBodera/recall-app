//
//  ObjectImage.swift
//  Recall
//
//  Created by Wesley Kim on 2025-03-10.
//

struct ObjectImage: Identifiable, Decodable {
    let id: Int
    let object_image: String // Base64 encoded image
    let tracking_object_id: Int
}
