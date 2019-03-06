//
//  Validation.swift
//  iMonehMarket
//
//  Created by Rakhi on 15/01/19.
//  Copyright © 2019 Webmaazix. All rights reserved.
//

import Foundation
import UIKit

struct Validation {
    static  func removeWhiteSpaceAndNewLine(strTemp: String) -> String{
        return strTemp.trimmingCharacters(in:.whitespacesAndNewlines)
    }

    static func removeDoubleSpace(_ str: String) -> String {
        var str = str
        while Int((str as NSString?)?.range(of: "  ").location ?? 0) != NSNotFound {
            str = str.replacingOccurrences(of: "  ", with: " ")
        }
        return str
    }

    static func isValidEmail(strEmail:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: strEmail)
    }
}


