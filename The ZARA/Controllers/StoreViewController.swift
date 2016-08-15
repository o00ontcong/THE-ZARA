//
//  StoreViewController.swift
//  The ZARA
//
//  Created by MAC on 15/08/2016.
//  Copyright © 2016 o00ontcong. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation
import GooglePlaces

class StoreViewController: UIViewController,  UISearchBarDelegate, GMSMapViewDelegate,LocateOnTheMap ,CLLocationManagerDelegate{
    
    var items = ["Zara Fashion Outlet",
                 "Shop Thời Trang Nam Zara",
                 "Quynh Zara Shop",
                 "Cát Tường Shop",
                 "Shop ZaraMan",
                 "FA HOUSE",
                 "Katus Store",
                 "YeLi Shop"
    ]
    var address = [
        "72 Lê Thánh Tôn, Bến Nghé, Quận 1, Hồ Chí Minh, Việt Nam",
        "66 Bắc Hải, 6, Tân Bình, Hồ Chí Minh, Việt Nam",
        "22/9, Nguyen Canh Chan Street, Cau Kho Ward, District 1, Cầu Kho, District 1, Ho Chi Minh, Việt Nam",
        "385/6 Nguyễn Đình Chiểu, phường 5, Quận 3, Hồ Chí Minh, Việt Nam",
        "150 Hồ Bá Kiện, Cư xá Bắc Hải, Phường 15, Quận 10, Hồ Chí Minh 700000, Việt Nam",
        "389 Ngô Gia Tự, phường 3, District 10, Ho Chi Minh, Việt Nam",
        "472/2, Cách Mạng Tháng Tám, phường 11, Quận 3, Hồ Chí Minh, Việt Nam",
        "159 Điện Biên Phủ, Đa Kao, Quận 1, Hồ Chí Minh, Việt Nam"
    ]
    var markerStore = [
        CLLocationCoordinate2DMake(10.778240, 106.702039),
        CLLocationCoordinate2DMake(10.786454, 106.663957),
        CLLocationCoordinate2DMake(10.757680, 106.688753),
        CLLocationCoordinate2DMake(10.771318, 106.683642),
        CLLocationCoordinate2DMake(10.782944, 106.666564),
        CLLocationCoordinate2DMake(10.760249, 106.669693),
        CLLocationCoordinate2DMake(10.784641, 106.669191),
        CLLocationCoordinate2DMake(10.788039, 106.695416)
        
        ]
    
    var alertView:DYAlertPickView = DYAlertPickView()
    
    @IBAction func abtnDirection(sender: AnyObject) {
        self.alertView = DYAlertPickView(headerTitle: "Title", cancelButtonTitle: "Cancel", confirmButtonTitle: "OK", switchButtonTitle: nil)
        self.alertView.delegate = self;
        self.alertView.dataSource = self;
        self.alertView.showAndSelectedIndex(0)
    }
    var busShow : Bool = false
    
    @IBOutlet weak var btnStoreShow: UIButton!
    
    @IBAction func abtnStoreShow(sender: AnyObject) {
        if busShow == false {
            busShow = true
            btnStoreShow.setImage(UIImage(named: "StoreON"), forState: .Normal)
            for i in 0...markerStore.count - 1 {
            let marker = GMSMarker(position: markerStore[i])
            marker.title = items[i]
                marker.icon = UIImage(named: "store")?.scaleImage(CGSize(width: 25, height: 25))
            marker.map = viewMap
            }
            
        }
        else {
            viewMap.clear()
            busShow = false
            btnStoreShow.setImage(UIImage(named: "StoreOFF"), forState: .Normal)
        }
    }
    
    @IBAction func abtnSearch(sender: AnyObject) {
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        self.presentViewController(searchController, animated: true, completion: nil)
    }
    
    
    
    var locationManager = CLLocationManager()
    var searchResultController: SearchResultsController!
    var locationMarker: GMSMarker!
    var resultsArray = [String]()
    
    var placesClient: GMSPlacesClient?
    var travelMode = TravelModes.driving
    
    
    @IBOutlet weak var viewMap: GMSMapView!
    var didFindMyLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if busShow == false {
            busShow = true
            btnStoreShow.setImage(UIImage(named: "StoreON"), forState: .Normal)
            for i in 0...markerStore.count - 1 {
                let marker = GMSMarker(position: markerStore[i])
                marker.title = "Hello World"
                marker.icon = UIImage(named: "store")?.scaleImage(CGSize(width: 25, height: 25))
                marker.map = viewMap
            }
            
        }
        else {
            viewMap.clear()
            busShow = false
            btnStoreShow.setImage(UIImage(named: "StoreOFF"), forState: .Normal)
        }
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(10.762124, longitude: 106.682897, zoom: 13)
        viewMap.camera = camera
        viewMap.addObserver(self, forKeyPath: "myLocation", options: NSKeyValueObservingOptions.New, context: nil)
        viewMap.myLocationEnabled = true
        
