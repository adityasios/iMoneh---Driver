//
//  MyProfileVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 27/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class MyProfileVC: UIViewController {
    
    @IBOutlet weak var viewHead: UIView!
    @IBOutlet weak var imgVPro: UIImageView!
    @IBOutlet weak var imgVCar: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblGender: UILabel!
    @IBOutlet weak var lblModel: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblNoDeliveries: UILabel!
    @IBOutlet weak var lblNoRejected: UILabel!
    
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    deinit {
        print("MyProfileVC deinit")
    }
    
    // MARK: - INIT METHOD
    func initMethod(){
        title = "Profile"
    }
    
    // MARK: - SET UI
    func setUI(){
        
        //view
        viewHead.layer.cornerRadius = 4
        viewHead.clipsToBounds = true
        
        //profile
        imgVPro.layer.cornerRadius = (AppDevice.ScreenSize.SCREEN_HEIGHT * 0.25)/4
        imgVPro.clipsToBounds = true
        
        //vehicle
        imgVCar.layer.cornerRadius = (AppDevice.ScreenSize.SCREEN_HEIGHT * 0.25)/4
        imgVCar.clipsToBounds = true
    }
}


