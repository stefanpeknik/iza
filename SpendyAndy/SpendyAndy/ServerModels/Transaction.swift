//
//  Transaction.swift
//  
//
//  Created by Štefan Pekník on 24.05.2023.
//

import Foundation

struct Transaction: Identifiable, Codable {

    var id: UUID?
    
    var toWho: String
    
    var cost: Double
    
    var date: Date
    
    var payer: User?
            
    init(id: UUID? = nil,
         toWho: String,
         cost: Double,
         date: Date,
         payer: User?) {
        self.id = id
        self.toWho = toWho
        self.cost = cost
        self.date = date
        self.payer = payer
    }
}
