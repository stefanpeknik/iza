//
//  AddUserViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import Foundation

final class AddUserViewModel: ObservableObject {
    @Published var name = ""
    @Published var username = ""
    
    @Published var usernameTaken = false
    
    init() {}
    
    func addUser() async throws -> Bool {
        Logger.debug("adding new user...")
        let urlString = Constants.baseURL + Endpoints.users
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let user = User(username: self.username, name: self.name)
        
        do {
            try await HttpClient.shared.sendData(to: url, object: user, httpMethod: HttpMethods.POST.rawValue)
            Logger.debug("added new user")
            return true
        }
        catch {
            Logger.debug("username already taken")
            DispatchQueue.main.async {
                self.usernameTaken = true
                self.username = ""
            }
            return false
        }
    }
}

