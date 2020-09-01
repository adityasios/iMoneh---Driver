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
    static let login : String =  baseURL + "driver/login"
    static let country_list : String =  baseURL + "countries/list"
    static let fgt_pass : String =  baseURL + "driver/forgot/password"
    static let verify_otp : String =  baseURL + "driver/verify/otp"
    static let reset_pass : String =  baseURL + "driver/reset/password"
    static let profile_info : String =  baseURL + "driver/profile/info"
    static let update_pro_img : String =  baseURL + "driver/profile/image/update"
    static let update_vehicle_img : String =  baseURL + "driver/profile/vehicle/update"
    static let driver_online : String =  baseURL + "driver/change/online/status"
    static let order_list : String =  baseURL + "driver/orders/list"
    static let not_list : String =  baseURL + "driver/notifications/list"
    static let not_delete : String =  baseURL + "driver/notifications/delete/"
    static let driver_review : String =  baseURL + "driver/reviews/list"
    static let order_detail : String =  baseURL + "driver/orders/details/"
    static let about_us : String =  baseURL + "cms/about_us"
    static let payment_terms : String =  baseURL + "cms/payment_terms"
    static let cms_faq : String =  baseURL + "cms/faq"
    static let cms_terms : String =  baseURL + "cms/terms_conditions"
    static let cms_feedback : String =  baseURL + "cms/customer/feedback"
    static let cities_list : String =  baseURL + "cities/list"
    static let areas_list : String =  baseURL + "areas/list"
    static let orders_accept : String =  baseURL + "driver/orders/accept/"
    static let orders_reject : String =  baseURL + "driver/orders/reject"
    static let update_sign : String =  baseURL + "driver/orders/image/update"
    static let update_status : String =  baseURL + "driver/orders/change/status"
    static let product_details : String =  baseURL + "driver/order/product/details"
    static let order_cancellation_reason : String =  baseURL + "cancellation/reasons/list"
    
    
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
    
    static func createMultipartFileUploadRequestWithPara(strAbs : String, isToken : Bool,para : [String:String],filename:String,imgData:Data,img_para:String) -> (req: URLRequest?,dta: Data?){
        // generate boundary string using a unique per-app string
        let boundary = UUID().uuidString
        //get url
        guard let url = URL(string: strAbs) else { return (nil,nil)}
        // Set the URLRequest to POST and to the specified URL
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
        // And the boundary is also set here
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(Singleton.shared.locale, forHTTPHeaderField: Parameters.locale)
        if isToken {
            urlRequest.setValue(Singleton.shared.token!, forHTTPHeaderField: "x-access-token")
        }
        
        var data = Data()
        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(img_para)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(imgData)
        // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
        // According to the HTTP 1.1 specification https://tools.ietf.org/html/rfc7230
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return (urlRequest,data)
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
    static let driver_id = "driver_id"
    static let new_password = "new_password"
    static let status = "status"
    static let gender = "gender"
    static let profile_image = "profile_image"
    static let vehicle_image = "vehicle_image"
    static let title = "title"
    static let feedback = "feedback"
    static let city_id = "city_id"
    static let area_id = "area_id"
    static let image = "image"
    static let kMale = "1"
    static let kFemale = "2"
    static let comments = "comments"
    static let id = "id"
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
                DispatchQueue.main.async {
                    completionHandler(nil,err.localizedDescription)
                }
            }
        }
        dataTask.resume()
    }
    
    static func uploadDatefromSession(request:URLRequest,data_req:Data,completionHandler: @escaping (_ data: Data?, _ error: String? ) -> Void){
        let session = URLSession.shared
        let uploadTask = session.uploadTask(with: request, from: data_req) { (data_res, response, error) in
            //metadata of request
            if let httpResponse = response as? HTTPURLResponse {
                print("response code -  \(httpResponse.statusCode)")
            }
            //error
            if(error != nil){
                DispatchQueue.main.async {
                    completionHandler(nil,error!.localizedDescription)
                }
            }
            //data
            if let dt = data_res {
                DispatchQueue.main.async {
                    completionHandler(dt,nil)
                }
            }
        }
        uploadTask.resume()
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



