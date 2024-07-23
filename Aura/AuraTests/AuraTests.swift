//
//  AuraTests.swift
//  AuraTests
//
//  Created by Alassane Der on 16/07/2024.
//

@testable import Aura
import XCTest

class AuraServiceTestCase: XCTestCase {
    
    let username: String = "test@aura.app"
    let password: String = "test123"
    
    // MARK: Login
    func testAuraShouldPostFailedCallbackIfError() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        auraService.login(username: username, password: password) { token in
            // Then
            XCTAssertNil(token)
        }
    }
    
    func testAuraShouldPostFailedCallbackIfNoData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        auraService.login(username: username, password: password) { token in
            // Then
            XCTAssertNil(token)
        }
    }
    
    func testAuraShouldPostFailedCallbackIfIncorrectResponse() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.loginCorrectData, response: FakeResponseData.responseKo, error: FakeResponseData.error), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        auraService.login(username: username, password: password) { token in
            // Then
            XCTAssertNil(token)
        }
    }
    
    func testAuraShouldPostFailedCallbackIfIncorrectData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.IncorrectData, response: FakeResponseData.responseOk, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        auraService.login(username: username, password: password) { token in
            // Then
            XCTAssertNil(token)
        }
    }
    
//    func testAuraShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
//        // Gvien
//        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.auraCorrectData, response: FakeResponseData.responseOk, error: nil),
//            allAccountSession: URLSessionFake(data: FakeResponseData.auraCorrectData, response: FakeResponseData.responseOk, error: nil),
//            transfertMoneySession: URLSessionFake(data: FakeResponseData.auraCorrectData, response: FakeResponseData.responseOk, error: nil))
//
//        let fakeToken = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
//        // When
//        auraService.login(username: username, password: password) { token in
//            // Then
//            XCTAssertNotNil(token)
//            XCTAssertEqual(fakeToken, token)
//        }
//    }
    
    // MARK: Account
    func testGetAllAccountShouldPostFailedCallbackIfError() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let token: String = ""
        auraService.getAllAccounts(token: token) { account in
            // then
            XCTAssertNil(account)
        }
    }
    
    func testGetAllAccountShouldPostFailedCallbackIfNoData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let token: String = ""
        auraService.getAllAccounts(token: token) { account in
            // then
            XCTAssertNil(account)
        }
    }
    
    func testGetAllAccountShouldPostFailedCallbackIfIncorrectResponse() {
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: FakeResponseData.accountCorrectData, response: FakeResponseData.responseKo, error: FakeResponseData.error),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let token: String = ""
        auraService.getAllAccounts(token: token) { account in
            // then
            XCTAssertNil(account)
        }
    }
    
    func testGetAllAccountShouldPostFailedCallbackIfIncorrectData() {
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: FakeResponseData.IncorrectData, response: FakeResponseData.responseOk, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let token: String = ""
        auraService.getAllAccounts(token: token) { account in
            // then
            XCTAssertNil(account)
        }
    }
    
    // Test pour voir si les données recus contiennent bien ce à quoi je m'atttends
    
    // MARK: viewmodel
    
//    func testAuthenticiationFunc() {
//        var viewModel: AuthenticationViewModel
//    }
}
