//
//  OrderDetailCell.swift
//  iMoneh Driver
//
//  Created by Rakhi on 05/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class OrderDetailCell: UITableViewCell {
    @IBOutlet weak var lblTitleOne: UILabel!
    @IBOutlet weak var lblDecOne: UILabel!
    @IBOutlet weak var imgVOne: UIImageView!
    @IBOutlet weak var lblTitleTwo: UILabel!
    @IBOutlet weak var lblDecTwo: UILabel!
    @IBOutlet weak var imgVTwo: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
