//
//  UserHomeView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 30.05.2023.
//

import SwiftUI

struct UserHomeView: View {
    @ObservedObject var viewModel = UserHomeViewModel()
    @EnvironmentObject var selected: Selected

    
    var body: some View {
        VStack {
            Text("Last 5 transactions").font(.title).padding()
            List(viewModel.transactions) { transaction in
                HStack {
                    Text(transaction.toWho).font(.title)
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("$" + String(format: "%.2f", transaction.cost)).font(.title2)
                        Spacer()
                        Text(DateFormatter.localizedString(from: transaction.date, dateStyle: .medium, timeStyle: .short)).font(.footnote)
                    }
                }
            }.navigationTitle("Last 5 transactions")
            
            Spacer()
            if (viewModel.owes > 0)
            {
                HStack {
                    
                    Text("Currenly owes:").font(.title2).padding()
                    Text("$" + String(format: "%.2f", viewModel.owes)).font(.title2).foregroundColor(.red).padding()
                }
            }
                
            Spacer()
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchUsersTransactions(user: selected.user!)
                    try await viewModel.CountDebt(user: selected.user!)
                } catch {
                    Logger.error("\(error)")
                }
            }
        }
    }
}


struct UserHomeView_Previews: PreviewProvider {
    static var previews: some View {
        UserHomeView()
    }
}
