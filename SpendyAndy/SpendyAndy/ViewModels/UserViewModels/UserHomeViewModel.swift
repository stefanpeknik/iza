//
//  UserHomeViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 30.05.2023.
//

import Foundation

final class UserHomeViewModel: ObservableObject {
    @Published var transactions = [Transaction]()
    @Published var owes: Double = 0

    func fetchUsersTransactions(user: User) async throws {
        Logger.debug("fetching transactions...")
        
        guard let userId = user.id else {
            return
        }
        
        let urlString = Constants.baseURL + Endpoints.users + userId.uuidString + "/" + Endpoints.transactions
        
        guard let url = URL(string: urlString) else {
            Logger.error("invalid url: \(urlString)")
            throw HttpError.badURL
        }
        
        let transactionResponse: [Transaction] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.transactions = Array(transactionResponse.prefix(5))
            Logger.debug("successfuly fetched transactions.")
        }
    }
    
    func CountDebt(user: User) async throws {
        Logger.debug("fetching debts...")
        
        guard let userId = user.id else {
            return
        }
        
        let urlString = Constants.baseURL + Endpoints.users + userId.uuidString + "/" + Endpoints.debts
        
        guard let url = URL(string: urlString) else {
            Logger.error("invalid url: \(urlString)")
            throw HttpError.badURL
        }
        
        let debtsResponse: [Indebtedness] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            var debts = debtsResponse.filter { $0.isPayed == false }
            Logger.debug("successfuly fetched debts.")
            for debt in debts {
                self.owes += debt.debt
            }
        }
    }
    
    
}
