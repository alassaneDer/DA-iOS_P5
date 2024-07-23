////
////  AccountDetailViewModel.swift
////  Aura
////
////  Created by Vincent Saluzzo on 29/09/2023.
////


import Foundation


class AccountDetailViewModel: ObservableObject {
    
    @Published var currentBalance: String = ""
    @Published var transactions: [AccountTransaction] = []
    @Published var recentTransactions: [AccountTransaction] = []
    
    private let auraService: AuraService
    
    init(auraService: AuraService = AuraService.shared) {
        self.auraService = auraService
    }

    func getAllAccount() {
        // recupère le token : sans lui pas d'autorisation
        let defaults = UserDefaults.standard
        guard let token = defaults.string(forKey: "auraToken") else {
            return
        }
        
        
        // appel de notre func  appel api
        auraService.getAllAccounts(token: token) { (result) in
            switch result {
            case .success(let accountDatas):
                DispatchQueue.main.async {
                    self.currentBalance = accountDatas.currentBalanceString
                    self.transactions = accountDatas.transactions
                    let slice = self.transactions.prefix(3)
                    self.recentTransactions = Array(slice)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
