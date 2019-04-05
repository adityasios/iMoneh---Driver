//
//  CityAreaVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 30/03/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

// MARK:- Protocol - DialCodeVCDelegate
protocol LocVCDelegate : class {
    func locModSelected(locMod: LocMod,isCity:Bool)
}

class CityAreaVC: UIViewController {
    
    var arr_city : [LocMod] = []
    var mod_city : LocMod?
    var strTitle : String?
    var isCity : Bool = true
    weak var delegate: LocVCDelegate?
    
    // MARK:- Outlets
    @IBOutlet weak var tblv: UITableView!
    @IBOutlet weak var lblHeder: UILabel!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeder.text =  strTitle
        tblv.tintColor =  appYellow
    }
    
    // MARK: - BUTTON ACTION
    @IBAction func btnCloseClicked(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: extension - UITableViewDataSource
extension CityAreaVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_city.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mod = arr_city[indexPath.row]
        let tcell = tableView.dequeueReusableCell(withIdentifier: "cellloc", for: indexPath)
        let lblName = tcell.viewWithTag(10) as! UILabel
        lblName.text =   isCity ?  mod.city_name :  mod.area_name
        //accessory check mark
        if let city_code = mod_city,city_code.id ==  mod.id! {
            tcell.accessoryType = .checkmark
        }else{
            tcell.accessoryType = .none
        }
        return tcell
    }
}

// MARK:- TABLEV VIEW DELEGATE
extension CityAreaVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let locMod = arr_city[indexPath.row]
        delegate?.locModSelected(locMod: locMod, isCity: isCity)
        dismiss(animated: true, completion: nil)
    }
}

