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
    
    let menuArray = ["Home","Notifications","Order History" ,"Help", "Share", "Market Info","Market Bid List"]
    
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
        
        //name
        if let en_name = Singleton.shared.userMod?.enName {
            lblName.text = en_name
        }else{
            lblName.text = " - "
        }
        
        //profile_image
        imgVProfile.backgroundColor = appTrans
        imgVProfile.layer.borderColor = appDarkYellow?.cgColor
        imgVProfile.layer.borderWidth = 1
        
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
        default:
            break
        }
    }
}




