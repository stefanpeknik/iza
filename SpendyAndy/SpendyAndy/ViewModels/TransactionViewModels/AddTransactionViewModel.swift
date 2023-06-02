//
//  AddTransactionViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import Foundation

final class AddTransactionViewModel: ObservableObject {
    @Published var toWho: String
    @Published var transactionCost: Double
    @Published var dateTime: Date
    @Published var payer: User
        
    init(payer: User) {
        self.toWho = ""
        self.transactionCost = 1
        self.dateTime = Date()
        self.payer = payer
    }
    
    func addTransaction() async throws {
        Logger.debug("adding new transaction...")
        let urlString = Constants.baseURL + Endpoints.transactions
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        let transaction = Transaction(toWho: self.toWho, cost: self.transactionCost, date: self.dateTime, payer: self.payer)
        
        try await HttpClient.shared.sendData(to: url, object: transaction, httpMethod: HttpMethods.POST.rawValue)
        Logger.debug("added new transaction")
    }
}
