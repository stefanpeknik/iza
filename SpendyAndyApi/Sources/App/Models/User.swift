//
//  User.swift
//  
//
//  Created by Štefan Pekník on 22.05.2023.
//

import Fluent
import Vapor

final class User: Model, Content {
    static let schema: String = "users"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "username")
    var username: String
    
    @Field(key: "name")
    var name: String
    
    @Children(for: \.$debtor)
    var debts: [Indebtedness]
    
    @Children(for: \.$creditor)
    var credits: [Indebtedness]
    
    @Children(for: \.$payer)
    var transactions: [Transaction]
    
    
    init() {}

    init(id: UUID? = nil, username: String, name: String) {
        self.id = id
        self.username = username
        self.name = name
    }
}
