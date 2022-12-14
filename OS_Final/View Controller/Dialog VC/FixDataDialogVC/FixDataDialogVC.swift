//
//  FixDataDialogVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/20.
//

import UIKit
@objc protocol FixDataDialogVCDelegate {
    func chooseDelete()
    func chooseFix()
}
class FixDataDialogVC: UIViewController {
    @IBOutlet var view_background: UIView!
    
    @IBOutlet var sumView_onlyDelete: UIView!
    @IBOutlet var view_onlyDelete: UIView!
    
    
    @IBOutlet var sumView_select: UIView!
    @IBOutlet var view_delete: UIView!
    @IBOutlet var label_delete: UILabel!
    
    @IBOutlet var view_fix: UIView!
    @IBOutlet var label_fix: UILabel!
    
    @IBOutlet var view_cancel: UIView!
    
    @IBOutlet var label_title: UILabel!
    @IBOutlet var label_date: UILabel!
    @IBOutlet var label_ways: UILabel!
    @IBOutlet var label_cost: UILabel!
    
    @IBOutlet var label_detail: UILabel!
    @IBOutlet var label_titleDetail: UILabel!
    
    private var chooseTitle: Titles = .none
    private var data: noteData?
    private var isFix: Bool = false // 是不是修正
    private var isScan: Bool = false // 是不是用掃描登入的
    
    weak var delegate: FixDataDialogVCDelegate?
    
    convenience init(title: Titles, data: noteData, isFix: Bool, isScan: Bool) {
        self.init()
        self.chooseTitle = title
        self.data = data
        self.isFix = isFix
        self.isScan = isScan
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    private func componentsInit() {
        viewInit()
        labelInit()
        ButtonInit()
    }
    
    private func viewInit() {        
        view_background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelDidTap)))
        view_cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelDidTap)))
        view_delete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteDidTap)))
        view_fix.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(fixDidTap)))
        view_onlyDelete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteDidTap)))
    }
    
    private func labelInit() {
        label_title.text = chooseTitle.TitleString(title: chooseTitle)
        label_date.text = data?.date
        label_ways.text = data?.ways
        label_cost.text = String(format: "%2d", Int(data?.cost ?? 0))
  
        guard data?.detail.count ?? 0 > 0 else {
            label_detail.isHidden = true
            label_titleDetail.isHidden = true
            return
        }
        label_detail.text = data?.detail
    }
    
    private func ButtonInit() {
        switch (isFix, isScan) {
        case (true, false):
            view_delete.borderColor = UIColor.gray_C4C4C4
            label_delete.text = "取消"
            label_delete.textColor = UIColor.gray_C4C4C4
            
            label_fix.text = "確認"
            break
        case (false, true):
            view_background.isHidden = true
            view_cancel.isHidden = true
            
            view_delete.borderColor = UIColor.gray_C4C4C4
            label_delete.text = "取消"
            label_delete.textColor = UIColor.gray_C4C4C4
            
            label_fix.text = "確認"
            break
        default:
            sumView_onlyDelete.isHidden = !(data?.type == "cloud")
            sumView_select.isHidden = data?.type == "cloud"
            break
        }
    }
    
    @objc private func cancelDidTap() {
        self.dialogDismiss()
    }
    
    @objc private func fixDidTap() {
        self.delegate?.chooseFix()
        self.dialogDismiss()
    }
    
    @objc private func deleteDidTap() {
        self.delegate?.chooseDelete()
        self.dialogDismiss()
    }
}
