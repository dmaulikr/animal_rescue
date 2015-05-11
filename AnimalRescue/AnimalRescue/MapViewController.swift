
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
    
    var animalClicked: AnimalAnnotation = AnimalAnnotation()
    
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
    
    func generatePins() //alterar
    {
        mapView.showsUserLocation = true
        
        Animal.retrieveAllAnimals { (allAnimal) -> () in
            for animal in allAnimal{
                var point = AnimalAnnotation();
                point.coordinate = CLLocationCoordinate2DMake(animal.position.lat, animal.position.long)
                point.title = animal.name as! String
                point.subtitle = animal.shortDescription as! String
                point.an = animal
                println("\(point.an.name)")
                self.points.addObject(point)
                self.mapView.addAnnotation(point)
                
                if(self.updateDistanceAnnotation(point))
                {
                    
                    self.locationManager.delegate = self
                    self.locationManager.requestAlwaysAuthorization()
                
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
        }
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var identifier = "CustomAnnotation"
        
        if !(annotation is AnimalAnnotation) {
            return nil
        }
        

        
        if annotation.isKindOfClass(MKPointAnnotation) {
            var pin = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            
            if pin == nil {
                
                pin = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                pin.image = UIImage(named: "cageBlank")
                pin.centerOffset = CGPointMake(0, -10)
                pin.canShowCallout = true
                
                
                let cpa = annotation as! AnimalAnnotation
                
                println("\(cpa.an.name)")
                pin!.leftCalloutAccessoryView = UIImageView(image: UIImage(named: "\(cpa.an.name).jpg"))

                pin!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
                
                
            } else {
                pin!.annotation = annotation
            }
            
            return pin
        }
        
        return nil
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        
        if control is UIButton {
            
            
            animalClicked = view.annotation as! AnimalAnnotation
            
            performSegueWithIdentifier("goToInf", sender: self)
        }
        
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "goToInf" {
           // var vc = segue.destinationViewControlle as! AnimalInfViewController
           // vc.animalClicked = animalClicked
        }
        
    }
}