        placesClient = GMSPlacesClient.sharedClient()
        
    }
    override func viewDidAppear(animated: Bool) {
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Location
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            viewMap.myLocationEnabled = true
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if !didFindMyLocation {
            let myLocation : CLLocation = change![NSKeyValueChangeNewKey] as! CLLocation
            viewMap.camera = GMSCameraPosition.cameraWithTarget(myLocation.coordinate, zoom: 13)
            viewMap.settings.myLocationButton = true
            didFindMyLocation = true
        }
    }
    
    
    // MARK: - Search
    func locateWithLongitude(lon: Double, andLatitude lat: Double, andTitle title: String) {
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            let position = CLLocationCoordinate2DMake(lat, lon)
            //            let marker = GMSMarker(position: position)
            
            let camera = GMSCameraPosition.cameraWithLatitude(lat, longitude: lon, zoom: 14)
            self.viewMap.camera = camera
            
            
            if (self.locationMarker != nil){
                self.locationMarker.map = nil
            }
            self.locationMarker = GMSMarker(position: position)
            self.locationMarker.title = "Address : \(title)"
            self.locationMarker.map = self.viewMap
        }
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil) { (results, error: NSError?) -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
            }
            
            for result in results! {
                if let result: GMSAutocompletePrediction = result  {
                    self.resultsArray.append(result.attributedFullText.string)
                }
            }
            
            self.searchResultController.reloadDataWithArray(self.resultsArray)
            
        }
    }
    
    
    // MARK: router
    var mapTasks = MapTasks()
    var originMarker: GMSMarker!
    var waypointsArray: Array<String> = []
    var markersArray: Array<GMSMarker> = []
    var routePolyline: GMSPolyline!
    var destinationMarker: GMSMarker!
    
    
    func configureMapAndMarkersForRoute() {
        viewMap.camera = GMSCameraPosition.cameraWithTarget(mapTasks.originCoordinate, zoom: 13.0)
        
        originMarker = GMSMarker(position: self.mapTasks.originCoordinate)
        originMarker.map = self.viewMap
        originMarker.icon = GMSMarker.markerImageWithColor(UIColor.greenColor())
        originMarker.title = self.mapTasks.originAddress
        
        destinationMarker = GMSMarker(position: self.mapTasks.destinationCoordinate)
        destinationMarker.map = self.viewMap
        destinationMarker.icon = GMSMarker.markerImageWithColor(UIColor.redColor())
        destinationMarker.title = self.mapTasks.destinationAddress
        
        
        if waypointsArray.count > 0 {
            for waypoint in waypointsArray {
                let lat: Double = (waypoint.componentsSeparatedByString(",")[0] as NSString).doubleValue
                let lng: Double = (waypoint.componentsSeparatedByString(",")[1] as NSString).doubleValue
                
                let marker = GMSMarker(position: CLLocationCoordinate2DMake(lat, lng))
                marker.map = viewMap
                marker.icon = GMSMarker.markerImageWithColor(UIColor.purpleColor())
                
                markersArray.append(marker)
            }
        }
    }
    
    
    func drawRoute() {
        let route = mapTasks.overviewPolyline["points"] as! String
        
        let path: GMSPath = GMSPath(fromEncodedPath: route)!
        routePolyline = GMSPolyline(path: path)
        routePolyline.map = viewMap
    }
    
    
    func displayRouteInfo() {
        print("mapTasks: \(mapTasks.totalDistance + "\n" + mapTasks.totalDuration)")
    }
    
    
    func clearRoute() {
        originMarker.map = nil
        destinationMarker.map = nil
        routePolyline.map = nil
        
        originMarker = nil
        destinationMarker = nil
        routePolyline = nil
        
        if markersArray.count > 0 {
            for marker in markersArray {
                marker.map = nil
            }
            
            markersArray.removeAll(keepCapacity: false)
        }
    }
    
    
    func recreateRoute() {
        if routePolyline != nil {
            clearRoute()
            
            mapTasks.getDirections(mapTasks.originAddress, destination: mapTasks.destinationAddress, waypoints: waypointsArray, travelMode: travelMode, completionHandler: { (status, success) -> Void in
                
                if success {
                    self.configureMapAndMarkersForRoute()
                    self.drawRoute()
                    self.displayRouteInfo()
                }
                else {
                    print("recreateRoute status: \(status)")
                }
            })
        }
    }
    
    
}
extension StoreViewController : DYAlertPickViewDataSource {
    func pickerview(pickerView: DYAlertPickView!, titleForRow row: Int) -> NSAttributedString! {
        let str = NSAttributedString(string: items[row])
        return str
    }
    func numberOfRowsInPickerview(pickerView: DYAlertPickView!) -> Int {
        return items.count
    }
    
}
extension StoreViewController : DYAlertPickViewDelegate {
    func pickerview(pickerView: DYAlertPickView!, didConfirmWithItemAtRow row: Int) {
        
        
        placesClient?.currentPlaceWithCallback({ (placeLikelihoodList, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    if let myAddress = place.formattedAddress {
                        
                        if self.routePolyline != nil {
                            self.clearRoute()
                            self.waypointsArray.removeAll(keepCapacity: false)
                        }
                        
                        let origin : String = myAddress
                        let destination : String = self.address[row]
                        
                        self.mapTasks.getDirections(origin, destination: destination, waypoints: nil, travelMode: self.travelMode, completionHandler: { (status, success) in
                            if success {
                                self.configureMapAndMarkersForRoute()
                                self.drawRoute()
                                self.displayRouteInfo()
                            }
                            else {
                                print("view direction status: \(status)")
                            }
                        })
                    }
                }
            }
        })
    }
    
    func pickerviewDidClickCancelButton(pickerView: DYAlertPickView!) {
        print("Canceled");
        placesClient?.currentPlaceWithCallback({ (placeLikelihoodList, error) in
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
            }
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    print("name: \(place.name)")
                    //                    print("address: \(place.formattedAddress?.componentsSeparatedByString(", ").joinWithSeparator("\n")))")
                    print("address: \(place.formattedAddress)")
                }
            }
        })
    }
}


