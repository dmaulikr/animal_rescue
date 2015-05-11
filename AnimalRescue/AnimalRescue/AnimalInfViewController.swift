//
//  AnimalInfViewController.swift
//  AnimalRescue
//
//  Created by Rodrigo Franzoi Scroferneker on 11/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import Foundation
import UIKit

class AnimalInfViewController: UIViewController{
    
    var animalClicked: AnimalAnnotation = AnimalAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("\(animalClicked.an.name)")

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
