//
//  SavedAnimalsController.swift
//  AnimalRescue
//
//  Created by Wagner Santos on 5/11/15.
//  Copyright (c) 2015 Christian S. All rights reserved.
//

import UIKit
import Parse

class SavedAnimalsController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    let basicCellIdentifier = "BasicCell"

    
    var animals:[Animal] = [] {
        didSet {
            self.spinner.stopAnimating()
            self.tableView.reloadData()
        }
    }
    
    @IBOutlet var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        var userID = PFUser.currentUser()?.objectId!
        
        Animal.retrieveAnimalByUserId(userID!) {
            (allAnimals) in
            print("retrived animals")
            self.animals = allAnimals
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        if(animals.count == 0) {
            spinner.startAnimating()
        }
    }
    
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 160.0
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.animals.count;
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var id = indexPath.row
        
        Animal.retrieveAnimalById(id) {
            (animalData) in
            print(animalData?.name)
        }
        
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier(basicCellIdentifier) as! BasicCellView
        cell.title.text = animals[indexPath.row].name as String
        cell.subtitle.text = animals[indexPath.row].shortDescription as String
        cell.customImageView.image = animals[indexPath.row].image
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}