//
//  Indebtedness.swift
//  
//
//  Created by Štefan Pekník on 30.05.2023.
//

import Fluent
import Vapor

final class Indebtedness: Model, Content {
    static let schema: String = "indebtednesses"

    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "debt")
    var debt: Double
    
    @Field(key: "is_payed")
    var isPayed: Bool
    
    @OptionalParent(key: "debtor_id")
    var debtor: User?
    
    @OptionalParent(key: "creditor_id")
    var creditor: User?
    
    @OptionalParent(key: "transaction_id")
    var transaction: Transaction?
    
    init() {}

    init(id: UUID? = nil,
         debt: Double,
         isPayed: Bool,
         debtorId: User.IDValue?,
         creditorId: User.IDValue?,
         transactionId: Transaction.IDValue?) {
        self.id = id
        self.debt = debt
        self.isPayed = isPayed
        self.$debtor.id = debtorId
        self.$creditor.id = creditorId
        self.$transaction.id = transactionId
    }
}
