//
//  SpendyAndyApp.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 21.05.2023.
//

import SwiftUI

@main
struct SpendyAndyApp: App {
    @ObservedObject var selected: Selected = Selected()
    
    var body: some Scene {
        WindowGroup {
            FirstView()
                .environmentObject(selected)
        }
    }
}
