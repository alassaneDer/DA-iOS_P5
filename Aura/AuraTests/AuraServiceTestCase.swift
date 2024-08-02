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
        let exp = expectation(description: "waiting...")
        // When
        auraService.login(username: username, password: password) { result in
            // Then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as AuthenticationError, .custom(errorMessage: "No data"))
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testAuraShouldPostFailedCallbackIfNoData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        auraService.login(username: username, password: password) { result in
            // Then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as AuthenticationError, .custom(errorMessage: "No data"))
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testAuraShouldPostFailedCallbackIfIncorrectResponse() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.loginCorrectData, response: FakeResponseData.responseKo, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        auraService.login(username: username, password: password) { result in
            // Then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as AuthenticationError, .custom(errorMessage: "HTTP response invalid"))
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testAuraShouldPostFailedCallbackIfIncorrectData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.IncorrectData, response: FakeResponseData.responseOk, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        auraService.login(username: username, password: password) { result in
            // Then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as AuthenticationError, .invalidCredentials)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testAuraShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.loginCorrectData, response: FakeResponseData.responseOk, error: nil),
            allAccountSession: URLSessionFake(data: nil, response: nil, error: nil),
            transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))

        let exp = expectation(description: "waiting...")
        let fakeToken = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        // When
        auraService.login(username: username, password: password) { result in
            // Then
            guard case let .success(token) = result else {
                XCTFail("Expected success case")
                return
            }
            XCTAssertEqual(token, fakeToken)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    // MARK: Account
    func testGetAllAccountShouldPostFailedCallbackIfError() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token: String = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .noData)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testGetAllAccountShouldPostFailedCallbackIfNoData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token: String = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .noData)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testGetAllAccountShouldPostFailedCallbackIfIncorrectResponse() {
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: FakeResponseData.accountCorrectData, response: FakeResponseData.responseKo, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token: String = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .invalidResponse)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testGetAllAccountShouldPostFailedCallbackIfIncorrectData() {
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: FakeResponseData.IncorrectData, response: FakeResponseData.responseOk, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .decodingError)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }

    func testGetAllAccountShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        // Given
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: FakeResponseData.accountCorrectData, response: FakeResponseData.responseOk, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        // When
        let token = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        let currentBalance = "5459.32"
        
        auraService.getAllAccounts(token: token) { result in
            guard case let .success(accountDetails) = result else {
                return
            }
            XCTAssertEqual(accountDetails.currentBalanceString, currentBalance)
        }
}
    
    // MARK: TransfertMoney
    
    func testTrabnsfertMoneyShouldPostFailedCallbackIfError() {
        //Given
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: FakeResponseData.error))
        let exp = expectation(description: "waiting...")
        
        //When
        let token = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.transfertMoney(token: token) { result in
            // Then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .noData)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testTrafertMoneyShouldPostFailedCallbackIfNoData() {
        // Gvien
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token: String = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .noData)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testTransfertMoneyShouldPostFailedCallbackIfIncorrectResponse() {
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: FakeResponseData.accountCorrectData, response: FakeResponseData.responseKo, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token: String = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .invalidResponse)
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    func testTransfertMoneyShouldPostFailedCallbackIfIncorrectData() {
        let auraService = AuraService(loginSession: URLSessionFake(data: nil, response: nil, error: nil),
                                      allAccountSession: URLSessionFake(data: FakeResponseData.IncorrectData, response: FakeResponseData.responseOk, error: nil),
                                      transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let exp = expectation(description: "waiting...")
        // When
        let token: String = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        auraService.getAllAccounts(token: token) { result in
            // then
            guard case let .failure(error) = result else {
                XCTFail("Expected failure case")
                return
            }
            XCTAssertEqual(error as NetworkError, .decodingError)
            exp.fulfill()
        }
        wait(for: [exp], timeout: 0.1)
    }
    
    
    func testTransfertMoneyShouldPostSuccessCallbackIfNoErrorAndCorrectData() {
        
    }
    // MARK: viewmodel
    
    func test() {
        // Given
        let auraService = AuraService(loginSession: URLSessionFake(data: FakeResponseData.loginCorrectData, response: FakeResponseData.responseOk, error: nil), allAccountSession: URLSessionFake(data: nil, response: nil, error: nil), transfertMoneySession: URLSessionFake(data: nil, response: nil, error: nil))
        let fakeToken = "93D2C537-FA4A-448C-90A9-6058CF26DB29"
        // when
        auraService.login(username: username, password: password) { result in
            guard case let .success(token) = result else {
                return
            }
            XCTAssertEqual(token, fakeToken)
        }
    }
}
