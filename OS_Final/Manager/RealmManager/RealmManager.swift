//
//  RealmManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/19.
//

import RealmSwift

class RealmManager {
    
    static func saveData(data: noteData, isScan: Bool = false) {
        let realm = try? Realm()
        let saveData = noteData()

        saveData.date = data.date
        saveData.ways = data.ways
        saveData.type = data.type
        saveData.cost = data.cost
        saveData.detail = data.detail
        saveData.isScan = data.isScan
        
        try? realm?.write {
            realm?.add(saveData)
        }
    }
    
    static func updateData(data: noteData) {
        let realm = try? Realm()
        
        try? realm?.write {
            realm?.add(data, update: .modified)
        }
    }
    
    static func deleteData(data: noteData) {
        let predicate = NSPredicate(format: "id_key = %@", data.id_key)
        let realm = try? Realm()
        guard let deleteData = realm?.objects(noteData.self).filter(predicate).first else { return }
        try? realm?.write {
            realm?.delete(deleteData)
        }
    }
    
    static func deleteAllData() {
        let realm = try? Realm()
        
        try? realm?.write {
            realm?.deleteAll()
        }
    }
    
    static func getData() -> Results<noteData>? {
        let realm = try? Realm()
        return realm?.objects(noteData.self)
    }
}
