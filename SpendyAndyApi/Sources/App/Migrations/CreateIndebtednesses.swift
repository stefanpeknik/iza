//
//  CreateIndebtednesses.swift
//  
//
//  Created by Štefan Pekník on 30.05.2023.
//

import Fluent

struct CreateIndebtednesses: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        return try await database.schema(Indebtedness.schema)
            .id()
            .field("debt", .double, .required)
            .field("is_payed", .bool, .required, .sql(.default(false)))
            .field("debtor_id", .uuid, .references(User.schema, .id, onDelete: .setNull))
            .field("creditor_id", .uuid, .references(User.schema, .id, onDelete: .setNull))
            .field("transaction_id", .uuid, .references(Transaction.schema, .id, onDelete: .setNull))
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        return try await database.schema(Indebtedness.schema).delete()
    }
}
