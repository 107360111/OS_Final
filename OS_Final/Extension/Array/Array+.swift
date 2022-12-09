//
//  Array+.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/9.
//

import Foundation

extension Array {
    func getObject(at index: Int) -> Element? {
        return index >= 0 && index < count ? self[index] : nil
    }
}
