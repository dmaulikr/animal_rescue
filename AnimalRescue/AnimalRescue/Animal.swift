//
//  AnimalModel.swift
//  AnimalRescue
//
//  Created by Wagner Santos on 5/7/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Animal: NSObject {
    
    let id:NSNumber
    let name:NSString
    let shortDescription:NSString
    let image:UIImage
    let position:(lat:Double, long:Double)

    init(animalId:NSNumber, name:NSString, shortDescription:NSString, image:UIImage, position:(lat: Double, long:Double)) {
        
        //retrive data from parse
        
        
        self.id = animalId
        self.name = name
        self.shortDescription = shortDescription
        self.image = image
        self.position.lat = position.lat
        self.position.long = position.long
    }
    
    class func retrieveAnimalById(animalID:NSNumber){
        
        var query = PFQuery(className:"Animal_Basics")
        query.whereKey("animalID", equalTo: animalID)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error:NSError?)-> Void in
            
            if error == nil {
                print("animal count = \(objects!.count)")
                
                if let animal = objects as? [PFObject] {
                    print(" animal = \(animal)")
                }
            } else {
                print("error = \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    class func retrieveAnimalByPosition(position:(lat:Double, long:Double)) {
        // retrive from parse
       }
}

