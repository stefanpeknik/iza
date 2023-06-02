//
//  CreateUsers.swift
//  
//
//  Created by Štefan Pekník on 22.05.2023.
//

import Fluent

struct CreateUsers: AsyncMigration {
    func prepare(on database: FluentKit.Database) async throws {
        return try await database.schema(User.schema)
            .id()
            .field("username", .string, .required)
            .field("name", .string, .required)
            .unique(on: "username")
            .create()
    }
    
    func revert(on database: FluentKit.Database) async throws {
        return try await database.schema(User.schema).delete()
    }
}
