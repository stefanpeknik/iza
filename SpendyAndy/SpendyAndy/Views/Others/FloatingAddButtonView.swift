//
//  FloatingAddButtonView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 31.05.2023.
//

import SwiftUI

struct FloatingAddButtonView: View {
    @Binding var modal: ModalType<Transaction>?
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button(action: {
                    modal = .add
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(16)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.trailing, 16)
                .padding(.bottom, 16)
                .shadow(radius: 4)
            }
        }
    }
}
