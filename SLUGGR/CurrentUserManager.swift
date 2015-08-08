//
//  CurrentUserManager.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 8/7/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class CurrentUserManager: NSObject {
   
    static let sharedInstance = CurrentUserManager()
   
    var currentUser :Users?
    
}
