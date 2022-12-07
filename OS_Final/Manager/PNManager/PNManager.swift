//
//  PNManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import Foundation

class PNManager {
    
    static func jsonStrDecoder(jsonStr: String) -> [String: Any]? {
        guard let jsonData = jsonStr.data(using: .utf8) else { return nil }
        do {
            let jsonDic = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            return jsonDic
        } catch {
            print("JSONSerialization error")
            return nil
        }
    }
    
    static func navigationToRootVC(rootPage: Int = -1, delayTime: Double = 0.0, animate: Bool = false) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            // 滾動首頁
            if let rootVC = UIApplication.getRootViewController() as? ViewController {
                if (0...4).contains(rootPage) {
                    rootVC.scroll(to: rootPage, animated: animate)
                }
                // 指定VC 替換當前的顯示視圖
                rootVC.navigationController?.setViewControllers([rootVC], animated: animate)
            }
        }
    }
    
    /// 跳轉到指定頁面，並設定首頁是哪一個頁面
    static func navigation(toVC VC: UIViewController, rootPage: Int = -1, delayTime: Double = 0.0) {
        // 延遲，等待一下頁面載入
        DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
            // 滾動首頁
            if let rootVC = UIApplication.getRootViewController() as? ViewController {
                if (0...4).contains(rootPage) {
                    rootVC.scroll(to: rootPage, animated: false)
                }
                rootVC.navigationController?.setViewControllers([rootVC, VC], animated: false)
            }
        }
    }
}
