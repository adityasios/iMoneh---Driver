//
//  DashBoardModels.swift
//  iMonehMarket
//
//  Created by Rakhi on 25/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//


import Foundation

struct BookMod : Codable {
    let close_time, open_time: String?
}


/*
"id": 3,
"delivery_company_id": 2,
"name": "Driver2",
"email": "info@imoneh.com",
"dial_code": "966",
"mobile": "0795757845",
"gender": null,
"transportation_type": 1,
"country_id": 1,
"city_id": 1,
"area_id": 22,
"address": "Amman",
"zip_code": "111",
"vehicle_no": "",
"is_online": 0,
"total_rejected_orders": 0,
"total_accepted_orders": 0,
"status": 1,
"created_at": null,
"updated_at": null
*/

struct UserMod : Codable {
    let id,country_id: Int?
    var is_online: Int?
    let total_rejected_orders: Int?
    let total_accepted_orders: Int?
    let transportation_type: Int?
    let delivery_company_id: Int?
    let gender: Int?
    
    let name: String?
    let email: String?
    var profile_image,vehicle_image: String?
    let dial_code: String?
    let mobile: String?
    let address: String?
    let created_at: String?
    let updated_at: String?
    let status: Int?
    let ratings: Float?
    
    
    enum CodingKeys: String, CodingKey {
        case id
        case delivery_company_id
        case transportation_type
        case country_id
        case is_online
        case total_rejected_orders
        case total_accepted_orders
        case gender
        case name
        case email
        case profile_image
        case vehicle_image
        case dial_code
        case mobile
        case address
        case created_at
        case updated_at
        case status
        case ratings
    }
}

struct CountryMod : Codable {
    let id,tax : Int?
    let country_name, currency_code, flag_image ,dial_code: String?
}

struct LocMod : Codable {
    let id : Int?
    let city_name: String?
    let area_name: String?
}



/*
 "country_name" = Jordan;
 "currency_code" = JD;
 "dial_code" = 962;
 "flag_image" = "jordan.png";
 id = 1;
 tax = 10;
 */









