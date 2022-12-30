//
//  UserDefaultManager+CostType.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/30.
//

import UIKit
import Foundation

extension UserDefaultManager {   
    public enum setCostType {
        case set
        case delete
    }
    public enum costWay {
        case payIn
        case payOut
    }

    /// 設定分類個別價錢
    static func setCost(cost: Int, type: String, costType: setCostType) {
        var declineCost: Int = 0
        switch costType {
        case .set:
            declineCost = cost
        case .delete:
            declineCost = -cost
        }
        UserDefaults().set(UserDefaultManager.showCost(type: type) + declineCost, forKey: type)
        UserDefaults().synchronize()
    }
    
    /// 得到分類個別價錢
    static func showCost(type: String) -> Int {
        return UserDefaults().object(forKey: type) as? Int ?? 0
    }
    
    /// 收入、支出總和
    static func getTotalCost(costWay: costWay) -> Int {
        var totalCost: Int = 0
        var array = [String()]
        switch costWay {
        case .payIn:
            array = locatedManager.array_payInURL
        case .payOut:
            array = locatedManager.array_payOutURL
            array.append("cloud") // 主要是QR code掃描不在locatedManager矩陣中，所以得另外加上
        }
        for type in array {
            totalCost += UserDefaultManager.showCost(type: type)
        }
        return totalCost
    }
}
