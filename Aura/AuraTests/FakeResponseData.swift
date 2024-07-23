//
//  FakeResponseData.swift
//  AuraTests
//
//  Created by Alassane Der on 16/07/2024.
//

import Foundation

class FakeResponseData {
    // simule la réponse
    static let responseOk = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 200, httpVersion: nil, headerFields: nil)!
    static let responseKo = HTTPURLResponse(url: URL(string: "https://openclassrooms.com")!, statusCode: 500, httpVersion: nil, headerFields: nil)!
    
    // simule l'erreur
    class AuraError: Error {}
    static let error = AuraError()
    
    // simule les données (json renvoyé par l'api)
    static var loginCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self) //recupérer le bon bundle
        let url = bundle.url(forResource: "FakeLoginDatas", withExtension: "json")    // recupere url
        let data = try! Data(contentsOf: url!)  // recup données
        return data
    }
    
    static var accountCorrectData: Data {
        let bundle = Bundle(for: FakeResponseData.self) //recupérer le bon bundle
        let url = bundle.url(forResource: "FakeAccountDatas", withExtension: "json")    // recupere url
        let data = try! Data(contentsOf: url!)  // recup données
        return data
    }
    
    static var transfertCorrectDatas: Data {
        let bundle = Bundle(for: FakeResponseData.self) //recupérer le bon bundle
        let url = bundle.url(forResource: "FakeTransfertDatas", withExtension: "json")    // recupere url
        let data = try! Data(contentsOf: url!)  // recup données
        return data
    }
    
    // simule json endommagé
    static let IncorrectData = "erreur".data(using: .utf8)!
//    static let secondRequestIncorrectData = "secondRequest".data(using: .utf8)!
}
