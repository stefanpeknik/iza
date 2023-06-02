//
//  JsonHelper.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import Foundation

final class JsonHelper {
    static let shared = JsonHelper()
    
    let decoder: JSONDecoder
    let encoder: JSONEncoder
    
    private init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601 // Customize the decoder configuration as needed
        
        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601 // Customize the encoder configuration as needed
    }
}
