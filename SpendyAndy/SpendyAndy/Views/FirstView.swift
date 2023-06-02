//
//  FirstView.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 30.05.2023.
//

import SwiftUI

struct FirstView: View {
    @StateObject private var viewModel = FirstViewModel()
    @EnvironmentObject var selected: Selected

    var body: some View {
        if selected.isSelected {
            UserSelectedView()
        } else {
            UsersListView()
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
