//
//  GroupTableViewCell.swift
//  SLUGGR
//
//  Created by Dustin Hennessy on 8/10/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class GroupTableViewCell: UITableViewCell {

    @IBOutlet var groupMemberNameLabel :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
