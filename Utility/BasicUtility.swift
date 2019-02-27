//
//  BasicUtility.swift
//  Bleep
//
//  Created by Aditya Kumar on 9/6/18.
//  Copyright © 2018 Webmazix. All rights reserved.
//

import UIKit


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


/*
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
*/


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
    
    static func getMeberSinceInLocalFromUTC(crt: String) -> String{
        
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
}
