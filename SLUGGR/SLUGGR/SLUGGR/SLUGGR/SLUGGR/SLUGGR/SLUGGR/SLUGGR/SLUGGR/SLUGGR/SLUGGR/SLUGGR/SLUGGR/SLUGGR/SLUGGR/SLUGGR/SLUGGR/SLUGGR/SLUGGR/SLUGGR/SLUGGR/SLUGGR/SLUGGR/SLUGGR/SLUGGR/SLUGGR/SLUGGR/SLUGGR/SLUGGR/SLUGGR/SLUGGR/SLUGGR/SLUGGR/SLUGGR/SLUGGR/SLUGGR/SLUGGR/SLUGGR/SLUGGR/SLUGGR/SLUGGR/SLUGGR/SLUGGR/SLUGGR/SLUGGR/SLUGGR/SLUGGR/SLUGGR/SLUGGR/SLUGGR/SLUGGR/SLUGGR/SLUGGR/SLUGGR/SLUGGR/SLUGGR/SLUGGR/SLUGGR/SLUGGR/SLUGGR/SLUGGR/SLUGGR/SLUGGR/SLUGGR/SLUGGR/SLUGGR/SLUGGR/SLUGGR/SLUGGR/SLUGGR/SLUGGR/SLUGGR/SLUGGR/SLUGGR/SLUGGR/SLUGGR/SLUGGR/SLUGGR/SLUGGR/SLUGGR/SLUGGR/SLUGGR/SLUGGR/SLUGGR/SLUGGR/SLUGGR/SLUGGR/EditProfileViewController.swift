//
//  EditProfileViewController.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 8/5/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var profileTableView :UITableView!
    var dynamicLabelArray = ["First Name", "Last Name", "Home Address", "Work Address", "Morning Depart Time", "Evening Depart Time", "Driver Status","Bio", "Preferences", "Your Map"]
    var dataFieldTypeArray = ["TextFieldCell", "TextFieldCell", "TextFieldCell", "TextFieldCell", "LabelCell", "LabelCell", "SwitchCell","TextViewCell", "TextViewCell", "MapCell"]
    var tapped = false
    var homeAddress :NSString!
    var workAddress :NSString!
    var dateValue :String!
    var mornDeptTime :String!
    var mDeptTime :String!
    var driverStatus :String!
    
    //#2 geocode the home and work locations so we can annotate on the profileMapView
    
    //MARK: - Table Views
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dynamicLabelArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let currentCellType = dataFieldTypeArray[indexPath.row];
        switch currentCellType {
        case "TextViewCell":
            return 120
        case "MapCell":
            return 180
        case "DateCell":
            return 200
        default:
            return 45
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = profileTableView.cellForRowAtIndexPath(indexPath)
        if cell is ProfileLabelTableViewCell {
            let tfCell = cell as! ProfileLabelTableViewCell
            if tfCell.dynamicLCLabel.text == "Morning Depart Time" || tfCell.dynamicLCLabel.text == "Evening Depart Time" {
                let nextIndexPath = NSIndexPath(forRow: indexPath.row + 1, inSection: indexPath.section)
                var nextCell = profileTableView.cellForRowAtIndexPath(nextIndexPath)
                if nextCell is ProfileDateTableViewCell {
                    dynamicLabelArray.removeAtIndex(indexPath.row + 1)
                    dataFieldTypeArray.removeAtIndex(indexPath.row + 1)
                    let tdCell = nextCell as! ProfileDateTableViewCell
                    tdCell.cellDatePicker.hidden = true
                    profileTableView.deleteRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Top)
                } else {
                    dynamicLabelArray.insert("Start Time", atIndex: indexPath.row + 1)
                    dataFieldTypeArray.insert("DateCell", atIndex: indexPath.row + 1)
                    profileTableView.insertRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
                }
                // FIX THIS
                profileTableView.reloadRowsAtIndexPaths([nextIndexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            }
        }
    }
    
    func tableFieldChanged(sender: AnyObject) {
        println("TFC")
        let dataFieldPosition = sender.convertPoint(CGPointZero, toView: profileTableView)
        var indexPath = profileTableView.indexPathForRowAtPoint(dataFieldPosition)
        println("X:\(dataFieldPosition.x) Y:\(dataFieldPosition.y) Row:\(indexPath!.row)")
        var cell = profileTableView.cellForRowAtIndexPath(indexPath!)
        if cell is ProfileTextFieldTableViewCell {
            let sCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextFieldTableViewCell
            if sCell.dynamicTFCLabel.text == "Home Address" {
                if sCell.dynamicProfileTextField != nil {
                    homeAddress = sCell.dynamicProfileTextField.text
                }
            }
            if sCell.dynamicTFCLabel.text == "Work Address" {
                if sCell.dynamicProfileTextField != nil {
                    workAddress = sCell.dynamicProfileTextField.text
                }
            }
        }
        //        if cell is ProfileLabelTableViewCell {
        //           let lCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileLabelTableViewCell
        //            if lCell.dynamicLCLabel.text = "Morning Depart Time" {
        //                if lCell.dynamicLCDetailLabel != nil {
        //                }
        //            }
        //
        //        }
        if cell is ProfileDateTableViewCell {
            let dCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileDateTableViewCell
            indexPath = NSIndexPath(forRow: indexPath!.row - 1, inSection: indexPath!.section)
            let lCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileLabelTableViewCell
            lCell.dynamicLCDetailLabel.text = formatDate(dCell.cellDatePicker.date)
            mDeptTime = formatDate(dCell.cellDatePicker.date)
        }
        if cell is ProfileSwitchTableViewCell {
            let swCell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileSwitchTableViewCell
            if swCell.cellSwitch == false {
                driverStatus = "No"
            } else {
                driverStatus = "Yes"
            }
        }
    }
    
    
    
    
//        switch indexPath!.row {
//        case 0,1,2,3,4,5:
//            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextFieldTableViewCell
//            println("Text Value (row \(indexPath!.row)):\(cell.dynamicProfileTextField.text)")
//        case 6:
//            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as!ProfileSwitchTableViewCell
//            if cell.cellSwitch.on {
//                println("person is Driver")
//            } else {
//                println("person is NOT Driver")
//            }
//        case 7,8:
//            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileTextViewTableViewCell
//            println("Text Value (row \(indexPath!.row)):\(cell.dynamicTextView.text)")
//        case 9:
//            var cell = profileTableView.cellForRowAtIndexPath(indexPath!) as! ProfileMapTableViewCell
//        default:
//            break
//        }
//        
//    }
    
    func formatDate(date: NSDate) -> String {
        var dateFormatter :NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d @ h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentCellType = dataFieldTypeArray[indexPath.row];
        switch currentCellType {
        case "TextFieldCell":
            var textFieldCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileTextFieldTableViewCell
            textFieldCell.dynamicTFCLabel.text = dynamicLabelArray[indexPath.row]
            textFieldCell.dynamicProfileTextField.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.EditingChanged)
            textFieldCell.selectionStyle = UITableViewCellSelectionStyle.None
            return textFieldCell
        case "LabelCell":
            var labelCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileLabelTableViewCell
            labelCell.dynamicLCLabel.text = dynamicLabelArray[indexPath.row]
            labelCell.dynamicLCDetailLabel.text = formatDate(NSDate())
            labelCell.selectionStyle = UITableViewCellSelectionStyle.None
            return labelCell
        case "SwitchCell":
            var switchCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileSwitchTableViewCell
            switchCell.dynamicSCLabel.text = dynamicLabelArray[indexPath.row]
            switchCell.cellSwitch.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
            switchCell.selectionStyle = UITableViewCellSelectionStyle.None
            return switchCell
        case "TextViewCell":
            var textViewCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileTextViewTableViewCell
            textViewCell.dynamicTVCLabel.text = dynamicLabelArray[indexPath.row]
            //textViewCell.dynamicTextView. the TEXT VIEW ISNT READY YET!
            textViewCell.selectionStyle = UITableViewCellSelectionStyle.None
            return textViewCell
        case "MapCell":
            var mapViewCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileMapTableViewCell
            //mapViewCell.profileMapView.addAnnotations(<#annotations: [AnyObject]!#>) add home and work annotations
            mapViewCell.selectionStyle = UITableViewCellSelectionStyle.None

            return mapViewCell
        case "DateCell":
            var dateViewCell = tableView.dequeueReusableCellWithIdentifier(currentCellType) as! ProfileDateTableViewCell
            dateViewCell.cellDatePicker.hidden = false
            // SET DATE HERE
            dateViewCell.cellDatePicker.addTarget(self, action: "tableFieldChanged:", forControlEvents: UIControlEvents.ValueChanged)
            dateViewCell.selectionStyle = UITableViewCellSelectionStyle.None

            return dateViewCell
        default:
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
    }
    
    
//    //MARK: - Data to API
// 
//    func saveDataToAPI(sender: UIBarButtonItem) {
//        println("GDFA Start")
//        
//        //creating the request
//        let url = NSURL(string: "http://sluggr-api.herokuapp.com/demo_user/edit")
//        let request = NSMutableURLRequest(URL: url!)
//        request.HTTPMethod = "PUT"
//        let tempEmail = "a@b.com"
//        //request.setValue("basic \(", forHTTPHeaderField: "home_locale") HOME LOCALE
//        
//        request.setValue("basic \(tempEmail)", forHTTPHeaderField: "email")
//        
//        //firing the request
//        //let urlConnection = NSURLConnection(request: request, delegate: self)
//        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
//            println("error: \(error)")
//            var err: NSError
//            var jsonResult: NSDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
//            let usersDictArray = jsonResult.objectForKey("users") as! [NSDictionary]
//            for userDict in usersDictArray {
//                let user = Users()
//              
//                
//            }
//        })
//        println("GDFA End")
//        
//    }
//
//        
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
