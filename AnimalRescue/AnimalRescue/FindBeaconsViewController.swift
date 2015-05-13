//
//  FindBeaconsViewController.swift
//  AnimalRescue
//
//  Created by Rodrigo Franzoi Scroferneker on 13/05/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import Foundation
import UIKit
import Parse


class FindBeaconsViewController: UIViewController, CLLocationManagerDelegate {
    
    var window: UIWindow?
    var locationManager: CLLocationManager?
    var lastProximity: CLProximity?
    var reg: CLBeaconRegion?
    @IBOutlet weak var button: UIButton!
    
    @IBOutlet weak var searchLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("blablabla")
        self.button.hidden = true
        let uuidString = "1A8D83AD-44EC-42F9-A5A9-989B2477D800"
        let beaconIdentifier = "beacon.identifier"
        let beaconUUID:NSUUID = NSUUID(UUIDString: uuidString)!
        let beaconRegion:CLBeaconRegion = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)

        self.reg = CLBeaconRegion(proximityUUID: beaconUUID,
            identifier: beaconIdentifier)
        
        locationManager = CLLocationManager()
        
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization()
        }
        
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        
        locationManager!.startMonitoringForRegion(beaconRegion)
        locationManager!.startRangingBeaconsInRegion(beaconRegion)
        locationManager!.startUpdatingLocation()

        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func locationManager(manager: CLLocationManager!,
        didRangeBeacons beacons: [AnyObject]!,
        inRegion region: CLBeaconRegion!) {
            
            NSLog("didRangeBeacons");
            
            
            
            if(beacons.count > 0) {
                let nearestBeacon:CLBeacon = beacons[0] as! CLBeacon
                
                if(nearestBeacon.proximity == lastProximity ||
                    nearestBeacon.proximity == CLProximity.Unknown) {
                        return;
                }
                lastProximity = nearestBeacon.proximity;
                
                switch nearestBeacon.proximity {
                case CLProximity.Far:
                    locationManager!.stopRangingBeaconsInRegion(self.reg)
                    alert()
                    self.button.hidden = false
                    manager.stopUpdatingLocation()
                    self.searchLabel.text = "Chave encontrada!"
                    
                    var keys = PFUser.currentUser()?.objectForKey("keys") as! NSInteger + 10
                
                    PFUser.currentUser()?.setValue(keys, forKey: "keys")
                    PFUser.currentUser()?.saveEventually()
                    
                case CLProximity.Near:
                    locationManager!.stopRangingBeaconsInRegion(self.reg)
                    alert()
                    self.button.hidden = false
                    manager.stopUpdatingLocation()
                    self.searchLabel.text = "Chave encontrada!"
                    
                    var keys = PFUser.currentUser()?.objectForKey("keys") as! NSInteger + 10
                    
                    PFUser.currentUser()?.setValue(keys, forKey: "keys")
                    PFUser.currentUser()?.saveEventually()
                case CLProximity.Immediate:
                    locationManager!.stopRangingBeaconsInRegion(self.reg)
                    manager.stopUpdatingLocation()
                    alert()
                    self.button.hidden = false
                    self.searchLabel.text = "Chave encontrada!"
                    
                    var keys = PFUser.currentUser()?.objectForKey("keys") as! NSInteger + 10
                
                    PFUser.currentUser()?.setValue(keys, forKey: "keys")
                    PFUser.currentUser()?.saveEventually()
                case CLProximity.Unknown:
                    println("unk")
                    return
                }
            } else {
                
                if(lastProximity == CLProximity.Unknown) {
                    return;
                }
                
                println("No beacons are nearby")
                
                lastProximity = CLProximity.Unknown
            }
            
            
    }
    
    func locationManager(manager: CLLocationManager!,
        didEnterRegion region: CLRegion!) {
            manager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.startUpdatingLocation()
            
            NSLog("You entered the region")
    }
    
    func locationManager(manager: CLLocationManager!,
        didExitRegion region: CLRegion!) {
            manager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
            manager.stopUpdatingLocation()
            
            NSLog("You exited the region")
    }
    
    
    @IBAction func buttonAction(sender: AnyObject) {
        
        self.button.hidden = true
        locationManager!.startMonitoringForRegion(self.reg)
        locationManager!.startRangingBeaconsInRegion(self.reg)
        locationManager!.startUpdatingLocation()
        self.searchLabel.text = "Procurando chaves..."
        
        
    }

    
    func alert(){
        
        var alert = UIAlertController(title: "Achei!", message: "Voce achou um tesouro!", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Resgatar 10 chaves.", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil) //alerta para o usuário
        
    }

    
}

