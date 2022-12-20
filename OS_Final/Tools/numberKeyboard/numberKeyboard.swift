//
//  numberKeyboard.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/12.
//

import UIKit
@objc protocol numberKeyboardDelegate {
    func numberButtonDidTap(tag: String)
    func clearButtonDidTap()
    func deleteButtonDiaTap()
    func finishButtonDidTap()
}

class numberKeyboard: UIView {
    @IBOutlet var view_C: UIView!
    @IBOutlet var view_delete: UIView!
    
    weak var delegate: numberKeyboardDelegate?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubView()
    }
    
    private func initSubView() {
        guard let view = Bundle.main.loadNibNamed("numberKeyboard", owner: self, options: nil)?.first as? UIView else { return }
        self.addSubview(view)
        view.frame = self.bounds
        viewInit()
    }
    
    private func viewInit() {
        view_C.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(clearDidTap)))
        view_delete.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteDidTap)))
    }
    
    @IBAction func numberDidTap(btn: UIButton) {
        let tag: String = btn.titleLabel?.text ?? ""
        self.delegate?.numberButtonDidTap(tag: tag)
    }
    
    @objc private func clearDidTap() {
        self.delegate?.clearButtonDidTap()
    }
    
    @objc private func deleteDidTap() {
        self.delegate?.deleteButtonDiaTap()
    }
}
