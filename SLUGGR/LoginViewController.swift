//
//  LoginViewController.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 7/31/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

//    var userArray = [Users]()

    var fieldArray = ["Email", "Username", "Password"]
    @IBOutlet var loginTableView :UITableView!
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return fieldArray.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell :RegisterLoginTableViewCell = tableView.dequeueReusableCellWithIdentifier("rlcell") as! RegisterLoginTableViewCell
//        let currentUser = userArray[indexPath.row]
        cell.dynamicLabel.text = fieldArray[indexPath.row]
        tableView.scrollEnabled = false
        
        
        return cell
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("VDL")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
