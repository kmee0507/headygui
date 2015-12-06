//
//  StoreViewController.swift
//  Heady Dropper
//
//  Created by Jackson Fiore on 11/5/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import QuartzCore
import Parse
import CoreLocation

class StoreViewController: UIViewController {
    //MARK: Properties
    let currentUser = PFUser.currentUser()
    
    var storeName = String()
    var storeCity = String()
    var distance = Double()
    var storeAddress = String()
    var storeDelivery = String()
    var storeHours = String()
    var storeURL = String()
    var storeImage = String()
    var storeGeoPoint = PFGeoPoint()
    var userDistanceFromStore = 0.0;
    
    //for gradient background
    let gradientLayer = CAGradientLayer()
    
    //this function will display an alert to the user when called
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            //self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var storeCityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var storeImageView: UIImageView!
    
    
    //sets labels to values passed from tableview cell
    override func viewWillAppear(animated: Bool) {
        storeNameLabel.text = storeName
        storeCityLabel.text = storeCity
        distanceLabel.text = String(distance) + " miles away"
        
        
    }
    
    
    @IBAction func btnStatusChange(sender: AnyObject) {
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (userGeoPoint: PFGeoPoint?, error: NSError?) -> Void in
            //if no error, saves current location to user table in database
            if error == nil {
                //do something
            } else {
                //error
            }
            
            self.currentUser?["currentLocation"] = userGeoPoint! as PFGeoPoint
            
            self.userDistanceFromStore = (userGeoPoint?.distanceInMilesTo(self.storeGeoPoint))!
            
            print(self.storeGeoPoint,userGeoPoint,self.userDistanceFromStore)
            
            
            if self.userDistanceFromStore > 0.5 {
                self.displayAlert("Not In Range", message: "You must be within half a mile of this store to submit a status change request.")
            } else {
                
                // submit status info to parse
                
                // update status label/information
                
                
                //debug
                print(self.storeName,self.storeAddress,self.storeCity,self.storeHours,self.storeDelivery,self.storeImage,self.storeURL)
                
                
            }
            
            
        }
        
    }
    

    @IBAction func btnStoreMap(sender: AnyObject) {
        self.performSegueWithIdentifier("mapsegue", sender: self)
        
        
        
    }
    
    
    @IBAction func btnStoreHours(sender: AnyObject) {
        displayAlert("Hours for "+storeName, message: storeHours)
        
        
        
    }

    
    @IBAction func btnStoreWebsite(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string:storeURL)!)
        
    }
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destination = segue.destinationViewController as! MapViewController
        
        destination.storeName = self.storeName
        destination.storeGeoPoint = self.storeGeoPoint
        
        
        /*
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (userGeoPoint: PFGeoPoint?, error: NSError?) -> Void in
            //if no error, saves current location to user table in database
            if error == nil {
                //do something
            } else {
                //error
            }
            
            self.currentUser?["currentLocation"] = userGeoPoint! as PFGeoPoint
            
            destination.userGeoPoint = self.userGeoPoint
        }
        */
        
        
    }
    

}
