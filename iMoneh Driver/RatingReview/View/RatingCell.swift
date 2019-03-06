//
//  RatingCell.swift
//  iMoneh Driver
//
//  Created by Rakhi on 01/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
class RatingCell: UITableViewCell {
    @IBOutlet weak var imgVPro: UIImageView!
    @IBOutlet weak var lblOrder: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgVPro.layer.cornerRadius = 33
        imgVPro.clipsToBounds = true
        imgVPro.contentMode = .scaleAspectFill
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
