//
//  TransactionsListViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import Foundation

final class TransactionsListViewModel: ObservableObject {
    @Published var transactions = [Transaction]()
    
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
            self.transactions = transactionResponse
            Logger.debug("successfuly fetched transactions.")
        }
    }
    
    func deleteTransaction(transaction: Transaction) async throws {
        Logger.debug("deleting a transaction...")
        let urlString = Constants.baseURL + Endpoints.transactions + transaction.id!.uuidString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
                
        try await HttpClient.shared.sendReqest(to: url, httpMethod: HttpMethods.DELETE.rawValue)
        self.transactions.removeAll(where: {$0.id == transaction.id})
        Logger.debug("deleted a transaction")
    }
}
