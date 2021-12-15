//
//  Shop.swift
//  InspoQuotes
//
//  Created by idStorm on 15.12.2021.
//

import Foundation
import StoreKit

protocol IShopMessages {
    func purchaiseError(title: String, msg: String)
    func purchaiseComplete()
}

class Shop: NSObject, SKPaymentTransactionObserver {
    
    var delegate: IShopMessages?
    
    var isPurchaised: Bool {
        let purchaised = UserDefaults.standard.bool(forKey: Quotes.productID)
        if purchaised {
            accessToPremium()
        }
        return purchaised
    }
    
    func launchService() {
        SKPaymentQueue.default().add(self)
    }
    
    func buyPremiumQuotes() {
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = Quotes.productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            delegate?.purchaiseError(title: "Error", msg: "You are not authorized to make in-app purchases")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                accessToPremium()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .failed:
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                    delegate?.purchaiseError(title: "Something wrong", msg: errorDescription)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                
            case .purchasing:
                continue
                
            case .deferred:
                continue
                
            @unknown default:
                continue
            }
        }
    }
    
    func restorePurchaise() {
        
    }
    
    func accessToPremium() {
        UserDefaults.standard.set(true, forKey: Quotes.productID)
        Quotes.setPremium()
        delegate?.purchaiseComplete()
    }
}
