//
//  AccountDetailViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//


import Foundation


class AccountDetailViewModel: ObservableObject {
    
    @Published var currentBalance: String = ""
    @Published var transactions: [AccountTransaction] = []
    @Published var recentTransactions: [AccountTransaction] = []
    @Published var errorMessage: String?
    
    private let auraService: AuraService
    
    init(auraService: AuraService = AuraService.shared) {
        self.auraService = auraService
    }
    
    func getAccountVM() {
        errorMessage = nil
        // recupère le token stocké sur UserDefaults
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "auraToken") else {
            return
        }
        
        auraService.getAllAccounts(token: token) { (result) in
            switch result {
            case .success(let accountDatas):
                self.currentBalance = accountDatas.currentBalanceString
                self.transactions = accountDatas.transactions
                let slice = self.transactions.prefix(3)
                self.recentTransactions = Array(slice)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
