//
//  RealmManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/19.
//

import RealmSwift

class RealmManager {
    
    static func saveData(date: String, ways: String, type: String, cost: Int64, detail: String) {
        let realm = try? Realm()
        let APISaveData = noteData()

        APISaveData.date = date
        APISaveData.ways = ways
        APISaveData.type = type
        APISaveData.cost = cost
        APISaveData.detail = detail
        
        try? realm?.write {
            realm?.add(APISaveData)
        }
    }
    
    static func getData() -> Results<noteData>? {
        let realm = try? Realm()
        let APISaveData = realm?.objects(noteData.self)
        return APISaveData
    }
}
