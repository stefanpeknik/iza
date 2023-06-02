//
//  UserSelectedView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 30.05.2023.
//

import SwiftUI

struct UserSelectedView: View {
    @State private var activeSpot: ActiveSpot = .home
    @State private var isMenuShowing = false
    @EnvironmentObject var selected: Selected
    
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                
                Button {
                    isMenuShowing = true
                    Logger.debug("pressed User Menu button")
                } label: {
                    Label(selected.user?.name ?? "", systemImage: "person.circle")
                }.padding()
            }
            .sheet(isPresented: $isMenuShowing) {
                MenuContentView(activeSpot: $activeSpot)
            }
            
            Spacer()
            
            switch (activeSpot) {
            case .home:
                UserHomeView()
            case .transactions:
                TransactionsListView()
            case .debts:
                IndebtednessesListView()
            }
            
            Spacer()
        }
    }
}
