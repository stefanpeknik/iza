//
//  UsersListViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 27.05.2023.
//

import Foundation

final class UsersListViewModel: ObservableObject {
    @Published var users = [User]()
    
    func fetchUsers() async throws {
        Logger.debug("fetching users...")
        
        let urlString = Constants.baseURL + Endpoints.users
        
        guard let url = URL(string: urlString) else {
            Logger.error("invalid url: \(urlString)")
            throw HttpError.badURL
        }
        
        let usersResponse: [User] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.users = usersResponse
            Logger.debug("successfuly fetched users.")
        }
    }
}
