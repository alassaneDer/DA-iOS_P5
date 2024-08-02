//
//  AuthenticationViewModel.swift
//  Aura
//
//  Created by Vincent Saluzzo on 29/09/2023.
//

import Foundation

class AuthenticationViewModel: ObservableObject {
    @Published var username: String = "test@aura.app"
    @Published var password: String = "test123"
    @Published var errorMessage: String?
    
    private let auraService: AuraService
    let onLoginSucceed: (() -> ())
    
    init(auraService: AuraService = AuraService.shared, _ callback: @escaping () -> ()) {
        self.auraService = auraService
        self.onLoginSucceed = callback
    }
    
    func loginVM() {
        errorMessage = nil
        let defaults = UserDefaults.standard  // pour stocker token : à changer plutard
        
        auraService.login(username: username, password: password) { result in
            switch result {
            case .success(let token):
                defaults.setValue(token, forKey: "auraToken")   // pour stocker token
                self.onLoginSucceed()
            case .failure(let errorMessage):
                self.errorMessage = errorMessage.localizedDescription
            }
        }
        print("login with \(username) and \(password)")
    }
}
