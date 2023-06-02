//
//  Indebtedness.swift
//  
//
//  Created by Štefan Pekník on 30.05.2023.
//

import Foundation

struct Indebtedness: Identifiable, Codable {

    var id: UUID?
    
    var debt: Double
    
    var isPayed: Bool
    
    var debtor: User?
    
    var creditor: User?
    
    var transaction: Transaction?
    
    init(id: UUID? = nil,
         debt: Double,
         isPayed: Bool,
         debtor: User?,
         creditor: User?,
         transaction: Transaction?) {
        self.id = id
        self.debt = debt
        self.isPayed = isPayed
        self.debtor = debtor
        self.creditor = creditor
        self.transaction = transaction
    }
}
