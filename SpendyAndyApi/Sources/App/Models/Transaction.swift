//
//  Transaction.swift
//  
//
//  Created by Štefan Pekník on 24.05.2023.
//

import Fluent
import Vapor

final class Transaction: Model, Content {
    static let schema: String = "transactions"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "to_who")
    var toWho: String
    
    @Field(key: "cost")
    var cost: Double
    
    @Field(key: "date")
    var date: Date
    
    @OptionalParent(key: "payer_id")
    var payer: User?
    
    @Children(for: \.$transaction)
    var indebtednesses: [Indebtedness]
    
    init() {}
    
    init(id: UUID? = nil,
         toWho: String,
         cost: Double,
         date: Date,
         payerId: User.IDValue?) {
        self.id = id
        self.toWho = toWho
        self.cost = cost
        self.date = date
        self.$payer.id = payerId
    }
}
