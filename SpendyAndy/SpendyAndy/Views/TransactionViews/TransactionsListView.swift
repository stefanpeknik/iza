//
//  TransactionsListView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import SwiftUI



struct TransactionsListView: View {
    
    @StateObject var viewModel = TransactionsListViewModel()
    
    @State var isShowingAddTransaction: Bool = false
    @State var isShowingEditDebts: Bool = false
    @State var modal: ModalType<Transaction>? = nil

    @EnvironmentObject var selected: Selected
    
    var body: some View {
        ZStack {
            VStack {
                Text("Transactions").font(.title).padding()
                
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
                    .swipeActions(edge: .trailing) {
                        Button(action: {
                            Logger.debug("swiped Delete a transaction")
                            Task {
                                try await viewModel.deleteTransaction(transaction: transaction)
                            }
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                    .swipeActions(edge: .leading) {
                        Button(action: {
                            Logger.debug("swiped Edit debts to a transaction")
                            Task {
                                modal = .update(transaction)
                            }
                        }) {
                            Label("Debts", systemImage: "dollarsign.circle")
                        }
                        .tint(.green)
                    }
                }
                .onAppear {
                    Task {
                        do {
                            try await viewModel.fetchUsersTransactions(user: selected.user!)
                        } catch {
                            Logger.error("\(error)")
                        }
                    }
                }
                
                Spacer()
            }
            FloatingAddButtonView(modal: $modal)
        }
        .sheet(item: $modal,
               onDismiss: {
                    Task {
                        do {
                            try await viewModel.fetchUsersTransactions(user: selected.user!)
                        } catch {
                            Logger.error("\(error)")
                        }
                    }
                },
               content: { modal in
                    switch modal {
                        case .add:
                            AddTransactionView(viewModel: AddTransactionViewModel(payer: selected.user!))
                        case .update(let transaction):
                            EditDebtsView(viewModel: EditDebtsViewModel(transaction: transaction))
                    }
                }
        )
    }
}
