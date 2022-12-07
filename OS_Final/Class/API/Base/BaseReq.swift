//
//  BaseReq.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation

class BaseReq: Encodable {
    let guestKey = UserDefaultManager.getGuestKey()
    let accessKey = UserDefaultManager.getAccessKey()
    let userID = UserDefaultManager.getUserID()
    let appVersion = UserDefaultManager.getAppVersion()
}
