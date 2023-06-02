//
//  TransactionController.swift
//  
//
//  Created by Štefan Pekník on 26.05.2023.
//

import Fluent
import Vapor

struct TransactionController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let transactions = routes.grouped("transactions")
        transactions.get(use: getTransactions)
        transactions.post(use: createTransaction)
        
        transactions.group(":transactionId") { transaction in
            transaction.put(use: updateTransaction)
            transaction.delete(use: deleteTransaction)
        }
    }
    
    func getTransactions(req: Request) async throws -> [Transaction] {
        return try await Transaction.query(on: req.db).with(\.$payer).all()
    }
    
    func createTransaction(req: Request) async throws -> Transaction {
        let transaction = try req.content.decode(Transaction.self)
        try await transaction.save(on: req.db)
        return transaction
    }
    
    func updateTransaction(req: Request) async throws -> Transaction {
        guard let transactionId = req.parameters.get("transactionId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }

        let updatedTransaction = try req.content.decode(Transaction.self)

        guard let transaction = try await Transaction.find(transactionId, on: req.db) else {
            throw Abort(.internalServerError)
        }
        
        transaction.toWho = updatedTransaction.toWho
        transaction.cost = updatedTransaction.cost
        transaction.date = updatedTransaction.date
        try await transaction.update(on: req.db)
        return transaction
    }
    
    func deleteTransaction(req: Request) async throws -> Response {
        guard let transactionId = req.parameters.get("transactionId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        try await Transaction.query(on: req.db)
            .filter(\.$id == transactionId)
            .delete()
        
        let response = Response(status: .ok)
        try response.content.encode("Transaction deleted")
        return response
    }
}
