//
//  ApiUrlFactory.swift
//  iMonehMarket
//
//  Created by Rakhi on 25/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import Foundation
import RSLoadingView


// MARK:- BASE URLS
private let baseURL: String = "http://142.93.210.141:3000/api/"
private let aWSImgBaseURL: String = "http://d3kijqoezpm7i6.cloudfront.net/"

// MARK:- APIURLFactory
struct APIURLFactory {
    
    //paths
    static let sign_up : String =  baseURL + "driver/register"
    
    static let login : String =  baseURL + "vendor/login"
    static let country_list : String =  baseURL + "countries/list"
    static let categories : String =  baseURL + "vendor/categories/list"
    static let products : String =  baseURL + "vendor/products/list"
    static let product_detail : String =  baseURL + "vendor/products/details"
    static let profile_update : String =  baseURL + "vendor/profile/update"
    static let fgt_pass : String =  baseURL + "vendor/forgot/password"
    static let verify_otp : String =  baseURL + "vendor/verify/otp"
    static let reset_pass : String =  baseURL + "vendor/reset/password"
    static let not_list : String =  baseURL + "vendor/notifications/list"
    static let order_list : String =  baseURL + "vendor/orders/list"
    static let pro_list : String =  baseURL + "vendor/order/products/list/"
    static let bid_list : String =  baseURL + "vendor/bids/list"
    static let bid_prods : String =  baseURL + "vendor/bids/products/list/"
    static let not_delete : String =  baseURL + "vendor/notification/delete/"
    static let user_detail : String =  baseURL + "vendor/bid/user/details/"
   
    //img_paths
    static let profile_img : String =  aWSImgBaseURL + "uploads/vendors/"
    static let cat_img : String =  aWSImgBaseURL + "uploads/categories/"
    static let pro_img : String =  aWSImgBaseURL + "uploads/products/"
    static let cust_proimg : String =  aWSImgBaseURL + "uploads/images/"
    static let country_flag : String =  aWSImgBaseURL + "uploads/countries/"
    
    //requests - post
    static func createPostRequest(url : URL, isToken : Bool) -> URLRequest{
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    //requests - post
    static func createPostRequestWithPara(strAbs : String, isToken : Bool,para : [String:Any]) -> URLRequest?{
        
        //get url
        guard let url = URL(string: strAbs) else { return nil}
        
        //header
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Singleton.shared.locale, forHTTPHeaderField: Parameters.locale)
        if isToken {
            request.setValue(Singleton.shared.token!, forHTTPHeaderField: "x-access-token")
        }
        
        //body
        if !para.isEmpty {
            print("para = \(para)")
            guard let httpBody = try? JSONSerialization.data(withJSONObject: para, options: []) else {
                return nil
            }
            request.httpBody = httpBody
        }
        return request
    }
    
    //requests - get
    static func createGetRequestWithPara(strAbs : String, isToken : Bool,para : [String:String]) -> URLRequest?{
        
        guard var components = URLComponents(string: strAbs) else {
            return nil
        }
        
        if !para.isEmpty {
            components.queryItems = para.map { (arg) -> URLQueryItem in
                let (key, value) = arg
                return URLQueryItem(name: key, value: value )
            }
        }
        
        //get url
        components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        guard let url = components.url  else { return nil}
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Singleton.shared.locale, forHTTPHeaderField: Parameters.locale)
        if isToken {
            request.setValue(Singleton.shared.token!, forHTTPHeaderField: "x-access-token")
        }
        return request
    }
}

// MARK:- Parameters
struct Parameters {
    static let name = "name"
    static let email = "email"
    static let pass = "password"
    static let fcmId = "fcm_id"
    static let deviceId = "device_id"
    static let deviceType = "device_type"
    static let deviceTypeiOS = "2"
    static let locale = "locale"
    static let en_market_name = "en_market_name"
    static let ar_market_name = "ar_market_name"
    static let dial_code = "dial_code"
    static let address = "address"
    static let mobile = "mobile"
    static let latitude = "latitude"
    static let longitude = "longitude"
    static let category_id = "category_id"
    static let sub_category_id = "sub_category_id"
    static let country_id = "country_id"
    static let page = "page"
    static let otp = "otp"
    static let vendor_id = "vendor_id"
    static let new_password = "new_password"
    static let status = "status"
    static let gender = "gender"
    
    
    static let kMale = "1"
    static let kFemale = "2"
}

// MARK:- URlSessionWrapper
struct URlSessionWrapper {
    
    static func getDatefromSession(request : URLRequest,completionHandler: @escaping (_ data: Data?, _ error: String? ) -> Void){
        print("request -  \(request)")
        let session = URLSession.shared
        let dataTask =  session.dataTask(with: request) { (data, response, error) in
            
            //metadata of request
            if let httpResponse = response as? HTTPURLResponse {
                print("response code -  \(httpResponse.statusCode)")
            }
            
            //data
            if let data = data {
                DispatchQueue.main.async {
                    completionHandler(data,nil)
                }
            }
            
            //error
            if let err = error {
                completionHandler(nil,err.localizedDescription)
            }
        }
        dataTask.resume()
    }
}

// MARK:- URlErrorHandling
struct URlErrorHandling {
    static func checkErrorInResponse(json : Any){
        var msgError = ""
        if let errJson = json as? [[String: Any]]  {
            for dict in errJson {
                guard let msg = dict["msg"] as? String else {
                    continue
                }
                msgError = msgError + "\n" + msg
            }
        }
        
        DispatchQueue.main.async {
            msgError = msgError.trimmingCharacters(in:.whitespacesAndNewlines)
            BasicUtility.getAlertWithoutVC(titletop: "Error", subtitle: msgError)
        }
    }
}

// MARK:- Loader
struct Loader {
    static private let loadingView = RSLoadingView()
    static func showLoadingView(view:UIView){
        Loader.loadingView.shouldTapToDismiss = false
        Loader.loadingView.mainColor = appDarkYellow!
        Loader.loadingView.show(on: view)
    }
    static func hideLoadingView(view:UIView){
        DispatchQueue.main.async {
            Loader.loadingView.hide()
        }
    }
}
