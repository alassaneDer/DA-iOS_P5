//
//  AuraServices.swift
//  Aura
//
//  Created by Alassane Der on 09/06/2024.
//


import Foundation

// erreur au niveau de la func Login
enum AuthenticationError: Error, Equatable {
    case invalidCredentials
    case custom(errorMessage: String)
}

// erreur au niveau de la func getAllAccount
enum NetworkError : Error {
    case invalidURL
    case noData
    case decodingError
    case invalidResponse
}

// pour me faciliter la création du body
struct LoginRequestBody: Codable {
    let username: String
    let password: String
}

// login response body : because my response in the server.js has the sames
struct LoginResponse: Decodable {
    let token: String?
}

// getting all account
struct Account: Codable {
    let currentBalanceString: String
    let transactions: [AccountTransaction]
    
    enum CodingKeys: String, CodingKey {
        case currentBalanceString = "currentBalance"
        case transactions
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let currentBalance = try values.decode(Double.self, forKey: .currentBalanceString)
        currentBalanceString = String(format: "%0.2f", currentBalance)
        self.transactions = try values.decode([AccountTransaction].self, forKey: .transactions)
    }
}
struct AccountTransaction: Codable {
    let label: String
    let valueString: String

    enum CodingKeys: String, CodingKey {
        case label
        case valueString = "value"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.label = try values.decode(String.self, forKey: .label)
        let value = try values.decode(Double.self, forKey: .valueString)
        valueString = "\(String(format: "%0.2f", value))€"
    }
    
}

class AuraService {
    static var shared = AuraService()
    private init() {}
    
    private var task : URLSessionDataTask?
    private var loginSession = URLSession(configuration: .default)
    private var allAccountSession = URLSession(configuration: .default)
    private var transfertMoneySession = URLSession(configuration: .default)

    init(loginSession: URLSession, allAccountSession: URLSession, transfertMoneySession: URLSession) {
        self.loginSession = loginSession
        self.allAccountSession = allAccountSession
        self.transfertMoneySession = transfertMoneySession
    }
    
    //MARK: func pour s'authentifier
    func login (username: String, password: String, completionHandler: @escaping (Result<String, AuthenticationError>) -> Void) {
        // get the URL
        guard let authenticationUrl = URL(string: "http://127.0.0.1:8080/auth") else {
            completionHandler(.failure(.custom(errorMessage: "The URL is not correct")))
            return
        }
        
        let body = LoginRequestBody(username: username, password: password)
        
        // the request now
        var request = URLRequest(url: authenticationUrl)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(body)
        
        // perform the request
        task = loginSession.dataTask(with: request) { data, response, error in
            // extract out the datas
            guard let data = data, error == nil else {
                completionHandler(.failure(.custom(errorMessage: "No data")))
                return
            }
            // response
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completionHandler(.failure(.custom(errorMessage: "HTTP response invalid")))
                return
            }
            
            // decode our response
            guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
               completionHandler(.failure(.invalidCredentials))
                return
            }
            
            // get the token out
            guard let token = loginResponse.token else {
                completionHandler(.failure(.invalidCredentials))
                return
            }
            
            completionHandler(.success(token))
            
            
        }
        task?.resume()
    }
    
    // MARK: func for account
    func getAllAccounts(token: String, completion: @escaping (Result<Account, NetworkError>) -> Void) {
        
        guard let url = URL(string: "http://127.0.0.1:8080/account") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(token, forHTTPHeaderField: "Token")
        task = allAccountSession.dataTask(with: request) { data, response, error in
            
            guard let data = data, error == nil else {
                completion(.failure(.noData))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let accounts = try? JSONDecoder().decode(Account.self, from: data) else {
                print("DEBUG: fail to decode")
                completion(.failure(.decodingError))
                return
            }
            
            completion(.success(accounts))
        }
        task?.resume()
        
    }
    
    // MARK: func for transfert
    func transfertMoney(token: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:8080/account/transfer") else {
            completion(.failure(.invalidURL))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "Post"
        request.addValue(token, forHTTPHeaderField: "Token")
        task = transfertMoneySession.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(.noData))
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            completion(.success(()))
        }
        task?.resume()
        
    }
}
