//
//  UIViewController+Extensions.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/26.
//

import UIKit

extension UIViewController {
    public func add(_ childController: UIViewController) {
        
        childController.willMove(toParent: self)
        
        addChild(childController)
        
        view.addSubview(childController.view)
        
        childController.didMove(toParent: self)
        
    }
}
