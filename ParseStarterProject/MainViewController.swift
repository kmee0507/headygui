//
//  MainViewController.swift
//  Heady Dropper
//
//  Created by Jackson Fiore on 11/4/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import Parse
import QuartzCore
import CoreLocation

class MainViewController: UITableViewController{
    
    // MARK: Properties
    let currentUser = PFUser.currentUser()
    
    var objectIdArray: [String] = []
    var storeArray: [String] = []
    var addressArray: [String] = []
    var cityArray: [String] = []
    var deliveryArray: [String] = []
    var hoursArray: [String] = []
    var imageArray: [String] = []
    var urlArray: [String] = []
    var distanceArray: [Double] = []
    var geopointArray: [PFGeoPoint] = []
    
    var userGeoPoint = PFGeoPoint()
    var store = ""
    var city = ""
    var distance = 0.0
    
    var imageURL = ""
  
    
    //layer for gradient background
    let gradientLayer = CAGradientLayer()
    
    //this function will display an alert to the user when called
    func displayAlert(title:String, message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction((UIAlertAction(title: "OK", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        })))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    //hides toolbar on this screen but shows it on store screen
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    
    //this is where the magic happens
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //gets user's current location
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (userGeoPoint: PFGeoPoint?, error: NSError?) -> Void in
            //if no error, saves current location to user table in database
            if error == nil {
                
                //saves/updates user's current location in parse database
                self.currentUser?["currentLocation"] = userGeoPoint! as PFGeoPoint
                self.currentUser?.saveInBackground()
                
                let query = PFQuery(className:"Store")
                // Interested in locations near user, sorts by distance automatically
                query.whereKey("storeLocation", nearGeoPoint:userGeoPoint!)
                // Limit what could be a lot of points.
                query.limit = 2
                
                //runs query and retrieves an array of PFObjects
                query.findObjectsInBackgroundWithBlock {
                    (storeList, error) -> Void in
                    if error == nil {
                        // The find succeeded without error.
                        
                        // for debug:
                        print("Successful query for locations")
                        print(storeList!)

                        
                        //retrieves store name values from PFObject array and appends to array of store names
                        for store in storeList! {
                            let storeName = store["storeName"] as! String
                            self.storeArray.append(storeName)
                        }
                        // retrieves address name values from PFObject array and appends to array of store addresses
                        
                        for address in storeList! {
                            let storeAddress = address["storeAddress"] as! String
                            self.addressArray.append(storeAddress)
                        }
                        
                        // retrieves city name values from PFObject array and appends to array of city names
                        for city in storeList! {
                            let storeCity = city["storeCity"] as! String
                            self.cityArray.append(storeCity)
                        }
                        
                        // retrieves image URL values from PFObject array and appends to array of image URLS
                        for image in storeList! {
                            let storeImage = image["storeImage"] as! String
                            self.imageArray.append(storeImage)
                        }
                        // retrieves URL values from PFObject array and appends to array of URLs
                        for url in storeList! {
                            let storeURL = url["storeURL"] as! String
                            self.urlArray.append(storeURL)
                        }
                        // retrieves delivery day values from PFObject array and appends to array of delivery times
                        for delivery in storeList! {
                            let storeDelivery = delivery["storeDelivery"] as! String
                            self.deliveryArray.append(storeDelivery)
                        }
                        // retrieves store hour values from PFObject array and appends to array of store hours
                        for hours in storeList! {
                            let storeHours = hours["storeHours"] as! String
                            self.hoursArray.append(storeHours)
                        }
                        
                        //retrieves distance from PFObject array and calculates distance in miles between store and user geopoints
                        for location in storeList! {
                            let storeGeoPoint = location["storeLocation"]
                            let storeDistance = userGeoPoint?.distanceInMilesTo(storeGeoPoint as? PFGeoPoint)
                            //rounds double to one decimal place
                            let storeDistRounded = Double(round(10*storeDistance!)/10)
                            
                            //appends distance to array
                            self.distanceArray.append(storeDistRounded)
                            //appends geopoint to array
                            self.geopointArray.append((storeGeoPoint as? PFGeoPoint)!)
                        }
                        
                        //loads all data into table view cells
                        self.tableView.reloadData()
                        
                        
                    } else {
                        // if error, print
                        print("Error: \(error)")
                    }
                    
                }
                
            }

        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(storeArray.count) for debug
        return storeArray.count
        
    }
    
    
    //populates the tableview cells
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //name given to custom cell class
        let cellIdentifier = "StoreTableViewCell"
        //define cell as member of custom cell class
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! StoreTableViewCell
        
        //populates cells from arrays
        //let storeId = objectIdArray[indexPath.row]
        store = storeArray[indexPath.row]
        city = cityArray[indexPath.row]
        distance = distanceArray[indexPath.row]
        imageURL = imageArray[indexPath.row]
        
        func load_image(urlString:String) {
            let imgURL: NSURL = NSURL(string: urlString)!
            let request: NSURLRequest = NSURLRequest(URL: imgURL)
            
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithRequest(request){
                (data, response, error) -> Void in
                
                if (error == nil && data != nil)
                {
                    func display_image()
                    {
                        cell.storePhotoImageView.image = UIImage(data: data!)
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), display_image)
                }
                
            }
            
            task.resume()
        }
        
        cell.storeNameLabel.text = store
        cell.storeCityLabel.text = city
        cell.distanceLabel.text = String(distance) + " miles away"
        //cell.storePhotoImageView.image = load_image(imageURL)
        
            //returns the cell to be listed in the tableview
            return cell
        
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let destination = segue.destinationViewController as! StoreViewController
                destination.storeName = storeArray[indexPath.row]
                destination.storeCity = cityArray[indexPath.row]
                destination.distance = distanceArray[indexPath.row]
                destination.storeAddress = addressArray[indexPath.row]
                destination.storeDelivery = deliveryArray[indexPath.row]
                destination.storeHours = hoursArray[indexPath.row]
                destination.storeImage = imageArray[indexPath.row]
                destination.storeURL = urlArray[indexPath.row]
                destination.storeGeoPoint = geopointArray[indexPath.row]
                //destination.userGeoPoint = userGeoPoint as PFGeoPoint!
                
        }
    }
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    
    

    
    
    
    // hides keyboard when user taps outside of keyboard
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
        view.endEditing(true)
        super.touchesBegan(touches, withEvent: event)
    }


}
