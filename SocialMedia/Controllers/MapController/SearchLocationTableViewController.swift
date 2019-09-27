//
//  SearchLocationTableViewController.swift
//  SocialMedia
//
//  Created by iOSDev on 10/27/17.
//  Copyright © 2017 My Technology. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class SearchLocationTableViewController: UITableViewController {

    var likelyPlaces: [GMSPlace] = []
    var selectedPlace : GMSPlace?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        addBackButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return likelyPlaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchCell")!
        let collectionItem = likelyPlaces[indexPath.row]
        
        cell.textLabel?.text = collectionItem.name
        cell.textLabel?.font = CommonMethods.getFontOfSize(size: 16)
        return cell
    }

    // Make table rows display at proper height if there are less than 5 items.
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == tableView.numberOfSections - 1) {
            return 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FeedsHandler.sharedInstance.selectedPlace = likelyPlaces[indexPath.row]
        FeedsHandler.sharedInstance.isPlaceSelected = true
        navigationController?.popViewController(animated: true)
    }
}
