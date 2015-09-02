//
//  VenueTableTableViewController.swift
//  LocuEx
//
//  Created by Gurmeet Singh on 8/26/15.
//  Copyright (c) 2015 Gurmeet Singh. All rights reserved.
//

import UIKit

class VenueTableViewController: UITableViewController {

    var venue: Venue!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Restaurant Details"
    }

    private struct Constants {
        static let VenueCellReuseIdentifier = "Venue Details"
        static let rowsInSection = [1,1,1]
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.rowsInSection[section]
    }
    
    func venueDetails() -> String {
        var venueText =  ""
        venueText += venue!.name
        venueText += "\n"
        venueText += venue.address
        venueText += "\n"
        venueText += venue!.phoneNumber
        return venueText
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        switch indexPath.section {
          case 0:
                  let cell = tableView.dequeueReusableCellWithIdentifier(Constants.VenueCellReuseIdentifier, forIndexPath: indexPath) as! VenueTableViewCell
                  cell.rowLabel.text = venueDetails()
                  return cell
          case 1: fallthrough
          default:
                  let cell = tableView.dequeueReusableCellWithIdentifier(Constants.VenueCellReuseIdentifier, forIndexPath: indexPath) as! VenueTableViewCell
                   cell.rowLabel.text = venueDetails()
                   return cell
        }
    }
}
