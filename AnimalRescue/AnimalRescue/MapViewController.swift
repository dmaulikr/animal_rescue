
//
//  MapViewController.swift
//  AnimalRescue
//
//  Created by Rodrigo Franzoi Scroferneker on 07/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//


import UIKit
import CoreLocation
import MapKit
import Parse


class MapViewController: UIViewController , CLLocationManagerDelegate , MKMapViewDelegate{
    
    
    
    var animals: NSMutableArray!
    var points: NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
   



    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        generatePins()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse  {
            
            mapView.showsUserLocation = true
            
            if let location = locationManager.location?.coordinate {
                mapView.setCenterCoordinate(location, animated: true)
                mapView.camera.altitude = pow(2, 11)
                
                
                for(var i = 0; i<points.count; i++){
                    if(updateDistanceAnnotation(points[i] as! MKPointAnnotation))
                    {
                        
                        locationManager.delegate = self
                        locationManager.requestAlwaysAuthorization()
                        
                        println("potato")
                        var localNotification: UILocalNotification = UILocalNotification()
                        localNotification.alertAction = "Animal Rescue"
                        localNotification.alertBody = "Animal em perigo por perto!!!"
                        localNotification.fireDate = NSDate(timeIntervalSinceNow: 2)
                        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
                        
                        var alert = UIAlertController(title: "Animal por perto", message: "Animal em perigo por perto!", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                        
                    }

                }
            } else {
                locationManager.startUpdatingLocation()
            }
            
        }
    }
    
    
    
    
    
    
    
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        locationManager.stopUpdatingLocation()
        
        if let location = locations.last as? CLLocation {
            mapView.setCenterCoordinate(location.coordinate, animated: true)
            mapView.camera.altitude = pow(2, 11)
        }
    }
    
    func updateDistanceAnnotation(annotation: MKPointAnnotation!) -> (Bool)
    {
        
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
    
    func generatePins() //alterar
    {
        mapView.showsUserLocation = true
        
        Animal.retrieveAllAnimals { ([Animal]) -> () in

        }
        
        
        var point = MKPointAnnotation();
        point.coordinate = CLLocationCoordinate2DMake(-30.055548895017466, -51.1751056972908)
        point.title = "Animal Aprisionado"
        point.subtitle = "Um animal precisa de sua ajuda!"
        points.addObject(point)
        mapView.addAnnotation(point)
        
        var point1 = MKPointAnnotation();
        point1.coordinate = CLLocationCoordinate2DMake(-30.054478, -51.196474)
        point1.title = "Animal Aprisionado"
        point1.subtitle = "Um animal precisa de sua ajuda!"
        
        points.addObject(point)
        mapView.addAnnotation(point)
        
        points.addObject(point1)
        mapView.addAnnotation(point1)
        
        for(var i = 0; i < points.count; i++){
            mapView.showAnnotations([points[i]], animated: true)
        }
        
    }
    
    
    

}

