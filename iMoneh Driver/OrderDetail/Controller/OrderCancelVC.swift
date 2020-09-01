//
//  OrderCancelVC.swift
//  iMoneh Driver
//
//  Created by Webmaazix on 18/12/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import UIKit

class OrderCancelVC: UIViewController {
    
    @IBOutlet weak var viewBg       : UIView!
    @IBOutlet weak var tblView      : UITableView!
    @IBOutlet weak var txtView      : UITextView!
    @IBOutlet weak var btnReject    : UIButton!
    
    private var cancellationReasons : [OrderCancellationReasonMod] = []
    public var didSelectReason      :((OrderCancellationReasonMod, String) -> ())?
    private var extraComment        : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        addToolBar()
        initialSetup()
        getOrderCancelReason()
    }

}

//MARK:- Private Methods --------------------
extension OrderCancelVC {
    
    private func initialSetup() {
        txtView.delegate = self
        tblView.delegate = self
        tblView.dataSource = self
        viewBg.layer.cornerRadius = 12
        txtView.layer.borderWidth = 1.2
        txtView.layer.cornerRadius = 5
        txtView.layer.borderColor = UIColor.lightGray.cgColor
        btnReject.layer.cornerRadius = 8
        tblView.rowHeight = UITableView.automaticDimension
    }
    
    private func updateViewPosition(_ directionUp: Bool) {
        
        let xPosition = viewBg.frame.origin.x
        let yPosition = directionUp ? viewBg.frame.origin.y - 160 : viewBg.frame.origin.y + 160 // Slide Up - 20px
        
        let width = viewBg.frame.size.width
        let height = viewBg.frame.size.height
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewBg.frame = CGRect(x: xPosition, y: yPosition, width: width, height: height)
        })
        
    }
    
    private func addToolBar() {
        let numberToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        numberToolbar.barStyle = .default
        numberToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelNumberPad)),
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneWithNumberPad))]
        numberToolbar.sizeToFit()
        txtView.inputAccessoryView = numberToolbar
    }
    
    @objc func cancelNumberPad() {
        txtView.resignFirstResponder()
    }
    @objc func doneWithNumberPad() {
        txtView.resignFirstResponder()
    }
}

//MARK:- Action Methods --------------------
extension OrderCancelVC {
    
    @IBAction func didTapDismissVC(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapRejectOrder(_ sender: UIButton) {
        let selectedReasonArr = cancellationReasons.filter{$0.isSelected}
        if let selectedReason = selectedReasonArr.first {
            dismiss(animated: true) {
                self.didSelectReason?(selectedReason, self.extraComment)
            }
        } else {
            BasicUtility.getAlert(view: self, titletop: nil, subtitle: "Please select a reason".localized)
        }
    }
}

//MARK:- Action Methods --------------------load
extension OrderCancelVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cancellationReasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(withIdentifier: "OrderCancelCell", for: indexPath) as? OrderCancelCell else {
            return UITableViewCell()
        }
        cell.loadCell(cancellationReasons[indexPath.row])
        return cell
    }
}

extension OrderCancelVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<cancellationReasons.count {
            if cancellationReasons[i].isSelected {
                cancellationReasons[i].isSelected = false
            }
        }
        cancellationReasons[indexPath.row].isSelected = true
        tblView.reloadData()
    }
}

// MARK:- Ex - API
extension OrderCancelVC {
    private func getOrderCancelReason() {
        let strUrl = APIURLFactory.order_cancellation_reason
        
        guard let req = APIURLFactory.createGetRequestWithPara(strAbs: strUrl, isToken: true, para: [:]) else {
            return
        }
        
        URlSessionWrapper.getDatefromSession(request: req) { (data, err) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    self.jsonParsingOrderList(json: json)
                    
                } catch {
                    BasicUtility.getAlert(view: self, titletop: "Error", subtitle:"Not Able to Parse Json")
                }
            }
            if let err = err {
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:err)
            }
        }
    }
}

// MARK:- Ex - API PARSING METHODS
extension OrderCancelVC {
    private  func jsonParsingOrderList(json:Any) {
        if let jsonTemp = json as? [String: Any]  {
            print("jsonTemp \(jsonTemp)")
            
            //data_order
            guard let data = jsonTemp["data"] as? [[String:Any]] else {
                return
            }
            
            //modelling
            do {
                let dataOrder = try JSONSerialization.data(withJSONObject: data, options:[])
                let decoder = JSONDecoder()
                cancellationReasons = try decoder.decode([OrderCancellationReasonMod].self, from: dataOrder)
                tblView.reloadData()
            } catch let parsingError {
                print("parsingError new order = \(parsingError)")
                BasicUtility.getAlert(view: self, titletop: "Error", subtitle:parsingError.localizedDescription)
            }
        }else {
            URlErrorHandling.checkErrorInResponse(json: json)
        }
    }
}

extension OrderCancelVC: UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        extraComment = textView.text
        updateViewPosition(false)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        updateViewPosition(true)
    }
}
