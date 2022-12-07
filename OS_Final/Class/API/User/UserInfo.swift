//
//  UserInfo.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation

class UserInfo: Codable {
    let kind: Int?
    let accessKey: String?
    let userID: String?
    var userName: String?
    var userPhoto: String?
    var userEmail: String?
    var gender: Int?
    let accountType: [Int]?
}
