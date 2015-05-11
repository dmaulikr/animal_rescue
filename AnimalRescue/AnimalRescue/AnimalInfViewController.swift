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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    
    
    
    var animal: AnimalAnnotation = AnimalAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = animal.an.name as String
        descriptionLabel.text = animal.an.shortDescription as String
        animalImage.image = animal.an.image
        println("\(animal.an.name)")

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func releaseAnimal(sender: AnyObject) {
        
        
    }
    
}
