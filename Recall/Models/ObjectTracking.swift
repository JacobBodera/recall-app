//
//  ObjectTracking.swift
//  Recall
//
//  Created by Jacob Bodera on 2025-03-07.
//


struct ObjectTracking: Identifiable, Decodable {
    let id: Int
    let name: String
    let location_image: String // Base64 encoded image
    let location_description: String
}
