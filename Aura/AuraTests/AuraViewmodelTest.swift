//
//  AuraViewmodelTest.swift
//  AuraTests
//
//  Created by Alassane Der on 28/07/2024.
//

import XCTest
@testable import Aura
import Combine

class AuraViewmodelTest: XCTestCase {
    
    func test_Auth_fail() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        let viewModel = AuthenticationViewModel(auraService: mockService, {})
        
        viewModel.loginVM()
        
        // Vérifie que le message d'erreur a été défini
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    
    func test_Auth_Success() {
        let mockService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.loginCorrectData, response: FakeResponseData.responseOk, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        var onLoginSucceedCallCount = 0
        
        let viewModel = AuthenticationViewModel(auraService: mockService, { onLoginSucceedCallCount += 1 })
        
        
        viewModel.loginVM()
        
        XCTAssertEqual(onLoginSucceedCallCount, 1)
    }
    
    
    func test_AccountDetail_fail() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        let viewModel = AccountDetailViewModel(auraService: mockService)
        
        viewModel.getAccountVM()
        
        XCTAssert(viewModel.currentBalance.isEmpty)
    }
    
    func test_AccountDetail_success() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: FakeResponseData.accountCorrectData, response: FakeResponseData.responseOk, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        
        let viewModel = AccountDetailViewModel(auraService: mockService)
        
        
        viewModel.getAccountVM()
        
        XCTAssertEqual(viewModel.recentTransactions.count, 3)
    }
    
    func test_Transfert_onPhoneNumberFail() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let viewModel = MoneyTransferViewModel(auraService: mockService)
        
        viewModel.recipient = "06891"
        viewModel.amount = "1"
        viewModel.sendMoneyVM()
        
        XCTAssertEqual(viewModel.transferMessage, "Erreur")
    }

    func test_Transfert_onEmailFail() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let viewModel = MoneyTransferViewModel(auraService: mockService)
        
        viewModel.recipient = "@gmail.com"
        viewModel.amount = "1"
        viewModel.sendMoneyVM()
        
        XCTAssertEqual(viewModel.transferMessage, "Erreur")
    }
    
    func test_Transfert_fail() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        
        let viewModel = MoneyTransferViewModel(auraService: mockService)
        
        viewModel.sendMoneyVM()
        
        XCTAssertEqual(viewModel.transferMessage, "Erreur")
    }
    
    func test_Transfert_onPhoneNumberSuccess() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: Data(), response: FakeResponseData.responseOk, error: nil))
        
        let viewModel = MoneyTransferViewModel(auraService: mockService)
        
        viewModel.recipient = "0689546801"
        viewModel.amount = "1"
        viewModel.sendMoneyVM()
        
        XCTAssertEqual(viewModel.transferMessage, "Transfert succeeded")
    }

    func test_Transfert_onEmailSuccess() {
        let mockService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: Data(), response: FakeResponseData.responseOk, error: nil))
        
        let viewModel = MoneyTransferViewModel(auraService: mockService)
        
        viewModel.recipient = "blabla@gmail.com"
        viewModel.amount = "1"
        viewModel.sendMoneyVM()
        
        XCTAssertEqual(viewModel.transferMessage, "Transfert succeeded")
    }
}
