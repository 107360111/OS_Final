//
//  ChooseDialogVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/6.
//

import UIKit
import MBRadioCheckboxButton

@objc protocol ChooseDialogVCDelegate: AnyObject {
    func positiveBtnClickWith(title: Titles)
    @objc optional func negativeBtnClickedWith(title: Titles)
    @objc optional func dismissButtonDidTap(with title: Titles)
    @objc optional func checkBtnClick(isCheck: Bool)
}

class ChooseDialogVC: UIViewController {
    @IBOutlet var view_background: UIView!
    
    @IBOutlet var label_notice: UILabel!
    @IBOutlet var label_title: UILabel!
    
    @IBOutlet var view_check: UIView!
    @IBOutlet var btn_check: CheckboxButton!
    
    @IBOutlet var view_cancel: UIView!
    @IBOutlet var view_confirm: UIView!
    
    private var chooseTitle: Titles = .none
    private var message: String = ""
    private var mode: ViewMode = .Notice
    
    private var needCheck: Bool = false
    private var canDismiss: Bool = true
    
    weak var delegate: ChooseDialogVCDelegate?
    
    enum ViewMode {
        case Notice
        case Choose
        case Microphone
        case SpeechRecongizer
        case Camera
        case PhotoLibrary
        case GPS
    }
    
    convenience init(title: Titles, canDismiss: Bool = true, message: String = "", needCheck: Bool = false) {
        self.init()
        self.chooseTitle = title
        self.canDismiss = canDismiss
        self.message = message
        self.needCheck = needCheck
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    private func componentsInit() {
        btn_check.isOn = false
        labelInit()
        viewInit()
    }
    
    private func labelInit() {
        label_title.text = message.isEmpty ? chooseTitle.TitleString(title: chooseTitle) : chooseTitle.TitleString(title: chooseTitle, msg: message)
    }
    
    private func viewInit() {
        view_background.isUserInteractionEnabled = canDismiss
        view_background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewDidTap)))
        
        view_check.isHidden = !needCheck
        view_check.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(checkBtnDidClick)))
        
        view_confirm.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(confirmDidTap)))
        view_cancel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(cancelDidTap)))
    }
    
    @objc private func viewDidTap() {
        delegate?.dismissButtonDidTap?(with: chooseTitle)
        dialogDismiss()
    }
    
    @objc private func checkBtnDidClick() {
        btn_check.isOn = !btn_check.isOn
    }
    
    @objc private func confirmDidTap() {
        self.delegate?.positiveBtnClickWith(title: self.chooseTitle)
        self.delegate?.checkBtnClick?(isCheck: self.btn_check.isOn)
        dialogDismiss()
    }
    
    @objc private func cancelDidTap() {
        delegate?.negativeBtnClickedWith?(title: chooseTitle)
        dialogDismiss()
    }
    
}
