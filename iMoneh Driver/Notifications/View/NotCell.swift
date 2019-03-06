//
//  NotCell.swift
//  iMonehMarket
//
//  Created by Rakhi on 15/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class NotCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var btnDelete: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


