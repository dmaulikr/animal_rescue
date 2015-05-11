//
//  IAPurchaseViewController.swift
//  AnimalRescue
//
//  Created by Christian S. on 11/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import UIKit
import Foundation
import Parse
import StoreKit


class IAPurchaseViewController: UIViewController, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    var list = [SKProduct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println(PFUser.currentUser())
        
        SKPaymentQueue.defaultQueue().addTransactionObserver(self)
        
        if(SKPaymentQueue.canMakePayments()) {
            println("IAP is enabled, loading")
            var productID:NSSet = NSSet(objects: "com.CRRW.AnimalRescue.Buy10Keys")
            var request: SKProductsRequest = SKProductsRequest(productIdentifiers: productID as Set<NSObject>)
            request.delegate = self
            request.start()
        } else {
            println("please enable IAPS")
            let alert = UIAlertView()
            alert.title = "ERRO"
            alert.message = "Houve um problema ao carregar a compra"
            alert.addButtonWithTitle("Ok")
            alert.show()
            
        }
    }
    
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println(response) // [SKProduct]
    }
    
    
    func paymentQueue(queue: SKPaymentQueue!, updatedTransactions transactions: [AnyObject]!) {
        for transaction:AnyObject in transactions {
            if let trans:SKPaymentTransaction = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
        
                    case .Purchasing:
                        println("Purchasing Product");
                    break
        
                    case .Failed:
                        println("Purchase Failed");
                    break
        
                    case .Restored:
                        println("Product Restored");
                    break
        
                    case .Purchased:
                        println("Product Purchased");
                        SKPaymentQueue.defaultQueue().finishTransaction(transaction as! SKPaymentTransaction)
                    break
        
                    default:
                    break
                };
            }
        }
    }
    
    
    @IBAction func BuyButtonPressed(sender: AnyObject) {
                        
//        ￼if (SKPaymentQueue.canMakePayments()) {
//                let product = response.products[0] as! SKProduct
//                var payment = SKPayment(product: product)
//                SKPaymentQueue.defaultQueue().addPayment(payment);
//        } else {
//            println("Not allowed to buy")
//        }
                            
    }
    
    
    func addCoins (){
            
        var query = PFQuery(className: "user")
        query.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                        
            if error == nil {
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                        
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
//            
//        if (quantKeys >= 1) {
//            println("Animal libertado")
//            user?.objectForKey("keys") = user?.objectForKey("keys") - 1
//            (user["animalsReleased"] as NSArray).append
//        } else {
//            println("você não tem keys suficientes")
//        }
        
        
    }
    
    
    
    

}