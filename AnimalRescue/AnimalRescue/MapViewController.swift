
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
    var localizaçao: CLLocationCoordinate2D!
    
    
    @IBOutlet weak var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        generatePins()

        
        
    }
    
    func retrieveAnimalsFromParse(){
    
    }
    
    func generatePins()
    {
        mapView.showsUserLocation = true

        var point = MKPointAnnotation();
        point.coordinate = CLLocationCoordinate2DMake(-30.055548895017466, -51.1751056972908)
        point.title = "Animal Aprisionado"
        point.subtitle = "Um animal precisa de sua ajuda!"
        
        mapView.addAnnotation(point)
        mapView.showAnnotations([point], animated: true)
        
        if(updateDistanceAnnotation(point))
        {
            var localNotification: UILocalNotification = UILocalNotification()
            localNotification.alertAction = "Testing notifications on iOS8"
            localNotification.alertBody = "Woww it works!!"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 2)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)

        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse  {
            
            mapView.showsUserLocation = true
            
            if let location = locationManager.location?.coordinate {
                mapView.setCenterCoordinate(location, animated: true)
                mapView.camera.altitude = pow(2, 11)
               
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
    
        func updateDistanceAnnotation(annotation: MKAnnotation!) -> (Bool)
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
    
}
