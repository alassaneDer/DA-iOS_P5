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
    
    // MARK: validation functions
    func isEmailValid() -> Bool {
        // criteria in regex. see: http://regexlib.com
        let emailTest = NSPredicate(format: "SELF MATCHES %@", "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\\]?)$")
        return emailTest.evaluate(with: recipient)
    }
    func isFrenchNumber() -> Bool {
        // criteria in regex. see: http://regexlib.com
        let frenchNumberTest = NSPredicate(format: "SELF MATCHES %@", "^(0|\\+33)[1-9]([-. ]?[0-9]{2}){4}$")
        return frenchNumberTest.evaluate(with: recipient)
    }
    
    var isTransfertCompleted: Bool {
        if isFrenchNumber() == isEmailValid() {
            return true
        }
        return false
    }
    
    func sendMoney() {
        // Logic to send money - for now, we're just setting a success message.
        // You can later integrate actual logic.
//        if !recipient.isEmpty && !amount.isEmpty {
//            transferMessage = "Successfully transferred \(amount) to \(recipient)"
//        } else {
//            transferMessage = "Please enter recipient and amount."
//        }
//
        // deuxieme condition
//        if !isFrenchNumber() &&
//            !isEmailValid() {
//            transferMessage = "Please enter an email or valid french number"
//        }
        
        auraService.transfertMoney(token: "") { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    if !self.recipient.isEmpty && !self.amount.isEmpty && !self.isTransfertCompleted {
                        self.transferMessage = "Transfert succeeded"
                    } else if !self.isFrenchNumber() &&
                                !self.isEmailValid() {
                        self.transferMessage = "Please enter an email or valid french number"
                    }

    //                self.transferMessage = "Transfert succeeded"
                case .failure:
                    self.transferMessage = "Erreur"
                }
            }
        }
//        // 3em
//        if !isEmailValid() {
//            transferMessage = "Please enter a valid email"
//        }
        
        // MARK: erreur concernant le solde
//        if amount < 0 &&
//        amount > 500 &&
//        amount > AccountDetailViewModel().currentBalance {
//          transfertMessage = "Please enter an autorized recipient."
//        }
    }
}
