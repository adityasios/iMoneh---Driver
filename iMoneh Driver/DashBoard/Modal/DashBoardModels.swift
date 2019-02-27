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
 market_name
 en_market_name" = "EN Test Market";
 
 "en_owner_name" = iMoneh;
 "owner_name" = "\U0623\U064a \U0645\U0648\U0646\U0629";
 */



struct UserMod : Codable {
    
    let id,total_rating,country_id: Int?
    let enName,enMarketName,arMarketName,arOwner_name: String?
    let description,image : String?
    let address, email,dial_code,mobile: String?
    let created_at: String?
    let business_timing : BookMod?
    
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case total_rating
        case dial_code
        case mobile
        case email
        case address
        case country_id
        case business_timing
        case image
        case created_at
        
        case enName = "en_owner_name"
        case enMarketName = "en_market_name"
        
        case arMarketName = "market_name"
        case arOwner_name = "owner_name"
        
        case description
        
    }
}


struct CountryMod : Codable {
    let id,tax : Int?
    let country_name, currency_code, flag_image ,dial_code: String?
}




/*
 "country_name" = Jordan;
 "currency_code" = JD;
 "dial_code" = 962;
 "flag_image" = "jordan.png";
 id = 1;
 tax = 10;
 */









