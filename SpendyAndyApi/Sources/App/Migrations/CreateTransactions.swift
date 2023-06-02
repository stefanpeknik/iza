//
//  CreateTransactions.swift
//  
//
//  Created by Štefan Pekník on 24.05.2023.
//

import Fluent

struct CreateTransactions: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        return try await database.schema(Transaction.schema)
            .id()
            .field("to_who", .string, .required)
            .field("date", .datetime, .required)
            .field("cost", .double , .required)
            .field("payer_id", .uuid, .references(User.schema, .id, onDelete: .setNull))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        return try await database.schema(Transaction.schema).delete()
    }
}
