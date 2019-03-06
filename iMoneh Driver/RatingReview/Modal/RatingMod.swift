//
//  RatingMod.swift
//  iMoneh Driver
//
//  Created by Rakhi on 05/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import Foundation
struct RatingMod : Codable {
    let id,rating: Int?
    var title,comments: String?
    let created_at: String?
    let customer_name: String?
    let order_code: String?
    let profile_image: String?
    let gender: Int?
}


/*
 id = 113;
 comments = dfs;
 "created_at" = "2019-03-05T13:24:47.000Z";
 "customer_name" = test15;
 "order_code" = IMN1551163708359;
 "profile_image" = "258120e53b575eafac85f38ed0cb67cabb89.jpg";
 rating = 4;
 title = gfdgdsfds;
 */
