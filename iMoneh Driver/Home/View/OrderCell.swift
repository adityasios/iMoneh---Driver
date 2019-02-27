//
//  OrderCell.swift
//  iMoneh Driver
//
//  Created by Rakhi on 25/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class OrderCell: UITableViewCell {
    
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var lblAdd: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblDeliveryDate: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //bg
        viewBg.layer.cornerRadius = 4
        viewBg.clipsToBounds = true
        viewBg.layer.borderWidth = 1.0
        viewBg.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

