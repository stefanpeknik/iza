//
//  ModalType.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 28.05.2023.
//

import Foundation

enum ModalType<T>: Identifiable {
    var id: String {
        switch self {
        case .add: return "add"
        case .update: return "update"
        }
    }
    
    case add
    case update(T)
}
