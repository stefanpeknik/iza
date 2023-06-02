//
//  User.swift
//  
//
//  Created by Štefan Pekník on 22.05.2023.
//

import Foundation

struct User: Identifiable, Codable, Hashable {
    var id: UUID?

    var username: String
    
    var name: String
    

    init(id: UUID? = nil,
         username: String,
         name: String) {
        self.id = id
        self.username = username
        self.name = name
    }
}
