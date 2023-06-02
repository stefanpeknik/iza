//
//  ContentView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 21.05.2023.
//

import SwiftUI

struct UsersListView: View {
    @StateObject var viewModel = UsersListViewModel()
    @State var modal: ModalType<User>? = nil
    @EnvironmentObject var selected: Selected
    
    var body: some View {
        NavigationView {
            List(viewModel.users) { user in
                VStack(alignment: .center) {
                    Text(user.name).font(.title3)
                    Text(user.username).font(.footnote)
                }
                .frame(maxWidth: .infinity)
                .edgesIgnoringSafeArea(.all)
                .swipeActions(edge: .leading) {
                    Button(action: {
                        modal = .update(user)
                    }) {
                        Label("Edit", systemImage: "pencil")
                    }
                }.tint(.gray)
                .onTapGesture {
                    Logger.debug("Tapped on a user")
                    selected.user = user
                }
            }
            .navigationTitle("Users")
            .toolbar {
                Spacer()
                
                Button {
                    modal = .add
                    Logger.debug("pressed +Add User button")
                } label: {
                    Label("Add User", systemImage: "plus.circle")
                }
            }
            .onAppear {
                Task {
                    do {
                        try await viewModel.fetchUsers()
                    } catch {
                        Logger.error("\(error)")
                    }
                }
            }
        }
        .sheet(item: $modal,
               onDismiss: {
                    Task {
                        do {
                            try await viewModel.fetchUsers()
                        } catch {
                            Logger.error("\(error)")
                        }
                    }
                },
               content: { modal in
                    switch modal {
                        case .add:
                            AddUserView(viewModel: AddUserViewModel())
                        case .update(let user):
                            UpdateUserView(viewModel: UpdateUserViewModel(selectedUser: user))
                    }
                }
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        UsersListView()
    }
}
