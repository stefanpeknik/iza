//
//  IndebtednessController.swift
//  
//
//  Created by Štefan Pekník on 30.05.2023.
//

import Fluent
import Vapor

struct IndebtednessController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let indebtednesses = routes.grouped("indebtednesses")
        indebtednesses.post(use: createIndebtedness)
        
        indebtednesses.group(":indebtednessId") { indebtedness in
            indebtedness.put(use: updateIndebtedness)
            indebtedness.delete(use: deleteIndebtedness)
        }
        
        indebtednesses.group(":transactionId") { indebtedness in
            indebtedness.get(use: getByTransaction)
        }
    }
    
    func createIndebtedness(req: Request) async throws -> Indebtedness {
        let indebtedness = try req.content.decode(Indebtedness.self)
        try await indebtedness.save(on: req.db)
        return indebtedness
    }
    
    func updateIndebtedness(req: Request) async throws -> Indebtedness {
        guard let indebtednessId = req.parameters.get("indebtednessId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }

        let updatedIndebtedness = try req.content.decode(Indebtedness.self)

        guard let indebtedness = try await Indebtedness.find(indebtednessId, on: req.db) else {
            throw Abort(.internalServerError)
        }
        
        indebtedness.debt = updatedIndebtedness.debt
        indebtedness.isPayed = updatedIndebtedness.isPayed
        try await indebtedness.update(on: req.db)
        return indebtedness
    }
    
    func deleteIndebtedness(req: Request) async throws -> Response {
        guard let indebtednessId = req.parameters.get("indebtednessId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        try await Indebtedness.query(on: req.db)
            .filter(\.$id == indebtednessId)
            .delete()
        
        let response = Response(status: .ok)
        try response.content.encode("Indebtedness deleted")
        return response
    }
    
    func getByTransaction(req: Request) async throws -> [Indebtedness] {
        guard let transactionId = req.parameters.get("transactionId", as: UUID.self) else {
            throw Abort(.internalServerError)
        }
        
        return try await Indebtedness.query(on: req.db)
            .filter(\.$transaction.$id == transactionId)
            .with(\.$debtor)
            .with(\.$creditor)
            .with(\.$transaction) { $0.with(\.$payer) }
            .all()
    }

    
}
