//
//  Singleton.swift
//  iMonehMarket
//
//  Created by Rakhi on 28/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class Singleton {
    static let shared = Singleton()
    private init(){}
    
    var device_Id: String?
    var fcm_Id: String?
    var locale: String = "en" //en/ar
    var token: String?
    var userMod: UserMod?
    var keyboard_ht: CGFloat?
    var img_profile: UIImage?
    var isDeliveryCompany: Bool = false
}




