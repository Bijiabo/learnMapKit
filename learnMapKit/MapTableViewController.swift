//
//  MapTableViewController.swift
//  learnMapKit
//
//  Created by huchunbo on 15/12/12.
//  Copyright © 2015年 Bijiabo. All rights reserved.
//

import UIKit

import MapKit
import CoreLocation

class MapTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cell in TableView"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 200.0
            
        default:
            return 44.0
        }
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 20
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("mapCell", forIndexPath: indexPath) as! MapTableViewCell
            return cell
            
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("normalCell", forIndexPath: indexPath) as! NormalTableViewCell
            return cell
        }
    }
}
