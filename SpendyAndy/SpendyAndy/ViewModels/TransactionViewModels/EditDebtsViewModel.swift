//
//  EditDebtsViewModel.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import Foundation

enum DebtSubmitError: LocalizedError {
    case DebtExceedsCost, DebtorNotSelected, InvalidDebt, AlreadyHasDebt
    
    var errorDescription: String? {
        switch self {
        case .DebtExceedsCost:
            return "Overall debt exceeds transaction cost."
        case .DebtorNotSelected:
            return "Debtor not selected."
        case .InvalidDebt:
            return "Debt has to be number greater than 0."
        case .AlreadyHasDebt:
            return "Selected user already has a debt."
        }
    }
}

final class EditDebtsViewModel: ObservableObject {
    
    @Published var transaction: Transaction
    @Published var users: [User] = []
    @Published var debts: [Indebtedness] = []
    
    @Published var selectedDebtor: User?
    @Published var debtCost: Double = 1
        
    @Published var errorMessage: String? = nil
    
    var remainingCost: Double {
        var debtSum: Double = 0
        
        for debt in debts {
            debtSum += debt.debt
        }
        
        return transaction.cost - (debtSum + debtCost)
    }
    
    init(transaction: Transaction) {
        self.transaction = transaction
    }
    
    func addDebt() async throws {
        Logger.debug("adding new debt...")
        
        if (remainingCost < 0) {
            throw DebtSubmitError.DebtExceedsCost
        }
        else if (selectedDebtor == nil) {
            throw DebtSubmitError.DebtorNotSelected
        }
        else if (debtCost <= 0) {
            throw DebtSubmitError.InvalidDebt
        }
        else if (debts.contains { $0.debtor?.id == selectedDebtor?.id }) {
            throw DebtSubmitError.AlreadyHasDebt
        }
        
        let debt = Indebtedness(debt: debtCost, isPayed: false, debtor: selectedDebtor, creditor: transaction.payer, transaction: transaction)
        
        let urlString = Constants.baseURL + Endpoints.indebtednesses
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
        
        try await HttpClient.shared.sendData(to: url, object: debt, httpMethod: HttpMethods.POST.rawValue)
        Logger.debug("added new debt")
        
        DispatchQueue.main.async {
            self.errorMessage = nil
        }
    }
    
    func deleteDebt(debt: Indebtedness) async throws {
        Logger.debug("deleting a debt...")
        
        let urlString = Constants.baseURL + Endpoints.indebtednesses + debt.id!.uuidString
        
        guard let url = URL(string: urlString) else {
            throw HttpError.badURL
        }
                
        try await HttpClient.shared.sendReqest(to: url, httpMethod: HttpMethods.DELETE.rawValue)
        
        DispatchQueue.main.async {
            self.debts.removeAll(where: {$0.id == debt.id})
        }
        Logger.debug("deleted a fetched debt")
    }
    
    
    func fetchData() async throws {
        try await fetchUsers()
        try await fetchDebts()
    }
    
    func fetchUsers() async throws {
        Logger.debug("fetching users...")
        
        let urlString = Constants.baseURL + Endpoints.users
        
        guard let url = URL(string: urlString) else {
            Logger.error("invalid url: \(urlString)")
            throw HttpError.badURL
        }
        
        let usersResponse: [User] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.users = usersResponse.filter { user in
                user.id != self.transaction.payer!.id
            }
            self.selectedDebtor = self.users.first
            Logger.debug("successfuly fetched users.")
        }
    }
    
    func fetchDebts() async throws {
        Logger.debug("fetching debts...")
        
        let urlString = Constants.baseURL + Endpoints.indebtednesses + self.transaction.id!.uuidString
        
        guard let url = URL(string: urlString) else {
            Logger.error("invalid url: \(urlString)")
            throw HttpError.badURL
        }
        
        let IndebtednessesResponse: [Indebtedness] = try await HttpClient.shared.fetch(url: url)
        
        DispatchQueue.main.async {
            self.debts = IndebtednessesResponse
            Logger.debug("successfuly fetched debts.")
        }
    }
    
}
