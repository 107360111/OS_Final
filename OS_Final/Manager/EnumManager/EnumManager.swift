//
//  EnumManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation

@objc public enum Titles: Int {
    case list
    case reLogin
    case writeIn
    
    func TitleString(title: Titles, msg: String = "") -> String {
        switch title {
        case .list:
            return "這是清單"
        case .reLogin:
            return "由於系統更新緣故，需請您重新登入，確保系統正確執行"
        case .writeIn:
            return "這是寫入資料"
        }
    }
}
