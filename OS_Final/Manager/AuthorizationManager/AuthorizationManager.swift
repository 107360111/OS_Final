//
//  AuthorizationManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/23.
//

import Foundation
import AVFoundation

class AuthorizationManager {
    public typealias CompletedHandler = (Bool) -> Void
    static var onceClickedAllow: Bool = false
    /// 確認相機權限
    /// - Returns: 是否已獲得權限
    static func checkCameraPermission(clickedOnce: Bool) -> Bool {
        let camStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video) //相機請求
        switch (camStatus){ //判斷狀態
        case .authorized: // 允許
            if !clickedOnce {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Allow"), object: nil)
            }
            return true
            
        case .denied:
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotAllow"), object: nil)
            
        case .notDetermined: // 還未決定,就請求授權
            AVCaptureDevice.requestAccess(for: AVMediaType.video,  completionHandler: { (status) in
                DispatchQueue.main.async(execute: {
                    _ = self.checkCameraPermission(clickedOnce: false)
                })
            })
        default: // 預設，如都不是以上狀態
            return false
        }
        return false
    }
}
