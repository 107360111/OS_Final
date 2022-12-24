//
//  SwiftHeader.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import Foundation

// MARK: -- A --

let AppWidth: CGFloat = UIScreen.main.bounds.width
let AppHeight: CGFloat = UIScreen.main.bounds.height
let LongTime: Double = 0.5
let ShortTime: Double = 0.3
let ToastMes: ToastMessages = .none

// MARK: -- C --

/// 視窗水平按鍵是否需要換行
func isChangeView(positiveText: String = "確認", negativeText: String = "取消", textSize: CGFloat = 18, side: CGFloat = 30) -> Bool {
    let dialog_width: CGFloat = UIDevice.current
        .userInterfaceIdiom == .pad ? 450.0 : AppWidth * 0.85
    let positiveLabel = UILabel()
    let negativeLabel = UILabel()
    
    positiveLabel.font = UIFont.systemFont(ofSize: textSize)
    positiveLabel.text = positiveText
    
    negativeLabel.font = UIFont.systemFont(ofSize: textSize)
    negativeLabel.text = negativeText
    
    let total_width: CGFloat = positiveLabel.intrinsicContentSize.width + negativeLabel.intrinsicContentSize.width + 100 + side * 2 + 5
    
    return total_width > dialog_width
}

// MARK: -- S --
func setBackBarItem() -> UIButton {
    let imgView = UIImageView(image: UIImage(named: "back_arrow"))
    
    imgView.frame = CGRect(x: 0, y: 11, width: imgView.frame.size.width, height: imgView.frame.size.height)
    let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 90, height: 44))
    backButton.addSubview(imgView)
    return backButton
}

// MARK: -- P --

/// 設定彈出排序視窗
func setPopover(isAutoLayout: Bool = true, cellHeight: Int = 45, cellLimit: Int = 1, width: Int = 200, isArrow: Bool = true) -> UITableViewController {
    let popoverVC = UITableViewController()
    popoverVC.modalPresentationStyle = UIModalPresentationStyle.popover
    popoverVC.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    popoverVC.tableView.alwaysBounceVertical = false
    popoverVC.tableView.bounces = false
    
    if !isAutoLayout {
        popoverVC.tableView.rowHeight = CGFloat(cellHeight)
        popoverVC.preferredContentSize = CGSize(width: width, height: cellHeight * cellLimit + 10)
    }
    
    if let popover = popoverVC.popoverPresentationController {
        popover.permittedArrowDirections = isArrow ? .up : []
        popover.backgroundColor = UIColor.white
    }
    return popoverVC
}

/// 設定彈出排序視窗(自定義cell)
func setPopoverWithCell(cell: String, isAutoLayout: Bool = true, cellHeight: Int = 60, cellLimit: Int = 1, width: Int = 200, isArrow: Bool = true) -> UITableViewController {
    let popoverVC = UITableViewController()
    popoverVC.modalPresentationStyle = UIModalPresentationStyle.popover
    popoverVC.tableView.register(UINib(nibName: "\(cell)", bundle: nil), forCellReuseIdentifier: "cell")
    popoverVC.tableView.alwaysBounceVertical = false
    popoverVC.tableView.bounces = false
    
    if !isAutoLayout {
        popoverVC.tableView.rowHeight = CGFloat(cellHeight)
        popoverVC.preferredContentSize = CGSize(width: width, height: cellHeight * cellLimit)
    }
    
    if let popover = popoverVC.popoverPresentationController {
        popover.permittedArrowDirections = isArrow ? .up : []
        popover.backgroundColor = UIColor.white
    }
    return popoverVC
}
