//
//  UIButton+animation.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation
import UIKit

extension UIButton {
        
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        super.touchesBegan(touches, with: event)
        if(self.bounds.width < 200) { animateDown() }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if(self.bounds.width < 200) { animateUp() }
    }
    
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(self.bounds.width < 200) { animateUp() }
    }
    
    @objc func animateDown() {
        animate(self, transform: CGAffineTransform.identity.scaledBy(x: 1.2, y: 1.2))
    }
    
    @objc func animateUp() {
        animate(self, transform: .identity)
    }
    
    private func animate(_ button: UIButton, transform: CGAffineTransform) {
        button.transform = transform.scaledBy(x: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.05,
                       delay: 0,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 3,
                       options: [.curveEaseInOut],
                       animations: {
                        button.transform = transform
            }, completion: nil)
    }
    
}
