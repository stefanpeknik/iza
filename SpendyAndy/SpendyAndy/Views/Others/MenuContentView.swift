//
//  MenuContentView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 30.05.2023.
//

import SwiftUI

struct MenuContentView: View {
    @Binding var activeSpot: ActiveSpot
    @EnvironmentObject var selected: Selected
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Button {
                activeSpot = .home
                Logger.debug("pressed Home button")
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Home", systemImage: "house")
            }
            
            Spacer()
            Spacer()
            
            Button {
                activeSpot = .transactions
                Logger.debug("pressed Transactions button")
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Transactions")
            }
            
            Spacer()
            
            Button {
                activeSpot = .debts
                Logger.debug("pressed Debts button")
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("Debts")
            }
            
            Spacer()
            Spacer()
            
            Button {
                selected.user = nil
                Logger.debug("pressed Switch Users button")
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Switch Users", systemImage: "person.2.fill")
            }
        }
    }
}
