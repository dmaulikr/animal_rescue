//
//  AnimalInfViewController.swift
//  AnimalRescue
//
//  Created by Rodrigo Franzoi Scroferneker on 11/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreLocation
import MapKit

class AnimalInfViewController: UIViewController, CLLocationManagerDelegate{
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var animalImage: UIImageView!
    var locationManager = CLLocationManager()
    
    
    var animal: AnimalAnnotation = AnimalAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
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
        
        var annotation = MKPointAnnotation()
        annotation.coordinate = animal.coordinate // pega a coordenada do animal selecionado
        
        if(updateDistanceAnnotation(annotation)){ //verifica se o animal selecionado está a menos de 600m
            
            
            
            
            var query = PFQuery(className: "_User")
            query.whereKey("objectId", equalTo: PFUser.currentUser()!.objectId!)
            
            query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    println("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    
                    
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            println(object.objectId)
                            
                            if object["keys"] as! NSInteger >= 1{
                                println("Animal libertado!")
                                object["keys"] = object["keys"] as! NSInteger - 1
                                object.saveEventually()
                                
                                var otherQuery = PFQuery(className: "Animal_Data")
                                otherQuery.whereKey("animalID", equalTo: self.animal.an.id)
                                otherQuery.findObjectsInBackgroundWithBlock {
                                    (objects: [AnyObject]?, error: NSError?) -> Void in
                                    
                                    if error == nil {
                                        // The find succeeded.
                                        println("Successfully retrieved \(objects!.count) scores.")
                                        if let objects = objects as? [PFObject] {
                                            for object in objects {
                                                object["userID"] = PFUser.currentUser()!.objectId!
                                                object.saveEventually()
                                            }
                                        }
                                    } else {
                                        // Log details of the failure
                                        println("Error: \(error!) \(error!.userInfo!)")
                                    }
                                }
                                var alert = UIAlertController(title: "Uhul!", message: "Animal libertado!", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil) //alerta para o usuário
                                
                            } else {
                                var alert = UIAlertController(title: "Ops", message: "Você não possui chaves suficientes.", preferredStyle: UIAlertControllerStyle.Alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                                self.presentViewController(alert, animated: true, completion: nil) //alerta para o usuário
                                println("Você não possui chaves suficientes")
                            }
                        }
                    } else {
                        println("Usuário não encontrado")
                    }
                    
                    
                } else {
                    // Log details of the failure
                    println("Error: \(error!) \(error!.userInfo!)")
                }
            }
        }
        else
        {
            var alert = UIAlertController(title: "Ops", message: "Você não está perto o suficuente do animal.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)//alerta para o usuário
            
            println("Você nao está perto do animal")
        }
    }
    
    func updateDistanceAnnotation(annotation: MKPointAnnotation!) -> (Bool)
    {
        println("entrei")
        if (annotation == nil)
        {
            println("No annotation selected")
            return false
        }
        
        if (locationManager.location == nil)
        {
            println("User location is unknown")
            return false
        }
        
        var pinLocation = CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
        var userLocation = CLLocation(latitude: locationManager.location.coordinate.latitude, longitude: locationManager.location.coordinate.longitude)
        var distance = CLLocationDistance(pinLocation.distanceFromLocation(userLocation))
        
        println("Distance to point \(distance).")
        
        if(distance > 600) {return false}
        else {return true}
        
    }
    
}
