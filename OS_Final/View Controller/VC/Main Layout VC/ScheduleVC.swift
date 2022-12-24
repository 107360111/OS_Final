//
//  ScheduleVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import AVFoundation
import Lottie

class ScheduleVC: NotificationVC {
    @IBOutlet var view_gradient: UIView!
    @IBOutlet var view_main: UIView!
    
    @IBOutlet var label_hint: UILabel!
    
    @IBOutlet var animated_gif: UIView!
    private var animationView = LottieAnimationView()
    
    private var clickOnce: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
        notificationInit()
        beginTextLabelInit()
    }
    
    private func componentsInit() {
        setGradientBackgroundColor(view: view_gradient)
        
        label_hint.isHidden = false
        animated_gif.isHidden = true
        
        view_main.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startScan)))
        animated_gif.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(startScan)))
        
        showLabelText()
    }
    
    private func showLabelText() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .authorized { // 權限同意
            gifInit()
        } else if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == .denied { // 權限不同意
            label_hint.text = ToastMes.ToastString(title: .restartCamera)
            label_hint.textColor = UIColor.red_E64646
            label_hint.textAlignment = .center
            label_hint.font = UIFont.systemFont(ofSize: 20)
        }
    }
    
    func notificationInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleAllow), name: NSNotification.Name("Allow"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotAllow), name: NSNotification.Name("NotAllow"), object: nil)
    }
    
    private func beginTextLabelInit() {
        label_hint.text = ToastMes.ToastString(title: .startCamera)
        label_hint.textColor = UIColor.black
        label_hint.textAlignment = .center
        label_hint.font = UIFont.systemFont(ofSize: 20)
    }
    
    private func gifInit() {
        clickOnce = true
        label_hint.isHidden = true
        animated_gif.isHidden = false
        
        animationView = .init(name: "hand_tap")

        animationView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        animationView.center = self.animated_gif.center
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        
        animated_gif.addSubview(animationView)
        animationView.play()
    }
    
    @objc private func handleAllow() {
        gifInit()
    }
    
    @objc private func handleNotAllow() {
        label_hint.text = ToastMes.ToastString(title: .restartCamera)
        label_hint.textColor = UIColor.red_E64646
        label_hint.textAlignment = .center
        label_hint.font = UIFont.systemFont(ofSize: 20)
    }
    
    @objc private func startScan() {
        if AuthorizationManager.checkCameraPermission(clickedOnce: clickOnce) {
            print("有開啟相機")
        } else {
            print("沒有開啟相機")
        }
    }
}
