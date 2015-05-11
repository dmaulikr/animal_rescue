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
    
    // MARK: - Variables
    
    var id:NSNumber
    var name:NSString
    var shortDescription:NSString
    var image:UIImage
    var position:(lat:Double, long:Double)
    
    
    // MARK: - Init
    init(animalId:NSNumber, name:NSString, shortDescription:NSString, image:UIImage, position:(lat: Double, long:Double)) {
        self.id = animalId
        self.name = name
        self.shortDescription = shortDescription
        self.image = image
        self.position.lat = position.lat
        self.position.long = position.long
    }
    
    
    // MARK: - Data From Parse
    class func retrieveAllAnimals (callback:([Animal]) ->()) {
        var query = PFQuery(className:"Animal_Data")
        var basicQuery = PFQuery(className: "Animal_Basics")
        
        query.findObjectsInBackgroundWithBlock { (animals:[AnyObject]?, error:NSError?) -> Void in
            
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), { () -> Void in
                if error == nil {
                    var dataAnimals:[Animal] = []
                    
                    for allData in animals! {
                        basicQuery.whereKey("animalID", equalTo: allData.objectForKey("animalID")!)
                        var basicData = basicQuery.getFirstObject()
                        var position = allData.objectForKey("position") as! PFGeoPoint
                        
                        var img = basicData?.objectForKey("image") as! PFFile
                        
                        
                        var animal = Animal(animalId: basicData?.objectForKey("animalID") as! NSNumber, name: basicData?.objectForKey("name") as! NSString, shortDescription: basicData?.objectForKey("shortDescription") as! NSString, image: UIImage(data: img.getData()!)!, position: (lat: position.latitude, long: position.longitude))
                        dataAnimals.append(animal)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        callback(dataAnimals)
                    })
                } else {
                    print("error = \(error!) \(error!.userInfo!)")
                }
            })
        }
    }
    
    
    
    class func retrieveAnimalById(animalID:NSNumber, callback:(Animal?) ->()) {
        var query = PFQuery(className:"Animal_Basics")
        query.whereKey("animalID", equalTo: animalID)
        query.getFirstObjectInBackgroundWithBlock { (animalObject:PFObject?, error:NSError?) -> Void in
            if error == nil {
                var animal = Animal(animalId: animalObject?.objectForKey("animalID") as! NSNumber, name: animalObject?.objectForKey("name") as! String, shortDescription: animalObject?.objectForKey("shortDescription") as! String, image: UIImage(), position: (12.3,123.3))
                
                callback(animal)
            } else {
                print("error = \(error!) \(error!.userInfo!)")
            }
        }
    }    
    
//    class func retrieveAnimalByPosition(position:(lat:Double, long:Double)) {
//        var animalsDataQuery = PFQuery(className: "Animal_Data")
//        animalsDataQuery.whereKey("animalID", equalTo: animalID)
//        animalsDataQuery.findObjectsInBackgroundWithBlock {
//            
//            (animalsData: [AnyObject]?, error:NSError?)-> Void in
//            if error == nil {
//                if let animals = animalsData as? [PFObject] {
//                    for animalData in animals {
//                        
//                    }
//                }
//            } else {
//                print("error = \(error!) \(error!.userInfo!)")
//            }
//        }
//    }
    
}
