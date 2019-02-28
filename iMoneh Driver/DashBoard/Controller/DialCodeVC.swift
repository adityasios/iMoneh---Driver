//
//  DialCodeVC.swift
//  iMonehMarket
//
//  Created by Rakhi on 28/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

protocol DialCodeVCDelegate : class {
    func dialCodeSelected(countMod: CountryMod)
}

class DialCodeVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    
    var crt_dial_code : String = ""
    var arr_Pass : [CountryMod] = []
    weak var delegate: DialCodeVCDelegate?
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    // MARK:- INIT METHOD
    func initMethod() {
    }
    
    // MARK:- SET UI METHOD
    func setUI() {
        view.backgroundColor =  appTrans
    }
    
    // MARK:- BUTTON ACTION
    @IBAction func btnCrossClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}


// MARK:- Ext-TABLEV VIEW DATASOURCE
extension DialCodeVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr_Pass.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tcell = tableView.dequeueReusableCell(withIdentifier: "cellctry", for: indexPath)
        let ctryMod = arr_Pass[indexPath.row]
        
        let imgV = tcell.viewWithTag(10) as! UIImageView
        imgV.layer.cornerRadius = 2
        imgV.clipsToBounds = true
        let lblDC = tcell.viewWithTag(20) as! UILabel
        let lblCtry = tcell.viewWithTag(30) as! UILabel
        
        lblDC.text = ctryMod.dial_code
        lblCtry.text = ctryMod.country_name
        if  let flagimg =  ctryMod.flag_image,let urlimg = URL.init(string: APIURLFactory.country_flag + flagimg) {
            imgV.sd_setImage(with: urlimg, completed: nil)
        }
        
        //acessory check mark
        tcell.tintColor = appDarkYellow
        if ctryMod.dial_code ==  crt_dial_code{
            tcell.accessoryType = .checkmark
        }else{
            tcell.accessoryType = .none
        }
        
        return tcell
    }
}

// MARK:- Ext-TABLEV VIEW DELEGATE
extension DialCodeVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let ctryMod = arr_Pass[indexPath.row]
        delegate?.dialCodeSelected(countMod: ctryMod)
        dismiss(animated: true, completion: nil)
    }
}


