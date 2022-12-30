//
//  listDetailHeaderView.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/8.
//

import UIKit
@objc protocol listDetailHeaderViewDelegate {
    func tapTimeTitle()
    func tapTypeTitle()
    func tapCostTitle()
}

class listDetailHeaderView: UITableViewHeaderFooterView {
    @IBOutlet var view_title_time: UIView!
    @IBOutlet var view_title_type: UIView!
    @IBOutlet var view_title_cost: UIView!
    
    @IBOutlet var view_imageView_type: UIView! // 隱藏用
    
    @IBOutlet var label_title_time: UILabel!
    @IBOutlet var label_title_type: UILabel!
    @IBOutlet var label_title_cost: UILabel!
    
    @IBOutlet var label_time_symbol: UILabel!
    @IBOutlet var imageView_type_symbol: UIImageView!
    @IBOutlet var label_cost_symbol: UILabel!
    
    weak var delegate: listDetailHeaderViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label_time_symbol.text = ""
        view_imageView_type.isHidden = true
        label_cost_symbol.text = ""
        
        viewInit()
    }
    
    private func viewInit() {
        view_title_time.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(timeTitleDidTap)))
        view_title_type.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(typeTitleDidTap)))
        view_title_cost.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(costTitleDidTap)))
    }
    
    func setHeader(timeTitle: String = "-", typeTitle: String = String(), costTitle: String = "-") {
        label_time_symbol.text = "(\(timeTitle))"
        label_cost_symbol.text = "(\(costTitle))"
        
        label_title_type.isHidden = false
        view_imageView_type.isHidden = true
        if typeTitle.count > 0 {
            label_title_type.isHidden = true
            view_imageView_type.isHidden = false
            
            guard let tintedTmage = UIImage(named: typeTitle)?.withRenderingMode(.alwaysTemplate) else { return }
            imageView_type_symbol.image = tintedTmage
            
        }
    }
    
    @objc private func timeTitleDidTap() {
        self.delegate?.tapTimeTitle()
    }
    
    @objc private func typeTitleDidTap() {
        self.delegate?.tapTypeTitle()
    }
    
    @objc private func costTitleDidTap() {
        self.delegate?.tapCostTitle()
    }
    
    
}
