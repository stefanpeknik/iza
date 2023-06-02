//
//  AddTransactionView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import SwiftUI

struct AddTransactionView: View {
    @ObservedObject var viewModel: AddTransactionViewModel

    @EnvironmentObject var selected: Selected
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        
        VStack {
            
            Spacer()
            
            Section {
                VStack {
                    Text("To who:").textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("SpendyAndy subscription", text: $viewModel.toWho).textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                
                Spacer()
                
                VStack {
                    Text("Cost:").padding()
                    TextField("Enter the cost", value: $viewModel.transactionCost, formatter: NumberFormatter())
                    .keyboardType(.decimalPad).textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                }
                
                Spacer()
                
                VStack {
                    Text("Date and time:").padding()
                    DatePicker("Date and Time", selection: $viewModel.dateTime).labelsHidden().padding()
                }
            }
            
            
            
            Spacer()
            
            Button {
                Task {
                    do {
                        try await viewModel.addTransaction()
                        presentationMode.wrappedValue.dismiss()
                    } catch {
                        Logger.error("\(error)")
                    }
                }
            } label: {
                Text("Add Transaction")
            }
        }
    }
}
