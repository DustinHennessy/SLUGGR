//
//  EditProfileViewController.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 8/5/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var profileTableView :UITableView!
    var dynamicLabelArray = ["First Name", "Last Name", "Home Address", "Work Address", "Driver Status", "Morning Departure Time", "Evening Departure Time", "Bio", "Preferences", "Your Map"]
    var dataFieldTypeArray = ["TextFieldCell", "TextFieldCell", "TextFieldCell", "TextFieldCell", "TextFieldCell", "TextFieldCell", "SwitchCell","TextViewCell", "TextViewCell", "MapCell"]
    
    //#2 geocode the home and work locations so we can annotate on the profileMapView
    
    //MARK: - Table Views
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicLabelArray.count
    }
    
    
    func tableFieldChanged(sender: AnyObject) {
        let dataFieldPosition = sender.convertPoint(CGPointZero, toView: profileTableView)
        let indexPath = profileTableView.indexPathForRowAtPoint(dataFieldPosition)
        switch indexPath!.row {
        case 0,1,2,3,4,5:
            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextFieldTableViewCell
            println("Text Value (row \(indexPath!.row)):\(cell.dynamicProfileTextField.text)")
        case 6:
            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as!ProfileSwitchTableViewCell
            if cell.cellSwitch.on {
                println("person is Driver")
            } else {
                println("person is NOT Driver")
            }
        case 7,8:
            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextViewTableViewCell
            println("Text Value (row \(indexPath!.row)):\(cell.dynamicTextView.text)")
        case 9:
            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileMapTableViewCell
        default:
            break
        }
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0,1,2,3,4,5:
            var textFieldCell = tableView.dequeueReusableCellWithIdentifier("TextFieldCell") as! ProfileTextFieldTableViewCell
            textFieldCell.dynamicTFCLabel.text = dynamicLabelArray[indexPath.row]
            textFieldCell.dynamicProfileTextField.addTarget(self, action: "tableFieldChanged", forControlEvents: UIControlEvents.EditingChanged)
            return textFieldCell
        case 6:
            var switchCell = tableView.dequeueReusableCellWithIdentifier("SwitchCell") as! ProfileSwitchTableViewCell
            switchCell.dynamicSCLabel.text = dynamicLabelArray[indexPath.row]
            switchCell.cellSwitch.addTarget(self, action: "tableFieldChanged", forControlEvents: UIControlEvents.ValueChanged)
            return switchCell
        case 7,8:
            var textViewCell = tableView.dequeueReusableCellWithIdentifier("TextViewCell") as! ProfileTextViewTableViewCell
            textViewCell.dynamicTVCLabel.text = dynamicLabelArray[indexPath.row]
            //textViewCell.dynamicTextView. the TEXT VIEW ISNT READY YET!
            return textViewCell
        case 9:
            var mapViewCell = tableView.dequeueReusableCellWithIdentifier("MapCell") as! ProfileMapTableViewCell
            //mapViewCell.profileMapView.addAnnotations(<#annotations: [AnyObject]!#>) add home and work annotations
            return mapViewCell
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as!
            UITableViewCell
            return cell
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         profileTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
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
