//
//  SettingsLauncher.swift
//  youtube
//
//  Created by Karthik on 03/09/18.
//  Copyright © 2018 Karthik. All rights reserved.
//

import UIKit

enum SettingType: String {
    case cancel = "Cancel"
    case settings = "Settings"
    case privacy = "Terms and Privacy policy"
    case feedback = "Feedback"
    case help = "Help"
    case switchAccount = "Switch Account"
    
    var imageName: String {
        switch self {
        case .cancel:
            return "cancel"
        case .settings:
            return "settings"
        case .privacy:
            return "privacy"
        case .feedback:
            return "feedback"
        case .help:
            return "help"
        case .switchAccount:
            return "switch_account"
        }
    }
    
    var description: String {
        return self.rawValue
    }
    
}

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    let blackView = UIView()
    
    let cellId = "cellId"
    
    let cellHeight: CGFloat = 50
    
    var homeController: HomeController?
    
    let settings: [SettingType] = {
        return [SettingType.settings,
                SettingType.privacy,
                SettingType.feedback,
                SettingType.help,
                SettingType.switchAccount,
                SettingType.cancel]
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    

    @objc func showSettings() {
        // show more
        
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            window.addSubview(blackView)
            window.addSubview(collectionView)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(blackViewTapped)))
            
            blackView.frame = window.frame
            blackView.alpha = 0.0
            
            let height = CGFloat(settings.count) * cellHeight
            let y = window.frame.height - height
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1.0
                
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
        }
        
    }
    
    @objc
    func blackViewTapped() {
        handleDismiss(setting: nil)
    }
    
    func handleDismiss(setting: SettingType?) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0.0
            
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed) in
            if let setting = setting, setting != .cancel {
                self.homeController?.showController(for: setting)
            }
        }
    }
    
    @objc func handleSearch() {
        
    }
    
    override init() {
        super.init()
        
        collectionView.register(SettingsCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsCell
        let setting = settings[indexPath.item]
        cell.setting = setting
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let setting = self.settings[indexPath.item]
        handleDismiss(setting: setting)
    }
    
}
