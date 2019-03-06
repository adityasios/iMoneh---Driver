//
//  BasicUtility.swift
//  Bleep
//
//  Created by Aditya Kumar on 9/6/18.
//  Copyright © 2018 Webmazix. All rights reserved.
//

import UIKit

//MARK: - BasicUtility
class BasicUtility{
    
    static  func getAlert(view:UIViewController,titletop:String,subtitle:String){
        let AC = UIAlertController(title: titletop, message: subtitle, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        view.present(AC, animated: true, completion:nil)
    }
    
    static  func getAlertWithoutVC(titletop:String,subtitle:String){
        let AC = UIAlertController(title: titletop, message: subtitle, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .default, handler: {(_ action: UIAlertAction) -> Void in
        })
        AC.addAction(okBtn)
        AC.show()
    }
    
    static  func removeAllUserDefault(){
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
    }
}

//MARK: - DateHelper
struct DateHelper {
    static func getBookTimingInLocalFromUTC(open: String, close: String) -> (timing: String, status: Bool){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        
        guard let dateOpen = dateFormatter.date(from: open) else {
            return ("-",false)
        }
        
        guard  let dateClose = dateFormatter.date(from: close) else {
            return ("-",false)
        }
        
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        
        let timeOpen = dateFormatter.string(from: dateOpen)
        let timeClose = dateFormatter.string(from: dateClose)
        
        let strTemp = timeOpen + "-" + timeClose
        
        
        //check in between
        let date = Date()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        let timeCrt = dateFormatter.string(from: date)
        guard let dateCrt = dateFormatter.date(from: timeCrt) else {
            return ("-",false)
        }
        
        let isFallsBwn =  dateCrt.isBetween(dateOpen, and: dateClose)
        return (strTemp , isFallsBwn)
    }
    
    static func getDeliveryDateInLocalFromUTC(crt: String) -> String{
        //"2019-03-01T18:08:44.000Z";
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        guard let date_Crt = dateFormatter.date(from: crt) else {
            return "-"
        }
        
        dateFormatter.dateFormat = "dd MMM yyyy"
        dateFormatter.timeZone = TimeZone.current
        let date_tmp = dateFormatter.string(from: date_Crt)
        return date_tmp
    }
    
    static func getDeliveryTimeInLocalFromUTC(crt: String) -> String{
        //"2019-03-01T18:08:44.000Z";
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        guard let date_Crt = dateFormatter.date(from: crt) else {
            return "-"
        }
        
        dateFormatter.dateFormat = "HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date_tmp = dateFormatter.string(from: date_Crt)
        return date_tmp
    }
    
    static func getNotDateInLocalFromUTC(crt: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        guard let date_Crt = dateFormatter.date(from: crt) else {
            return "-"
        }
        
        dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        let date_tmp = dateFormatter.string(from: date_Crt)
        return date_tmp
    }
    
    static func getReviewDateInLocalFromUTC(crt: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.init(abbreviation: "UTC")
        guard let date_Crt = dateFormatter.date(from: crt) else {
            return "-"
        }
        
        dateFormatter.dateFormat = "MMM dd,yyyy | HH:mm"
        dateFormatter.timeZone = TimeZone.current
        let date_tmp = dateFormatter.string(from: date_Crt)
        return date_tmp
    }
    
    
}

//MARK: - DateHelper
struct ProjectHelper {
    static func setProfileImage(imgV: UIImageView){
        imgV.contentMode = .scaleAspectFill
        imgV.backgroundColor = appTrans
        if let pro_img = Singleton.shared.img_profile {
            imgV.image = pro_img
        }else if let str_pro = Singleton.shared.userMod?.profile_image,let urlimg = URL.init(string: APIURLFactory.cust_proimg + str_pro) {
            imgV.sd_setImage(with: urlimg) { (img, err, type, url) in
                Singleton.shared.img_profile = img
            }
        }
    }
    
    static func setVehicleImage(imgV: UIImageView){
        imgV.contentMode = .scaleAspectFill
        imgV.backgroundColor = appTrans
        if let str_veh = Singleton.shared.userMod?.vehicle_image,let urlimg = URL.init(string: APIURLFactory.cust_proimg + str_veh) {
            imgV.sd_setImage(with: urlimg) { (img, err, type, url) in
            }
        }
    }
    
    static func saveUserModel(userMod:UserMod) {
        DispatchQueue.main.async {
            Singleton.shared.userMod = userMod
            //save token
            UserDefaults.standard.set(Singleton.shared.token!, forKey: AppUserDefault.token.rawValue)
            
            //save login data
            let data = try! PropertyListEncoder().encode(userMod)
            UserDefaults.standard.set(data, forKey: AppUserDefault.login_data.rawValue)
        }
    }
    
    static func getPaymentStatus(st:Int) -> String {
        switch st {
        case 1:
            return "Pending"
        case 2:
            return "Paid"
        case 3:
            return "Cancelled"
        default:
            return "N/A"
        }
    }
    
    static func getPaymentMethod(st:Int) -> String {
        switch st {
        case 1:
            return "COD"
        case 2:
            return "Net Banking"
        default:
            return "N/A"
        }
    }
}


/*
 status: 1.Pending, 2.Driver Assigned, 3. Picked UP, 4.On the way, 5.Delivered, 6.Cancelled
 payment_status: 1.Pending, 2.Paid, 2.Cancelled
 payment_method: 1.COD, 2.Net Banking
 status: 1.Pending, 2.Accepted, 3.Rejected
 */

