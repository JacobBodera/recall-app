//
//  TrackedObject.swift
//  Recall
//
//  Created by Jacob Bodera on 2025-03-07.
//


struct TrackedObject: Identifiable, Decodable {
    let id: Int
    let name: String
    let last_location: String
    let image: String // Base64 encoded image
}
