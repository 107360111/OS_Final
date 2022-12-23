//
//  ScheduleVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit

class ScheduleVC: NotificationVC {
    @IBOutlet var view_gradient: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    private func componentsInit() {
        viewInit()
    }
    
    private func viewInit() {
        setGradientBackgroundColor(view: view_gradient)
    }
}
