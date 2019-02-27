//
//  RootViewController.swift
//  AKSideMenuStoryboard
//
//  Created by Diogo Autilio on 6/9/16.
//  Copyright © 2016 AnyKey Entertainment. All rights reserved.
//

import UIKit
import AKSideMenu




public class RootViewController: AKSideMenu {

    
    // MARK: - LIFE CYCLE
    override public func awakeFromNib() {
        super.awakeFromNib()
        initMethod()
        if let storyboard = self.storyboard {
            self.contentViewController = storyboard.instantiateViewController(withIdentifier: "contentViewController")
            self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
            //self.rightMenuViewController = storyboard.instantiateViewController(withIdentifier: "rightMenuViewController")
        }
    }
    
    
    
    
    
    
    // MARK: - INIT METHOD
    private func initMethod() {
        
        
        
        self.menuPreferredStatusBarStyle = .lightContent
        self.contentViewShadowColor = .black
        self.contentViewShadowOffset = CGSize(width: 0, height: 0)
        self.contentViewShadowOpacity = 0.6
        self.contentViewShadowRadius = 12
        self.contentViewShadowEnabled = true
        
        self.backgroundImage = UIImage(named: "splash_bg")
        self.delegate = self
    }
    
    deinit {
        print("RootViewController deinit")
    }
}


extension RootViewController:AKSideMenuDelegate {
    
    // MARK: - <AKSideMenuDelegate>
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        let left =  self.leftMenuViewController as! LeftMenuVC
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didShowMenuViewController menuViewController: UIViewController) {
        print("didShowMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, willHideMenuViewController menuViewController: UIViewController) {
        print("willHideMenuViewController")
    }
    
    public func sideMenu(_ sideMenu: AKSideMenu, didHideMenuViewController menuViewController: UIViewController) {
        print("didHideMenuViewController")
    }
    
}
