//
//  AppConstant.swift
//  Bleep
//
//  Created by Aditya Kumar on 9/3/18.
//  Copyright © 2018 Webmazix. All rights reserved.
//

import Foundation
import UIKit


//MARK: - ZENDESKKEY (PAVAN)
let kzenDeskKey = "6SclsnSmh5SmcKRLcmiyzcXVzGawQuh2"


//MARK: - APP COLORS
let appDarkYellow = UIColor(named: "appDarkYellow")
let appYellow = UIColor(named: "appYellow")
let appTrans = UIColor(named: "appTrans")

//MARK: - PLACEHOLDER
let imgPro_place = UIImage.init(named: "place_prod")

//MARK: - USER DEFAULT
enum AppUserDefault: String {
    case ctry_data = "json_country"
    case user_data = "user_data"
    case login_data = "login_data"
    case token = "token"
    case appleLanguagesKey = "AppleLanguages"
}

//MARK: - OrderStatus
enum OrderStatus: String {
    case new = "1"
    case assigned = "2"
    case completed = "3"
}

//MARK: - DEVICE SIZE
struct AppDevice {
    struct ScreenSize{
        static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType{
        static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6_7          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P_7P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
        static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
    }
}



enum OrderOption:String{
    case knock =  "Please do not ring the bell, Knock on the door"
    case securityGuard = "Leave order at the security guard"
    case doorstep = "Leave order at the home doorstep"
    
    static func getOrderOptionString(opt:Int)->String{
        if opt == 1 {
            return "Please do not ring the bell, Knock on the door".localized
        }else if opt == 2{
            return "Leave order at the security guard".localized
        }else if opt == 3{
            return "Leave order at the home doorstep".localized
        }else {
            return ""
        }
    }
}


enum ProductNotAvailable:String{
    case callYou =  "Call you"
    case removeItemFromCart = "Remove item from the cart"
    case exchangeItemWithSimilarOne = "Exchange product with similar prduct"
    
    static func getProductNotAvailableOptionString(opt:Int)->String{
        if opt == 1 {
            return "Call you".localized
        }else if opt == 2{
            return "Remove item from the cart".localized
        }else if opt == 3{
            return "Exchange product with similar prduct".localized
        }else {
            return "Unauthorize Option".localized
        }
    }
}


