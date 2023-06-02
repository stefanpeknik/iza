//
//  UpdateUserView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import SwiftUI

struct UpdateUserView: View {
    @ObservedObject var viewModel: UpdateUserViewModel
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        VStack {
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                Task {
                    try await viewModel.updateUser()
                    Logger.debug("dismiss Update User sheet")
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Update User")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
            Button(action: {
                Task {
                    try await viewModel.deleteUser()
                    Logger.debug("dismiss Update User sheet")
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Delete User")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle("Update User", displayMode: .inline)
    }
}
