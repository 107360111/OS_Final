//
//  UIView+.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit

extension UIView {
    /// 水波紋/漣漪動畫
    func ripple(duration: Double = 3, width: CGFloat = 50) {
        let reLayer = CAReplicatorLayer()
        reLayer.instanceCount = 3
        reLayer.instanceDelay = duration * 0.3
        
        let caLayer = CALayer()
        caLayer.position = CGPoint(x: width, y: width)
        caLayer.bounds = CGRect(x: 0, y: 0, width: width, height: width)
        caLayer.cornerRadius = width * 0.5
        caLayer.transform = CATransform3DMakeScale(0, 0, 1)
        caLayer.backgroundColor = UIColor.pink_F97A8D.cgColor
        
        let animationGroup = CAAnimationGroup()
        animationGroup.duration = duration
        animationGroup.repeatCount = MAXFLOAT
        
        let basicAnimation = CABasicAnimation(keyPath: "transform.scale.xy")
        basicAnimation.fromValue = 0.1
        basicAnimation.toValue = 4
        basicAnimation.duration = duration
        
        // 透明度動畫
        let KFAnimation = CAKeyframeAnimation(keyPath: "opacity")
        KFAnimation.duration = duration
        KFAnimation.values = [1, 0.45, 0]
        KFAnimation.keyTimes = [0, 0.45, 1]
        
        animationGroup.animations = [basicAnimation, KFAnimation]
        
        caLayer.add(animationGroup, forKey: nil)
        reLayer.addSublayer(caLayer)
        layer.addSublayer(reLayer)
    }
    
    func setKillKeyBoardTapGR(tap: Int = 2) {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(killKeyboard))
        tapGR.numberOfTapsRequired = tap
        addGestureRecognizer(tapGR)
    }
    
    func shadow(w: Int, h: Int, opacity: Float, radius: CGFloat, color: UIColor) {
        layer.shadowOffset = CGSize(width: w, height: h)
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowColor = color.cgColor
    }
    
    /// 梯形路徑初始化
    func trapezoid(first: CGPoint, second: CGPoint, third: CGPoint, fourth: CGPoint) {
        let trapezoidPath = UIBezierPath()
        let trapezoidLayer = CAShapeLayer()
        trapezoidPath.move(to: first)
        trapezoidPath.addLine(to: second)
        trapezoidPath.addLine(to: third)
        trapezoidPath.addLine(to: fourth)
        trapezoidPath.close()
        trapezoidLayer.path = trapezoidPath.cgPath
        layer.mask = trapezoidLayer
    }
    
    @objc func killKeyboard() {
        let topVCView = UIApplication.getTopViewController()?.view
        topVCView?.endEditing(true)
    }
}
