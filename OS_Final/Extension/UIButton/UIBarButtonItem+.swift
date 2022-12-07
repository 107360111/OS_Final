//
//  UIBarButtonItem+.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation
import UIKit

extension UIBarButtonItem {
    
    convenience init(frame: CGRect, imgName: String, target: Any?, action: Selector) {
        let btn = UIButton(frame: frame)
        btn.addTarget(target, action: action, for: .touchUpInside)
        btn.setImage(UIImage(named: imgName), for: .normal)
        let barView = UIView(frame: frame)
        barView.addSubview(btn)
        self.init(customView: barView)
    }
    
    convenience init(title: String, titleColor: UIColor = .black, borderColor: UIColor = .clear, target: Any?, action: Selector) {
        let btn = UIButton(type: .custom)
        btn.setTitle(title, for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(.lightGray, for: .highlighted)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = borderColor.cgColor
        btn.layer.cornerRadius = 5
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
    
    /// 用於朋友圈 朋友 / 私人 切換Bar
    convenience init(imgName: String, titleColor: UIColor = .black, borderColor: UIColor = .clear, target: Any?, action: Selector) {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named: imgName)?.resizeImage(targetSize: CGSize(width: 21, height: 21)).tint(with: .blue_468EE6), for: .normal)
        btn.setTitle("▼", for: .normal)
        btn.setTitleColor(titleColor, for: .normal)
        btn.setTitleColor(.lightGray, for: .highlighted)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        btn.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 5)
        btn.layer.borderWidth = 1
        btn.layer.borderColor = borderColor.cgColor
        btn.layer.cornerRadius = 10
        btn.addTarget(target, action: action, for: .touchUpInside)
        self.init(customView: btn)
    }
}
