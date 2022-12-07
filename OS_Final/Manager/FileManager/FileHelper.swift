//
//  FileHelper.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation

/// FileHelper 檔案管理器 （不取名為filemanager是因為原生的類別有取過這個名字了）

class FileHelper {
    
    /// 取得檔案存取的資料夾路徑
    static func getDocumentsDirectory() -> URL? {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths.first
    }
    
    /// 檢查檔案是否存在
    static func checkAudioFileExist(fileName: String) -> Bool {
        
        guard let path = self.getDocumentsDirectory()?.appendingPathComponent(fileName).path else { return false }
        return FileManager.default.fileExists(atPath: path)
    }
        
}
