//
//  MapViewController.swift
//  SocialMedia
//
//  Created by iOSDev on 10/27/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces
import NVActivityIndicatorView

class MapViewController: UIViewController, CLLocationManagerDelegate, UITextFieldDelegate,UISearchBarDelegate, NVActivityIndicatorViewable{

    var selectedPin: MKPlacemark?

    var resultSearchController: UISearchController!
     @IBOutlet weak var addresstxtField: UITextField!
    var initialLocation = CLLocation(latitude: 25.276987, longitude: 55.296249)

    // Google Maps implimentation
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    // An array to hold the list of likely places.
    var likelyPlaces: [GMSPlace] = []
    // The currently selected place.
    var selectedPlace: GMSPlace?
 let marker = GMSMarker()
    //var resultSearchController:UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addresstxtField.delegate = self

        //FeedsHandler.sharedInstance.isPlaceSelected = true
        
        self.setupLocationManager()
        self.title = "Check In".localized
       // viewSearch.delegate = self
        self.setupViews()
        addBackButton()
        self.showLoader()
    }
    
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        if FeedsHandler.sharedInstance.isPlaceSelected {
//            let objSelectedPlace = FeedsHandler.sharedInstance.selectedPlace
//            let lat = objSelectedPlace?.coordinate.latitude
//            let long = objSelectedPlace?.coordinate.longitude
//            mapView.clear()
//            let marker = GMSMarker()
//            marker.position = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
//            marker.title = objSelectedPlace?.name
//            marker.snippet = objSelectedPlace?.className
//            marker.map = mapView
//            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
//                self.onBackButtonClciked()
//            })
//        }
        
        
        if FeedsHandler.sharedInstance.isPlaceSelected {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
                self.onBackButtonClciked()
            })
        }else{
            
        }
        
        
    }
    
    // MARK: - Custom
    func setupViews (){
        
        let camera = GMSCameraPosition.camera(withLatitude: initialLocation.coordinate.latitude,
                                              longitude: initialLocation.coordinate.longitude,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        
        // Add the map to the view, hide it until we've got a location update.
        view.addSubview(mapView)
        mapView.isHidden = true
        
        self.addPostButton()
    }
    func showLoader(){
        let size = CGSize(width: 30, height: 30)
        startAnimating(size, message: "Loading...".localized,messageFont: CommonMethods.getFontOfSize(size: 14),type: NVActivityIndicatorType.ballTrianglePath)
    }

    func addPostButton() {
        let btn1 = UIButton(type: .custom)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.setTitle("Get Places".localized, for: .normal)
        btn1.setTitleColor(.white, for: .normal)
        btn1.titleLabel?.font = CommonMethods.getFontOfSize(size: 16)
        btn1.addTarget(self, action: #selector(self.onPlaces), for: .touchUpInside)
        let item1 = UIBarButtonItem(customView: btn1)
        self.navigationItem.setRightBarButtonItems([item1], animated: true)
    }
    
    @objc func onPlaces() {
        print("Post")
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        controller.likelyPlaces = self.likelyPlaces
        self.navigationController?.pushViewController(controller, animated: true)
    }

    func setupLocationManager (){
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()

    }
    
    // MARK: - LocationManager Delegate
    func listLikelyPlaces() {
        // Clean up from previous sessions.
        likelyPlaces.removeAll()
     
        placesClient.currentPlace(callback: { (placeLikelihoods, error) -> Void in
            if let error = error {
                // TODO: Handle the error.
                print("Current Place error: \(error.localizedDescription)")
                self.stopAnimating()
                return
            }
            
            // Get likely places and add to the list.
            if let likelihoodList = placeLikelihoods {
                for likelihood in likelihoodList.likelihoods {
                    let place = likelihood.place
                    self.likelyPlaces.append(place)
                }
                print(self.likelyPlaces)
                self.stopAnimating()
            }
        })
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
        listLikelyPlaces()
    }
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted:
            print("Location access was restricted.")
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
        case .authorizedWhenInUse:
            print("Location status is OK.")
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
    //searchBarSearchButtonClicked
    private func searchBarSearchButtonClicked( searchBar: UISearchBar!){
        print(searchBar.text)
        
    }
    
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SearchLocationTableViewController") as! SearchLocationTableViewController
        controller.likelyPlaces = self.likelyPlaces
        self.navigationController?.pushViewController(controller, animated: true)

    }

}
extension MapViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D){
        marker.position = coordinate
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("didEndDragging")
    }
}

extension MapViewController {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.addresstxtField {
            
            
            let autoComplete = GMSAutocompleteViewController()
            autoComplete.delegate = self
            present(autoComplete, animated: true, completion: nil)
            return false
        }
        
        return true
    }
}
extension MapViewController: GMSAutocompleteViewControllerDelegate  {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        
        print(place.coordinate.latitude)
        print(place.coordinate.longitude)
     //   self.filter_lat = place.coordinate.latitude
     //   self.filter_long = place.coordinate.longitude
       // FeedsHandler.sharedInstance.selectedPlace =  place.formattedAddress
        //FeedsHandler.sharedInstance.isPlaceSelected = true
        
        
     //   self.addresstxtField.text = place.formattedAddress
        // self.locateWithLongitude(self.filter_long, andLatitude: self.filter_lat, andTitle: "Searched Place")
        dismiss(animated: true, completion: nil)
        
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion:nil )
        
    }
    
    // Show the network activity indicator.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    // Hide the network activity indicator.
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    
    
}

