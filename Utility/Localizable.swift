//
//  String+Localizable.swift
//  Localizable
//
//  Created by Roman Sorochak <roman.sorochak@gmail.com> on 6/23/17.
//  Copyright © 2017 MagicLab. All rights reserved.
//

import UIKit

//MARK: - properties


//MARK: - Enum - Language
enum Language: String {
    
    //cases
    case english = "en"
    case arabic = "ar"
    
    //compound properties
    var semantic: UISemanticContentAttribute {
        switch self {
        case .english:
            return .forceLeftToRight
        case .arabic:
            return .forceRightToLeft
        }
    }
    
    static var language: Language {
        get {
            if let arrcode = UserDefaults.standard.stringArray(forKey: AppUserDefault.appleLanguagesKey.rawValue),let lang = arrcode.first,let language = Language(rawValue: lang){
                print("get userDefault - language \(language)")
                return language
            } else {
                let preferredLanguage = NSLocale.preferredLanguages[0] as String
                let index = preferredLanguage.index(preferredLanguage.startIndex,offsetBy: 2)
                guard let localization = Language(rawValue: preferredLanguage.substring(to: index)) else {
                    return Language.english
                }
                print("get preferredLanguage \(localization)")
                return localization
            }
        }
        
        set {
            print("set - newValue \(newValue)")
            guard language != newValue else {
                return
            }
            
            print("[newValue.rawValue] set \([newValue.rawValue])")
            //change language in the app
            //the language will be changed after restart
            UserDefaults.standard.removeObject(forKey: AppUserDefault.appleLanguagesKey.rawValue)
            UserDefaults.standard.set([newValue.rawValue], forKey: AppUserDefault.appleLanguagesKey.rawValue)
            UserDefaults.standard.synchronize()
            
            //Changes semantic to all views
            //this hack needs in case of languages with different semantics: leftToRight(en/uk) & rightToLeft(ar)
            UIView.appearance().semanticContentAttribute = newValue.semantic
            
            let arrcode = UserDefaults.standard.stringArray(forKey: AppUserDefault.appleLanguagesKey.rawValue)
            print("arrcode set \(arrcode ?? [])")
            
            //initialize the app from scratch
            //show initial view controller
            //so it seems like the is restarted
            //NOTE: do not localize storboards
            //After the app restart all labels/images will be set
            //see extension String below
            
            let story = UIStoryboard.init(name: "Menu", bundle: nil)
            let root = story.instantiateViewController(withIdentifier: "rootController") as! RootViewController
            let appDel: AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDel.window!.rootViewController = root
        }
    }
}



extension String {
    
    var localized: String {
        return Bundle.localizedBundle.localizedString(forKey: self, value: nil, table: nil)
    }
    
    var localizedImage: UIImage? {
        return localizedImage()
            ?? localizedImage(type: ".png")
            ?? localizedImage(type: ".jpg")
            ?? localizedImage(type: ".jpeg")
            ?? UIImage(named: self)
    }
    
    private func localizedImage(type: String = "") -> UIImage? {
        guard let imagePath = Bundle.localizedBundle.path(forResource: self, ofType: type) else {
            return nil
        }
        return UIImage(contentsOfFile: imagePath)
    }
}

extension Bundle {
    //Here magic happens
    //when you localize resources: for instance Localizable.strings, images
    //it creates different bundles
    //we take appropriate bundle according to language
    static var localizedBundle: Bundle {
        let languageCode = Language.language.rawValue
        guard let path = Bundle.main.path(forResource: languageCode, ofType: "lproj") else {
            return Bundle.main
        }
        return Bundle(path: path)!
    }
}


