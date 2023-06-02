//
//  IndebtednessesListView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import SwiftUI

struct IndebtednessesListView: View {
    @ObservedObject var viewModel = IndebtednessesListViewModel()

    @EnvironmentObject var selected: Selected

    var body: some View {
        List(viewModel.debts) { debt in
            HStack {
                VStack {
                    Text(debt.transaction?.toWho ?? "Unknown transaction").font(.title2)
                    Text(debt.creditor?.name ?? "Unknown creditor").font(.footnote)
                }
                Spacer()
                VStack {
                    Text("$" + String(format: "%.2f", debt.debt)).font(.title2)
                }
            }
            .swipeActions(edge: .leading) {
                Button {
                    Task {
                        do {
                            try await viewModel.payDebt(debt: debt)
                            try await viewModel.fetchDebts(user: selected.user!)
                        } catch {
                            Logger.error("\(error)")
                        }
                    }
                } label: {
                    Label("Pay Debt", systemImage: "checkmark.circle.fill")
                }
            }.tint(.green)
        }
        .onAppear {
            Task {
                do {
                    try await viewModel.fetchDebts(user: selected.user!)
                } catch {
                    Logger.error("\(error)")
                }
            }
        }
    }
}
