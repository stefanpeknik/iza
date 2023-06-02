//
//  UserController.swift
//  
//
//  Created by Štefan Pekník on 22.05.2023.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let users = routes.grouped("users")
        users.get(use: getUsers)
        users.post(use: createUser)
        
        users.group(":userId") { user in
            user.get("transactions", use: getUserTransactions)
            user.get("debts", use: getUserDebts)
            user.get("credits", use: getUserCredits)
            user.put(use: updateUser)
            user.delete(use: deleteUser)
        }
    }
    
    func getUsers(req: Request) async throws -> [User] {
        return try await User.query(on: req.db).all()
    }
    
    func createUser(req: Request) async throws -> User {
        let user = try req.content.decode(User.self)
        try await user.save(on: req.db)
        return user
    }
    
    func getUserTransactions(req: Request) async throws -> [Transaction] {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        return try await Transaction.query(on: req.db)
            .filter(\.$payer.$id == userId)
            .with(\.$payer)
            .sort(\.$date)
            .all()
    }
    
    func getUserDebts(req: Request) async throws -> [Indebtedness] {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        return try await Indebtedness.query(on: req.db)
            .with(\.$creditor)
            .with(\.$debtor)
            .with(\.$transaction) { $0.with(\.$payer) }
            .filter(\.$debtor.$id == userId)
            .all()
    }
    
    func getUserCredits(req: Request) async throws -> [Indebtedness] {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        return try await Indebtedness.query(on: req.db)
            .filter(\.$creditor.$id == userId)
            .filter(\.$isPayed != true)
            .with(\.$debtor)
            .with(\.$creditor)
            .with(\.$transaction) { $0.with(\.$payer) }
            .sort(Transaction.self, \.$date)
            .all()
        }
    
    func updateUser(req: Request) async throws -> User {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }

        let updatedUser = try req.content.decode(User.self)

        guard let user = try await User.find(userId, on: req.db) else {
            throw Abort(.internalServerError)
        }
        
        user.name = updatedUser.name
        user.username = updatedUser.username
        try await user.update(on: req.db)
        return user
    }
    
    func deleteUser(req: Request) async throws -> Response {
        guard let userId = req.parameters.get("userId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        try await User.query(on: req.db)
            .filter(\.$id == userId)
            .delete()
        
        let response = Response(status: .ok)
        try response.content.encode("User deleted")
        return response
    }
}
