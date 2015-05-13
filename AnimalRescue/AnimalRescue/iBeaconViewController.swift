//
//  iBeaconViewController.swift
//  AnimalRescue
//
//  Created by Christian S. on 12/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import Foundation
import Parse
import UIKit

class iBeaconViewController: UIViewController {
    
    override func viewDidLoad() {
        
    }
    
    @IBAction func getFreeKeysAction(sender: AnyObject) {
        
        var query = PFQuery(className: "_User")
        query.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
        
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                println("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        println(object.objectId)
                        println("Ele ganhou 10 chaves ")
                        object["keys"] = object["keys"] as! NSInteger + 10
                        object.saveEventually()
                        
                        let alert = UIAlertView()
                        alert.title = "Parabéns"
                        alert.message = "VocÊ apoia a liberdade dos animais!"
                        alert.addButtonWithTitle("\\o/")
                        alert.show()
                        
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                } else {
                    println("Usuário não encontrado")
                    let alert = UIAlertView()
                    alert.title = "Erro"
                    alert.message = "Um erro ocorreu"
                    alert.addButtonWithTitle(":(")
                    alert.show()
                }
                
                
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
                
                let alert = UIAlertView()
                alert.title = "Erro"
                alert.message = "Um erro ocorreu"
                alert.addButtonWithTitle(":(")
                alert.show()
            }
        }

        
    }
    
}