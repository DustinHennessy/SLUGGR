//
//  UserTableViewCell.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 7/31/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    
    @IBOutlet var nameLabel :UILabel!
    @IBOutlet var destinationLabel :UILabel!
    @IBOutlet var rideshareButton :UIButton!
    @IBOutlet var chatButton :UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
