//
//  WriteInDialogVC.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/9.
//

import UIKit

@objc protocol WriteInDialogVCDelegate {
    func chooseQRcode()
    func chooseWritten()
}

class WriteInDialogVC: UIViewController {

    @IBOutlet var view_background: UIView!
    @IBOutlet var view_QRCode: UIView!
    @IBOutlet var view_writen: UIView!
    
    weak var delegate: WriteInDialogVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        componentsInit()
    }
    
    private func componentsInit() {
        view_background.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap)))
        view_QRCode.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(QRCodeDidTap)))
        view_writen.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writtenDidTap)))
    }
    
    @objc private func backgroundDidTap() {
        self.dialogDismiss()
    }
    
    @objc private func QRCodeDidTap() {
        self.delegate?.chooseQRcode()
        self.dialogDismiss()
    }
    
    @objc private func writtenDidTap() {
        self.delegate?.chooseWritten()
        self.dialogDismiss()
    }
}
