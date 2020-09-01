//
//  Home.swift
//  iMoneh Driver
//
//  Created by Rakhi on 28/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import Foundation

struct OrderMod : Codable {
    let id: Int?
    let order_id: Int?
    let sub_order_id: Int?
    let order_number: String?
    let vendor_id: Int?
    let delivery_date: String?
    let delivery_time: String?
    let currency: String?
    let vendor_address: AddMod?
    let customer_address: AddMod?
    let customer: CustMod?
    let order_status: Int?
    
    //detail_extra
    let receiver_name: String?
    let sender_name: String?
    let deliver_datetime: String?
    let pickup_datetime: String?
    let pickup_signature_image,deliver_signature_image: String?
    let payment_method: Int?
    let payment_status: Int?
    let change_amount: Int?
    
    //price
    let sub_total: Float?
    let delivery_cost: Float?
    let tax_percentage: Float?
    let tax_amount: Float?
    let total_amount: Float?
    
    //new data
    let market_name: String?

    //order_options
    let order_options: String?
    
    //product_not_available_option
    let product_not_available_option: Int?
}

struct AddMod : Codable {
    let address: String?
    let country_name: String?
    let city_name: String?
    let area_name: String?
    let owner_name: String?
}

//detail_extra
struct CustMod : Codable {
    let dial_code: String?
    let mobile: String?
    let name: String?
    let profile_image: String?
}


/*
 {
 "id": 23,
 "order_id": 113,
 "order_number": "IMN1551163708360",
 "total_amount": 124.3,
 "vendor_id": 296,
 "delivery_date": "2019-02-26T18:30:00.000Z",
 "delivery_time": "03:17 PM - 05:17 PM",
 "status": 1,
 "order_status": 1,
 "vendor_address": {
 "country_name": "Jordan",
 "city_name": "Amman",
 "area_name": "Swefieh"
 },
 "customer_address": {
 "country_name": "Jordan",
 "city_name": "Amman",
 "area_name": "Daheit Al Rasheed"
 }
 }
 */

/*
{
    currency = JD;
    "customer_address" =     {
        address = "ig, g7t, ittit";
        "area_name" = Swefieh;
        "building_no" = g7t;
        "city_name" = Amman;
        "country_name" = Jordan;
        "flat_no" = ig;
        "street_name" = ittit;
        "zip_code" = "<null>";
    };
    "delivery_cost" = 3;
    "delivery_date" = "2019-04-18T00:00:00.000Z";
    "delivery_time" = "11:30 - 13:30";
    id = 43;
    "market_name" = "Mshakal (HomeMade)";
    "order_id" = 260;
    "order_number" = IMN1555510294959;
    "order_status" = 1;
    "owner_name" = "Ehab Asi";
    "payment_status" = 1;
    status = 1;
    "sub_total" = 10;
    "tax_amount" = 0;
    "tax_percentage" = 0;
    "total_amount" = "14.5";
    "vendor_address" =     {
        "area_name" = Swefieh;
        "city_name" = Amman;
        "country_name" = Jordan;
    };
    "vendor_id" = 201;
}
*/


























/*

{
    "change_amount" = 0;
    currency = JD;
    customer =     {
        "dial_code" = 962;
        mobile = 9999999992;
        name = test15;
        "profile_image" = "258120e53b575eafac85f38ed0cb67cabb89.jpg";
    };
    "customer_address" =     {
        "area_name" = "Daheit Al Rasheed";
        "city_name" = Amman;
        "country_name" = Jordan;
    };
    "customer_id" = 477;
    "deliver_datetime" = "2019-03-01T18:08:44.000Z";
    "deliver_signature_image" = "3d484b8b7d852be8798edef9bbe176bf47b2.jpg";
    "delivery_cost" = 3;
    "delivery_date" = "2019-02-27T00:00:00.000Z";
    "delivery_time" = "03:17 PM - 05:17 PM";
    id = 23;
    notes = "<null>";
    "order_id" = 113;
    "order_number" = "<null>";
    "order_options" = "[]";
    "payment_method" = 1;
    "payment_status" = 2;
    "pickup_datetime" = "2019-03-01T18:02:25.000Z";
    "pickup_signature_image" = "ed39bc9782f75a628d33535ecd3aebafec87.jpg";
    "receiver_name" = Arun;
    "sender_name" = Pavan;
    status = 5;
    "total_amount" = "124.3";
    "vendor_address" =     {
        "area_name" = Swefieh;
        "city_name" = Amman;
        "country_name" = Jordan;
    };
    "vendor_id" = 296;
}
*/
