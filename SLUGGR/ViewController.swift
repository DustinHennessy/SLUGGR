//
//  ViewController.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 7/31/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate {

    
    var locationManager :CLLocationManager!
    var lastLocation :CLLocation!
    var userArray = [Users]()
    @IBOutlet var userTableView :UITableView!
    @IBOutlet var mapView :MKMapView!
    
    
    
    //MARK: - HTTP Request and basic auth

    func getDataFromAPI (){
        println("GDFA Start")

        //creating the request
        let url = NSURL(string: "http://sluggr-api.herokuapp.com/data")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "GET"
        let tempEmail = "a@b.com"
        request.setValue("basic \(tempEmail)", forHTTPHeaderField: "email")
        
        //firing the request
        //let urlConnection = NSURLConnection(request: request, delegate: self)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            println("error: \(error)")
            var err: NSError
            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
            let usersDictArray = jsonResult.objectForKey("users") as! [NSDictionary]
            for userDict in usersDictArray {
                let user = Users()
                user.userFirstName = userDict.objectForKey("first_name") as! String
                user.userLastName = userDict.objectForKey("last_name") as! String
                user.userEmail = userDict.objectForKey("email") as! String
                user.userBio = userDict.objectForKey("bio") as? String
                user.userMorningTime = userDict.objectForKey("morning_time") as? NSDate
                user.userEveningTime = userDict.objectForKey("evening_time") as? NSDate
                user.driverStatus = userDict.objectForKey("driver") as! Bool
                user.userHomeLat = userDict.objectForKey("home_lat") as? Float
                user.userHomeLong = userDict.objectForKey("home_lng") as? Float
                user.userHomeLocale = userDict.objectForKey("home_locale") as? String
                user.userID = userDict.objectForKey("id") as? Int
                user.userPreferences = userDict.objectForKey("preferences") as? String
                user.userWorkLat = userDict.objectForKey("work_lat") as? Float
                user.userWorkLong = userDict.objectForKey("work_lng") as? Float
                user.userWorkLocale = userDict.objectForKey("work_locale") as? String
                user.username = userDict.objectForKey("username") as? String
                
                self.userArray.append(user)
                
            }
            self.userTableView.reloadData()
            self.annotatingUsers()
            println("\(jsonResult)")
        })
        println("GDFA End")

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Prepare For Segue")
    }
    
    //MARK: - Location Monitoring
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        if let uLocations = locations {
            lastLocation = uLocations.last as! CLLocation
        zoomToLocationWithLat(lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)
            locationManager.stopUpdatingLocation()
        }
    }
    func turnOnLocationMonitoring() {
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func prepareLocationMonitoring() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .AuthorizedAlways:
                self.turnOnLocationMonitoring()
            case .AuthorizedWhenInUse:
                self.turnOnLocationMonitoring()
            case .Denied:
                break
            case .NotDetermined:
                print("authorization not determined")
                locationManager.requestAlwaysAuthorization()
                break
            default:
                break
            }
            
        }
        
    }
    
    //MARK: - Map Methods
    
    func zoomToLocationWithLat(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        println("ZTL Start")
        var zoomLocation = CLLocationCoordinate2D()
        zoomLocation.latitude = latitude
        zoomLocation.longitude = longitude
        var viewRegion :MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 50000, 50000)
        var adjustedRegion :MKCoordinateRegion = mapView.regionThatFits(viewRegion)
        mapView.setRegion(adjustedRegion, animated: true)
        println("ZTL End")
    }
    
    //MARK: - Map Annotations
    
    func annotatingUsers() {
        println("AU Start")
        var locs = [MKPointAnnotation]()
        for annot in mapView.annotations {
            if annot is MKPointAnnotation {
                locs.append(annot as! MKPointAnnotation)
            }
        }
        mapView.removeAnnotations(locs)
        
        var pins = [MKPointAnnotation]()
        for user in userArray {
            if (user.userWorkLat != nil && user.userWorkLong != nil) {
                var wpa = MKPointAnnotation()
                wpa.coordinate = CLLocationCoordinate2DMake(Double(user.userWorkLat!), Double(user.userWorkLong!))
                wpa.title = "Work: \(user.userFirstName) \(user.userLastName)"
                println("user first name: \(user.userFirstName)")
                pins.append(wpa)
            }
            if (user.userWorkLong != nil && user.userWorkLat != nil) {
                var hpa = MKPointAnnotation()
                hpa.coordinate = CLLocationCoordinate2DMake(Double(user.userHomeLat!), Double(user.userHomeLong!))
                hpa.title = "Home: \(user.userFirstName) \(user.userLastName)"
                pins.append(hpa)
            }
        }
        println("Count: \(pins.count)")
        mapView.addAnnotations(pins)
        println("AU End")
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if (annotation is MKUserLocation) {
            return nil
        }
        
        let reuseId = "pin"
        var aView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if aView == nil {
            aView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            aView!.canShowCallout = true
        
        } else {
            aView!.annotation = annotation
        }
        return aView
        
    }
    
    
    
    //MARK: - Table View Methods
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell :UserTableViewCell = tableView.dequeueReusableCellWithIdentifier("cell") as! UserTableViewCell
           let currentUser = userArray[indexPath.row]
            cell.nameLabel.text = currentUser.userFirstName
        
        return cell
        
    }
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataFromAPI()
        println("VDL END")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        prepareLocationMonitoring()
        println("VWA END")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

