//
//  Common.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/26.
//

import Foundation
import UIKit

let bundle: Bundle = Bundle(for: HeaderVC.self)
let screenWidth: CGFloat = UIScreen.main.bounds.width
let screenHeight: CGFloat = UIScreen.main.bounds.height
var statusHeight: CGFloat {
    if #available(iOS 13, *) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        return UIApplication.shared.statusBarFrame.height
    }
}

public func imageNamed(_ name:String)-> UIImage{
    guard let image = UIImage(named: name, in: bundle, compatibleWith: nil) else { return UIImage() }
    return image
}
