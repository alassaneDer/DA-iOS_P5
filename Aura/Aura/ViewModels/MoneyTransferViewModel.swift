//
//  MoneyTransferViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class MoneyTransferViewModel: ObservableObject {
    @Published var recipient: String = ""
    @Published var amount: String = ""
    @Published var transferMessage: String = ""
    
    private let auraService: AuraService
    
    init(auraService: AuraService = AuraService.shared) {
        self.auraService = auraService
    }
    
    var isEmailValid: Bool {
        // criteria in regex. see: http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: recipient)
    }
    
    var isFrenchNumber: Bool {
        // criteria in regex. see: http://regexlib.com
        let frenchNumberTest = NSPredicate(format: "SELF MATCHES %@", "^(0|\\+33)[1-9]([-. ]?[0-9]{2}){4}$")
        return frenchNumberTest.evaluate(with: recipient)
    }
    
    var isTransfertCompleted: Bool {
        if isFrenchNumber {
            return true
        } else if isEmailValid {
            return true
        }
        return false
        
    }
    
    func sendMoneyVM() {
        // récupérer le token dans le keychain
        auraService.transfertMoney(token: "") { result in
            switch result {
            case .success:
                if self.isTransfertCompleted && !self.recipient.isEmpty {
                    self.transferMessage = "Transfert succeeded"
                }
            case .failure:
                self.transferMessage = "Erreur"
            }
        }
    }
}
