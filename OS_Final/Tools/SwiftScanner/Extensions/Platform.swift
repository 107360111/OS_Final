//
//  Platform.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/26.
//

import Foundation

struct Platform {
    static let isSimulator: Bool = {
        #if swift(>=4.1)
          #if targetEnvironment(simulator)
            return true
          #else
            return false
          #endif
        #else
          #if (arch(i386) || arch(x86_64)) && os(iOS)
            return true
          #else
            return false
          #endif
        #endif
    }()
}
