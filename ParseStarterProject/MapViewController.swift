//
//  MapViewController.swift
//  Heady Dropper
//
//  Created by Jackson Fiore on 12/2/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import UIKit
import MapKit
import Parse

class MapViewController: UIViewController {

    //MARK: Properties
    var storeGeoPoint = PFGeoPoint()
    var storeName = ""
    //var userGeoPoint = PFGeoPoint()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storeLat = storeGeoPoint.latitude as Double
        let storeLong = storeGeoPoint.longitude as Double
        
        let storeLocation = CLLocationCoordinate2D(latitude: storeLat, longitude: storeLong)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(storeLocation, span)
        mapView.setRegion(region, animated: true)
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = storeLocation
        anotation.title = storeName
        anotation.subtitle = storeName
        
        mapView.addAnnotation(anotation)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
