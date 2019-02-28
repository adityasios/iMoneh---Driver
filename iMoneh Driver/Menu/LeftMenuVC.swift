//
//  LeftMenuVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 25/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit
import AKSideMenu



class LeftMenuVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var imgVProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var tblv: UITableView!
    
    let menuArray = ["Home","My Profile","Notifications" ,"Ratings & Reviews", "Help", "Share","Log Out"]
    
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
    func initMethod(){
    }
    
    // MARK: - SET UI
    func setUI(){
        //profile_image
        imgVProfile.backgroundColor = appTrans
        imgVProfile.layer.borderColor = appDarkYellow?.cgColor
        imgVProfile.layer.borderWidth = 2
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
        case 6:
            let story = UIStoryboard.init(name: "Main", bundle: nil)
            let root = story.instantiateViewController(withIdentifier: "ViewController") as! ViewController
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window!.rootViewController = root
        default:
            break
        }
    }
}








