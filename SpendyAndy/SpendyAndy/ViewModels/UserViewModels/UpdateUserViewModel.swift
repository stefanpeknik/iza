//
//  UpdateUserViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import Foundation

final class UpdateUserViewModel: ObservableObject {
    @Published var name = ""
    
    let username: String
    let id: UUID
    
    init(selectedUser: User) {
        self.name = selectedUser.name
        self.username = selectedUser.username
        self.id = selectedUser.id!
    }
    
    func updateUser() async throws {
        Logger.debug("updating a user...")
        let urlString = Constants.baseURL + Endpoints.users + self.id.uuidString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let user = User(id: self.id, username: self.username, name: self.name)
        
        try await HttpClient.shared.sendData(to: url, object: user, httpMethod: HttpMethods.PUT.rawValue)
        Logger.debug("updated a user")
    }
    
    func deleteUser() async throws {
        Logger.debug("deleteing a user...")
        let urlString = Constants.baseURL + Endpoints.users + self.id.uuidString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
                
        try await HttpClient.shared.sendReqest(to: url, httpMethod: HttpMethods.DELETE.rawValue)
        Logger.debug("deleted a user")
    }
}
