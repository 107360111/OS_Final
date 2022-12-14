//
//  DateManager.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/10.
//

import Foundation

class DateManager {
    static let dateFormatter = DateFormatter()
    
    // MARK: -- C --
    /// 取得當前時間(YYYY/MM/dd)
    static func currentDate() -> String {
        let date = Date()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        return dateFormatter.string(from: date)
    }
    
    // MARK: -- D --
    static func dateToString(date: Date) -> String {
        dateFormatter.dateFormat = "YYYY/MM/dd"
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        return dateFormatter.string(from: date)
    }
    // MARK: -- F --
    /// 取得當月第一天日期是星期幾
    static func firstWeekday(date: Date) -> Int {
        var components: DateComponents = Calendar.current.dateComponents([.year, .month], from: date)
        guard let firstDate = Calendar.current.date(from: components) else { return 0 }
        components = Calendar.current.dateComponents([.weekday], from: firstDate)
        guard var weekday = components.weekday else { return 0 }
        /// 1 ~ 7 範圍 星期(日) 至 (六)   順序更動  (一) 至 (日)  2 ~ 8
        weekday = weekday == 1 ? 8 : weekday
        return weekday - 2
    }
}
