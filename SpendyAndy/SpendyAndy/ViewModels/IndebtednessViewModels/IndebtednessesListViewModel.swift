//
//  IndebtednessesListViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import Foundation

final class IndebtednessesListViewModel: ObservableObject {
    @Published var debts: [Indebtedness] = []
    
    
    func payDebt(debt: Indebtedness) async throws {
        Logger.debug("updating a debt...")
        
        let urlString = Constants.baseURL + Endpoints.indebtednesses + debt.id!.uuidString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }

        let updatedDebt = Indebtedness(debt: debt.debt, isPayed: true, debtor: debt.debtor, creditor: debt.creditor, transaction: debt.transaction)
        
        try await HttpClient.shared.sendData(to: url, object: updatedDebt, httpMethod: HttpMethods.PUT.rawValue)
        
        Logger.debug("updated a debt")
    }
    
    func fetchDebts(user: User) async throws {
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
            self.debts = debtsResponse.filter { $0.isPayed == false }
            Logger.debug("successfuly fetched debts.")
        }
    }
    
}
