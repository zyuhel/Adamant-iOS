//
//  ApiService.swift
//  Adamant
//
//  Created by Anokhov Pavel on 05.01.2018.
//  Copyright © 2018 Adamant. All rights reserved.
//

import Foundation

enum ApiServiceResult<T> {
	case success(T)
	case failure(ApiServiceError)
}

enum ApiServiceError: Error {
	case notLogged
	case accountNotFound
	case serverError(error: String)
	case internalError(message: String, error: Error?)
	case networkError(error: Error)
	
	var localized: String {
		switch self {
		case .notLogged:
			return String.adamantLocalized.sharedErrors.userNotLogged
			
		case .accountNotFound:
			return String.adamantLocalized.sharedErrors.accountNotFound
			
		case .serverError(let error):
			return String.adamantLocalized.sharedErrors.remoteServerError(message: error)
			
		case .internalError(let msg, let error):
			let message: String
			if let apiError = error as? ApiServiceError {
				message = apiError.localized
			} else if let error = error {
				message = error.localizedDescription
			} else {
				message = msg
			}
			
			return
				String.adamantLocalized.sharedErrors.internalError(message: message)
			
		case .networkError(error: _):
			return String.adamantLocalized.sharedErrors.networkError
		}
	}
}

protocol ApiService: class {
	
	/// Default is async queue with .utilities priority.
	var defaultResponseDispatchQueue: DispatchQueue { get }
    
    // MARK: - Servers list
	
	/// Current node
	var node: Node? { get }
	
	/// Request new node from source
	func refreshNode()
	
	// MARK: - Peers
	
	func getNodeVersion(url: URL, completion: @escaping (ApiServiceResult<NodeVersion>) -> Void)
	
	
	// MARK: - Accounts
	
	func newAccount(byPublicKey publicKey: String, completion: @escaping (ApiServiceResult<Account>) -> Void)
	func getAccount(byPassphrase passphrase: String, completion: @escaping (ApiServiceResult<Account>) -> Void)
	func getAccount(byPublicKey publicKey: String, completion: @escaping (ApiServiceResult<Account>) -> Void)
	func getAccount(byAddress address: String, completion: @escaping (ApiServiceResult<Account>) -> Void)
	
	
	// MARK: - Keys
	
	func getPublicKey(byAddress address: String, completion: @escaping (ApiServiceResult<String>) -> Void)
	
	
	// MARK: - Transactions
	
	func getTransaction(id: UInt64, completion: @escaping (ApiServiceResult<Transaction>) -> Void)
	func getTransactions(forAccount: String, type: TransactionType, fromHeight: Int64?, offset: Int?, limit: Int?, completion: @escaping (ApiServiceResult<[Transaction]>) -> Void)
	
	
	// MARK: - Funds
	
	func transferFunds(sender: String, recipient: String, amount: Decimal, keypair: Keypair, completion: @escaping (ApiServiceResult<Bool>) -> Void)
	
	
	// MARK: - States
	
	/// - Returns: Transaction ID
	func store(key: String, value: String, type: StateType, sender: String, keypair: Keypair, completion: @escaping (ApiServiceResult<UInt64>) -> Void)
	func get(key: String, sender: String, completion: @escaping (ApiServiceResult<String?>) -> Void)
	
	// MARK: - Chats
	
	/// Get chat transactions (type 8)
	///
	/// - Parameters:
	///   - address: Transactions for specified account
	///   - height: From this height. Minimal value is 1.
	func getMessageTransactions(address: String, height: Int64?, offset: Int?, completion: @escaping (ApiServiceResult<[Transaction]>) -> Void)
	
	/// Send text message
	///   - completion: Contains processed transactionId, if success, or AdamantError, if fails.
	func sendMessage(senderId: String, recipientId: String, keypair: Keypair, message: String, type: ChatType, nonce: String, completion: @escaping (ApiServiceResult<UInt64>) -> Void)
}
