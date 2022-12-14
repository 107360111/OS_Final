//
//  NotificationVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit

class NotificationVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationBarInit()
        notificationsInit()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deinitNavigationItems()
        deinitNotifications()
    }

    /// 鍵盤升起
    func KeyboardWillShow(duration: Double, height: CGFloat) {
    }
    
    /// 鍵盤下降
    func KeyboardWillHide(duration: Double) {
    }
    
    private func navigationBarInit() {
        setNavigationBar()
    }
    
    func notificationsInit() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowReceiver), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideReceiver), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        let backButton = setBackBarItem()
        backButton.addTarget(self, action: #selector(backBarItemClick), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        navigationItem.backBarButtonItem?.title = ""
        navigationItem.backBarButtonItem?.tintColor = .black
    }
    
    private func deinitNavigationItems() {
        navigationItem.leftBarButtonItem = nil
        navigationItem.rightBarButtonItem = nil
    }
    
    private func deinitNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    /// 設定漸層顏色狀態欄
    func setGradientStatusBar() {
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.blue_4A8FE1]
        
        // change backbutton color
        navigationController?.navigationBar.tintColor = .black
        // Remove back title
        navigationItem.backBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: nil, action: nil)
        
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 100)
        
        view.layer.insertSublayer(gradient, at: 0)
        let isRootVC: Bool = (navigationController?.viewControllers.last is ViewController)
        navigationController?.setNavigationBarHidden(isRootVC, animated: false)
    }
    
    func setGradientBackgroundColor(view: UIView) {
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [UIColor.blue_A8CEFA.cgColor, UIColor.blue_AAC1DC.cgColor]
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: view.bounds.size.height)
        view.layer.insertSublayer(gradient, at: 0)
        view.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    @objc fileprivate func keyboardWillShowReceiver(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardFrame = userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double, let size = keyboardFrame?.cgRectValue else { return }
        KeyboardWillShow(duration: duration, height: size.height)
    }
    
    @objc fileprivate func keyboardWillHideReceiver(notification: NSNotification) {
        let userInfo = notification.userInfo
        guard let duration = userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        KeyboardWillHide(duration: duration)
    }
    
    @objc private func backBarItemClick() {
        navigationController?.popViewController(animated: true)
    }
}
