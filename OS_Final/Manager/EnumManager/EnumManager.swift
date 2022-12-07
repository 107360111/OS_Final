//
//  EnumManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation

@objc public enum Titles: Int {
    case reLogin
    
    func TitleString(title: Titles, msg: String = "") -> String {
        switch title {
        case .reLogin:
            return "由於系統更新緣故，需請您重新登入，確保系統正確執行"
        }
    }
}
