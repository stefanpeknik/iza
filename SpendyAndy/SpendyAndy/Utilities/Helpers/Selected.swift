//
//  SelectedUser.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import Foundation

class Selected: ObservableObject {
    @Published var user: User? = nil
    var isSelected: Bool {
        return user != nil
    }
}
