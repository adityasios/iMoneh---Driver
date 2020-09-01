//
//  OrderCancelCell.swift
//  iMoneh Driver
//
//  Created by Webmaazix on 18/12/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class OrderCancelCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle     : UILabel!
    @IBOutlet weak var btnCheckBox  : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    public func loadCell(_ data: OrderCancellationReasonMod) {
        lblTitle.text = data.title
        btnCheckBox.isSelected = data.isSelected
    }

}
