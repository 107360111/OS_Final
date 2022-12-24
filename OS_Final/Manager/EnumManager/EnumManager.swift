//
//  EnumManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation

@objc public enum Titles: Int {
    case check
    case list
    case reLogin
    case none
    case writeIn
    
    func TitleString(title: Titles, msg: String = "") -> String {
        switch title {
        case .check:
            return "確認資料"
        case .list:
            return "帳單內容"
        case .reLogin:
            return "由於系統更新緣故，需請您重新登入，確保系統正確執行"
        case .none:
            return ""
        case .writeIn:
            return "這是寫入資料"
        }
    }
}

@objc public enum ToastMessages: Int {
    case canDelete
    case canAssign
    case canUpdate
    case inputCost
    case none
    case restartCamera
    case startCamera
    
    func ToastString(title: ToastMessages) -> String {
        switch title {
        case .canAssign:
            return "登記成功"
        case .canDelete:
            return "已順利刪除"
        case .canUpdate:
            return "修改成功"
        case .inputCost:
            return "請輸入金額"
        case .none:
            return ""
        case .restartCamera:
            return "您的相機權限已關閉\n請到系統再次開啟"
        case .startCamera:
            return "點擊以要求相機權限"
        }
    }
}
