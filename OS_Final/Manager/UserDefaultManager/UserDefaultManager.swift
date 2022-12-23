//
//  UserDefaultManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import Foundation
class UserDefaultManager {
    
    private enum defaultKeyStr: String {
        case access
        case appVersion = "CFBundleShortVersionString"
        case guestKey = "guestKey"
        case payIn = "payIn"
        case payOut = "payOut"
        case payInCost = "payInCost"
        case payOutCost = "payOutCost"
        case totalCost = "totalCost"
        case userInfo = "UserInfo"
    }
    
    // MARK: -- A --
    static func getAccessKey() -> String {
        let userInfo = getUserInfo()
        return userInfo?.accessKey ?? ""
    }
    
    static func getAppVersion() -> String {
        if let dic = Bundle.main.infoDictionary, let version = dic[defaultKeyStr.appVersion.rawValue] as? String {
            return version
        }
        return ""
    }
    
    // MARK: -- D --
    static func setDeletePayInCost(cost: Int) {
        let newCost: Int = UserDefaultManager.getPayInCost() - cost
        UserDefaults().set(newCost, forKey: defaultKeyStr.payInCost.rawValue)
        UserDefaults().synchronize()
        UserDefaultManager.setTotalCost()
    }
    
    static func setDeletePayOutCost(cost: Int) {
        let newCost: Int = UserDefaultManager.getPayOutCost() - cost
        UserDefaults().set(newCost, forKey: defaultKeyStr.payOutCost.rawValue)
        UserDefaults().synchronize()
        UserDefaultManager.setTotalCost()
    }
    
    // MARK: -- G --
    static func getGuestKey() -> String {
        return getLoginState() ? "" : (UserDefaults().object(forKey: defaultKeyStr.guestKey.rawValue) as? String ?? "")
    }
    
    // MARK: -- L --
    static func getLoginState() -> Bool {
        return (UserDefaults().object(forKey: defaultKeyStr.userInfo.rawValue) != nil)
    }
    
    static func setLogoutUserDefault() {
        
        UIApplication.shared.unregisterForRemoteNotifications()
    }
    
    // MARK: -- Pay In/Out from VC --
    static func setPayinIconFromVC(str: String) {
        UserDefaults().set(str, forKey: defaultKeyStr.payIn.rawValue)
        UserDefaults().synchronize()
    }
    
    static func getPayinIconFromVC() -> String {
        return UserDefaults().object(forKey: defaultKeyStr.payIn.rawValue) as? String ?? ""
    }
    
    static func setPayoutIconFromVC(str: String) {
        UserDefaults().set(str, forKey: defaultKeyStr.payOut.rawValue)
        UserDefaults().synchronize()
    }
    
    static func getPayoutIconFromVC() -> String {
        return UserDefaults().object(forKey: defaultKeyStr.payOut.rawValue) as? String ?? ""
    }
    
    // MARK: -- Pay In/Out cost --
    static func setPayInCost(cost: Int) {
        let payInTotalCost: Int = UserDefaultManager.getPayInCost() + cost
        UserDefaults().set(payInTotalCost, forKey: defaultKeyStr.payInCost.rawValue)
        UserDefaults().synchronize()
        UserDefaultManager.setTotalCost()
    }
    static func getPayInCost() -> Int {
        return UserDefaults().object(forKey: defaultKeyStr.payInCost.rawValue) as? Int ?? 0
    }
    
    static func setPayOutCost(cost: Int) {
        let payOutTotalCost: Int = UserDefaultManager.getPayOutCost() + cost
        UserDefaults().set(payOutTotalCost, forKey: defaultKeyStr.payOutCost.rawValue)
        UserDefaults().synchronize()
        UserDefaultManager.setTotalCost()
    }
    static func getPayOutCost() -> Int {
        return UserDefaults().object(forKey: defaultKeyStr.payOutCost.rawValue) as? Int ?? 0
    }
    
    // MARK: -- T --
    static func setTotalCost() {
        let cost: Int = UserDefaultManager.getPayInCost() - UserDefaultManager.getPayOutCost()
        UserDefaults().set(cost, forKey: defaultKeyStr.totalCost.rawValue)
        UserDefaults().synchronize()
    }
    static func getTotalCost() -> Int {
        return UserDefaults().object(forKey: defaultKeyStr.totalCost.rawValue) as? Int ?? 0
    }
    
    // MARK: -- U --
    static func getUserID() -> String {
        let userInfo = getUserInfo()
        return userInfo?.userID ?? ""
    }
    
    static func getUserInfo() -> UserInfo? {
        guard let data = UserDefaults().object(forKey: defaultKeyStr.userInfo.rawValue) as? Data else {return nil}
        let userInfo = try? JSONDecoder().decode(UserInfo.self, from: data)
        return userInfo
    }
}
