//
//  LeftMenuVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 25/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import AKSideMenu
import ZDCChat

class LeftMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgVProfile: UIImageView!
    @IBOutlet weak var imgVStatus: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblOnline: UILabel!
    @IBOutlet weak var lblLang: UILabel!
    @IBOutlet weak var tblv: UITableView!
    
    let menuArray = ["Home".localized,"My Profile".localized,"Notifications".localized ,"Ratings & Reviews".localized, "Help".localized, "Share".localized,"Chat".localized,"Log Out".localized]
    
    // MARK: - VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    deinit {
        print("LeftMenuVC deinit")
    }
    
    // MARK: - INIT METHOD
    private func initMethod(){
    }
    
    // MARK: - SET UI
    private func setUI(){
        lblLang.text = "Lang".localized
        
        //profile_image
        imgVProfile.backgroundColor = appTrans
        imgVProfile.layer.borderColor = appDarkYellow?.cgColor
        imgVProfile.layer.borderWidth = 2
        //name
        lblName.text = Singleton.shared.userMod?.name
        lblOnline.text = (Singleton.shared.userMod?.is_online == 1) ? "Online".localized : "Offline".localized
        imgVStatus.image = (Singleton.shared.userMod?.is_online == 1) ? UIImage.init(named: "online") : UIImage.init(named: "offline")
    }

    // MARK: - TABLEVIEW DATASOURCE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tcell = tableView.dequeueReusableCell(withIdentifier: "cellleft", for: indexPath)
        let lblTitle = tcell.viewWithTag(10) as! UILabel
        lblTitle.text = menuArray[indexPath.row]
        return tcell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let story = UIStoryboard.init(name: "Menu", bundle: nil)
            let nav = story.instantiateViewController(withIdentifier: "contentViewController")
            self.sideMenuViewController?.setContentViewController(nav, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case 1:
            let story = UIStoryboard.init(name: "MenuItems", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "MyProfileVC")
            let nav = UINavigationController.init(rootViewController: vc)
            self.sideMenuViewController?.setContentViewController(nav, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case 2:
            let story = UIStoryboard.init(name: "MenuItems", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "NotVC") as! NotVC
            let nav = UINavigationController.init(rootViewController: vc)
            self.sideMenuViewController?.setContentViewController(nav, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case 3:
            let story = UIStoryboard.init(name: "MenuItems", bundle: nil)
            let vc = story.instantiateViewController(withIdentifier: "RatingVC") as! RatingVC
            let nav = UINavigationController.init(rootViewController: vc)
            self.sideMenuViewController?.setContentViewController(nav, animated: true)
            self.sideMenuViewController!.hideMenuViewController()
        case 4:
            let story = UIStoryboard.init(name: "Help", bundle: Bundle.main)
            let vc = story.instantiateViewController(withIdentifier: "HelpVC") as! HelpVC
            let nav = UINavigationController.init(rootViewController: vc)
            self.sideMenuViewController?.setContentViewController(nav, animated: true)
            self.sideMenuViewController?.hideMenuViewController()
        case 5:
            let story = UIStoryboard.init(name: "Help", bundle: Bundle.main)
            let vc = story.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
            let nav = UINavigationController.init(rootViewController: vc)
            self.sideMenuViewController?.setContentViewController(nav, animated: true)
            self.sideMenuViewController?.hideMenuViewController()
        case 6:
            ZDCChat.start(in: self.navigationController, withConfig: nil)
        case 7:
            logoutCall()
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let root = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window!.rootViewController = root
        default:
            break
        }
    }
    
    private func logoutCall(){
        if let arrcode = UserDefaults.standard.stringArray(forKey: AppUserDefault.appleLanguagesKey.rawValue),let lang = arrcode.first{
            BasicUtility.removeAllUserDefault()
            UserDefaults.standard.set([lang], forKey: AppUserDefault.appleLanguagesKey.rawValue)
        }else{
            BasicUtility.removeAllUserDefault()
        }
        Singleton.shared.img_profile = nil
    }
    
    // MARK: - BTN ACTION
    @IBAction func btnStatusChangeClicked(_ sender: UIButton) {
        let text =  (Singleton.shared.userMod?.is_online == 1) ? "Offline".localized : "Online".localized
        let st = (Singleton.shared.userMod?.is_online == 1) ? 0 : 1
        let alert = UIAlertController(title: "Update Status".localized, message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: text, style: .default , handler:{ (UIAlertAction) in
            self.changeOnlineStatus(status: st)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel, handler:{ (UIAlertAction) in
        }))
        self.present(alert, animated: true, completion: {
        })
    }
    
    @IBAction func btnLanguageClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Change Language".localized, message:"Please Select Language".localized , preferredStyle: .actionSheet)
        let engbtn = UIAlertAction(title: "English".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if Language.language == .english {
                self.sideMenuViewController!.hideMenuViewController()
            }else{
                Language.language = .english
            }
        })
        let arbtn = UIAlertAction(title: "Arabic".localized, style: .default, handler: {(_ action: UIAlertAction) -> Void in
            if Language.language == .arabic {
                self.sideMenuViewController!.hideMenuViewController()
            }else{
                Language.language = .arabic
            }
        })
        let canbtn = UIAlertAction(title: "Cancel".localized, style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
        })
        alert.addAction(engbtn)
        alert.addAction(arbtn)
        alert.addAction(canbtn)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK:- Ex - API PARSING METHODS
extension LeftMenuVC {
    private func changeOnlineStatus(status:Int) {
        let paraDict = [Parameters.status:String(status)]
        //url
        let strUrl = APIURLFactory.driver_online
        guard let req = APIURLFactory.createPostRequestWithPara(strAbs: strUrl, isToken: true, para: paraDict) else {
            print("invalid request for  \(strUrl)")
            return
        }
        
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingOnlineStatus(json: json, status: status)
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
    
    private func jsonParsingOnlineStatus(json:Any,status:Int) {
        if let json_tmp = json as? [String: Any]  {
            guard let _ = json_tmp["msg"] as? String else {
                return
            }
            Singleton.shared.userMod?.is_online = status
            ProjectHelper.saveUserModel(userMod: Singleton.shared.userMod!)
            setUI()
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}




/*
 Change Online Status
 driver/change/online/status
 POST
 Yes
 status: 1
 */








