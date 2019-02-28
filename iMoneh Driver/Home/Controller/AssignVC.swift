//
//  AssignVC.swift
//  iMoneh Driver
//
//  Created by Rakhi on 25/02/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class AssignVC: UIViewController {
    
    @IBOutlet weak var tblv: UITableView!
    
    // MARK:- VC LIFE CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        initMethod()
        setUI()
    }
    
    deinit {
        print("AssignVC deinit")
    }
    
    // MARK: - INIT METHOD
    func initMethod(){
        tblv.estimatedRowHeight = 150
        tblv.rowHeight = UITableView.automaticDimension
        registerCell()
    }
    
    private func registerCell() {
        let nibSt = UINib.init(nibName: "OrderCell", bundle: nil)
        self.tblv.register(nibSt, forCellReuseIdentifier: "OrderCell")
    }
    
    // MARK: - SET UI
    func setUI(){
    }
}

// MARK:- EXT - UITableViewDataSource
extension AssignVC : UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tcell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        
        //orders
        let attbuteHead = [NSAttributedString.Key.font : AppFont.GilroySemiBold.fontSemiBold13!, NSAttributedString.Key.foregroundColor: UIColor.gray]
        let attbuteTitle = [NSAttributedString.Key.font : AppFont.GilroySemiBold.fontSemiBold13!, NSAttributedString.Key.foregroundColor: UIColor.darkText]
        let order = NSMutableAttributedString(string:"Orders #: ", attributes:attbuteHead)
        let order_id = NSMutableAttributedString(string:"34527272", attributes:attbuteTitle)
        order.append(order_id)
        tcell.lblOrder.attributedText = order
        
        //price
        tcell.lblPrice.font = AppFont.GilroySemiBold.fontSemiBold13!
        tcell.lblPrice.textColor = UIColor.darkText
        
        
        //from to
        let from = NSMutableAttributedString(string:"From : ", attributes:attbuteHead)
        let from_add = NSMutableAttributedString(string:"Noida sector 22,Pinnacle Tower\n", attributes:attbuteTitle)
        
        let to = NSMutableAttributedString(string:"To : ", attributes:attbuteHead)
        let to_add = NSMutableAttributedString(string:"Noida sector 62,Pinnacle Tower", attributes:attbuteTitle)
        
        from.append(from_add)
        from.append(to)
        from.append(to_add)
        
        tcell.lblAdd.attributedText = from
        
        
        //delivery date
        let delivery = NSMutableAttributedString(string:"Delivery Date : \n", attributes:attbuteHead)
        let date = NSMutableAttributedString(string:"Feb 21, 2019 | 10 to 13", attributes:attbuteTitle)
        delivery.append(date)
        tcell.lblDeliveryDate.attributedText = delivery
        
        
        //distance
        tcell.lblDistance.font = AppFont.GilroySemiBold.fontSemiBold13!
        tcell.lblDistance.textColor = UIColor.darkText
        
        return tcell
    }
}




