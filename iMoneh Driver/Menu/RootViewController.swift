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
            switch Language.language {
            case .english :
                self.leftMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
                self.rightMenuViewController = nil
            case .arabic :
                self.rightMenuViewController = storyboard.instantiateViewController(withIdentifier: "leftMenuViewController")
                self.leftMenuViewController = nil
            }
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

// MARK: Ex - <AKSideMenuDelegate>
extension RootViewController:AKSideMenuDelegate {
    public func sideMenu(_ sideMenu: AKSideMenu, willShowMenuViewController menuViewController: UIViewController) {
        switch Language.language {
        case .english :
            let left =  self.leftMenuViewController as! LeftMenuVC
            ProjectHelper.setProfileImage(imgV: left.imgVProfile)
        case .arabic :
            let left =  self.rightMenuViewController as! LeftMenuVC
            ProjectHelper.setProfileImage(imgV: left.imgVProfile)
        }
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
