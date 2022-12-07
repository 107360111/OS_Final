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
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deinitNavigationItems()
    }
    
    private func navigationBarInit() {
        setNavigationBar()
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
    
    @objc private func backBarItemClick() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
