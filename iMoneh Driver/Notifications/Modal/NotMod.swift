//
//  NotMod.swift
//  iMonehMarket
//
//  Created by Rakhi on 14/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import Foundation


/*
attribute = "order_id";
content = "You have received new order(Order Id # IMN1549457620356).";
"created_at" = "2019-02-06T18:23:40.000Z";
id = 94;
"notification_type" = 4;
title = "New Order";
value = 75;
*/


struct NotMod : Codable {
    let id,notification_type: Int?
    let title,content,attribute,value: String?
    let created_at: String?
}



