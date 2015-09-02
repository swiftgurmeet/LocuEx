//
//  VenueTableTableViewController.swift
//  LocuEx
//
//The MIT License (MIT)
//
//Copyright (c) 2015 swiftgurmeet
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

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
