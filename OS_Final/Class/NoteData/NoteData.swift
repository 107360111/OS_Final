//
//  NoteData.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/19.
//
import UIKit
import RealmSwift

@objcMembers class noteData: Object {
    dynamic var id_key: String = UUID().uuidString
    
    dynamic var date: String = ""
    dynamic var ways: String = ""
    dynamic var type: String = ""
    dynamic var cost: Int64 = 0
    dynamic var detail: String = ""

    override class func primaryKey() -> String {
        return "id_key"
    }
}
