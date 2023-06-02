//
//  EditDebtsView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import SwiftUI

struct EditDebtsView: View {
    @ObservedObject var viewModel: EditDebtsViewModel
    
    var body: some View {
        VStack {
            if (viewModel.users.isEmpty == false) {
                Section {
                    Spacer()
                    HStack {
                        Picker("Pick Debtor", selection: $viewModel.selectedDebtor) {
                            ForEach($viewModel.users) { user in
                                HStack {
                                    Text(user.wrappedValue.name).font(.title3)
                                    Text(user.wrappedValue.username).font(.footnote)
                                }.tag(user.wrappedValue as User?)
                            }
                        }.padding()
                        TextField("Enter the debt", value: $viewModel.debtCost, formatter: NumberFormatter())
                            .keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        Button {
                            Task {
                                do {
                                    try await viewModel.addDebt()
                                    try await viewModel.fetchDebts()
                                } catch let error as DebtSubmitError {
                                    Logger.error("\(error)")
                                    viewModel.errorMessage = error.localizedDescription
                                } catch {
                                    Logger.error("\(error)")
                                }
                            }
                        } label: {
                            Text("Add Debtor")
                        }.padding()
                    }
                    HStack {
                        Text("Remaining cost:").padding()
                        Spacer()
                        Text(String(format: "$ %.2f", viewModel.remainingCost)).padding()
                    }
                    if (viewModel.errorMessage != nil) {
                        Text(viewModel.errorMessage!).font(.title2).foregroundColor(.red).padding()
                    }
                }
            }
            List(viewModel.debts) { debt in
                HStack {
                    VStack {
                        Text(debt.debtor?.name ?? "Unknown user").font(.title2).padding()
                        Text(debt.debtor?.username ?? "Unknown username").font(.footnote).padding()
                    }
                    Spacer()
                    Text(String(format: "%.2f", debt.debt)).foregroundColor(.red).font(.title3).padding()
                }
                .swipeActions(edge: .trailing) {
                    Button(action: {
                        Logger.debug("swiped Delete a debt")
                        Task {
                            try await viewModel.deleteDebt(debt: debt)
                        }
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }
            .navigationTitle("Debts")
            
            Spacer()
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchData()
                } catch {
                    Logger.error("\(error)")
                }
            }
        }

    }
}
