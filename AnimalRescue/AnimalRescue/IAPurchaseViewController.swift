//
//  IAPurchaseViewController.swift
//  AnimalRescue
//
//  Created by Christian S. on 11/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import UIKit
import Foundation
import StoreKit


class IAPurchaseViewController: UIViewController, SKProductsRequestDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let productsRequest = SKProductsRequest(productIdentifiers: ["produto"])
        productsRequest.delegate = self;
        productsRequest.start();
    }
    
    
    func productsRequest(request: SKProductsRequest!, didReceiveResponse response: SKProductsResponse!) {
        println(response) // [SKProduct]
    }
    
    
    @IBAction func BuyButtonPressed(sender: AnyObject) {
        
        
    }
    
    
    
    

}