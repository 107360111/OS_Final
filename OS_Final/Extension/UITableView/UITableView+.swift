//
//  UITableView+.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import Foundation
import UIKit

extension UITableView {

    func reloadCellsHeight() {
        //要關閉動畫 不然tableview會跳動
        UIView.setAnimationsEnabled(false)
        self.beginUpdates()
        self.endUpdates()
        //執行完畢 開啟動畫
        UIView.setAnimationsEnabled(true)
    }

    func reloadVisibleCells(completion: (() -> Void )? = nil) {
        var reloadIndexPaths = [IndexPath]()
        let visibleCells = self.visibleCells
        
        for visibleCell in visibleCells {
            guard let indexPath = self.indexPath(for: visibleCell) else { continue }
            reloadIndexPaths.append(indexPath)
        }
        
        self.performBatchUpdates({
            //要關閉動畫 不然tableview會跳動
            UIView.setAnimationsEnabled(false)
            self.reloadRows(at: reloadIndexPaths, with: .none)
        }) { (_) in
            //執行完畢 開啟動畫
            UIView.setAnimationsEnabled(true)
            completion?()
        }
        
    }
    
    // 官方的文件註解說reload的時候最好用performBatchUpdate包起來，取消動畫可以防止cell更新時抖動
    func reloadCellsAnimation(indexPaths:[IndexPath],animate: Bool ,completion:(() -> Void)? = nil) {
        UIView.setAnimationsEnabled(animate)
        self.performBatchUpdates({
            self.reloadRows(at: indexPaths, with: .automatic)
        }) { (_) in
            UIView.setAnimationsEnabled(true)
            completion?()
        }
        
    }
}
