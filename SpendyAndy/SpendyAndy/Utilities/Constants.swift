//
//  Constants.swift
//  SpendyAndy
//
//  Created by Štefan Pekník on 27.05.2023.
//

import Foundation

enum Constants {
    static let baseURL = "http://127.0.0.1:8080/" // TODO: should be changed to valid URL when deployed
}

enum Endpoints {
    static let users = "users/"
    static let transactions = "transactions/"
    static let indebtednesses = "indebtednesses/"
    static let debts = "debts/"
    static let credits = "credits/"
}
