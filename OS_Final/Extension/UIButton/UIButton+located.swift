//
//  UIButton+located.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit

extension UIButton {
    
    override open func awakeFromNib() {
        guard let nibStr = self.titleLabel?.text else { return }
        self.setTitle( nibStr, for: .normal)
    }
    
    @IBInspectable var adjustsFontSize: Bool {
        get {
            return self.titleLabel?.adjustsFontSizeToFitWidth ?? false
        } set {
            self.titleLabel?.adjustsFontSizeToFitWidth = newValue
        }
    }
    
    @IBInspectable var minimumScale: Double {
        get {
            return Double(self.titleLabel?.minimumScaleFactor ?? 0)
        } set {
            self.titleLabel?.minimumScaleFactor = CGFloat(newValue)
        }
    }
    
    @IBInspectable var breakMode: Int {
        get {
            return Int(self.titleLabel?.lineBreakMode.rawValue ?? 0)
        } set {
            self.titleLabel?.lineBreakMode = NSLineBreakMode(rawValue: Int(newValue)) ?? .byWordWrapping
        }
    }
}

