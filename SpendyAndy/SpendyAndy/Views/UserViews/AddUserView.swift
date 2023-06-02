//
//  AddUserView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import SwiftUI

struct AddUserView: View {
    @ObservedObject var viewModel: AddUserViewModel
    @Environment(\.presentationMode) var presentationMode
        
    var body: some View {
        VStack {
            Text("Name:").font(.title2).padding()
            TextField("Name", text: $viewModel.name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            VStack {
                Text("Username:").font(.title2).padding()
                TextField("Username", text: $viewModel.username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
                    
                if viewModel.usernameTaken {
                    Text("Username was already taken")
                        .foregroundColor(.red)
                }
            }
            
            Button(action: {
                Task {
                    if (try await viewModel.addUser()) {
                        Logger.debug("dismiss Add User sheet")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("Add User")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
        }
        .navigationBarTitle("Add User", displayMode: .inline)
    }
}

struct AddUserView_Previews: PreviewProvider {
    static var previews: some View {
        AddUserView(viewModel: AddUserViewModel())
    }
}

