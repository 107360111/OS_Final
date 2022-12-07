//
//  barCollectionViewCell.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/7.
//

import UIKit

class barCollectionViewCell: UICollectionViewCell {

    @IBOutlet var view_background: UIView!
    @IBOutlet var view_image: UIView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var imageView_selected: UIImageView!
    
    @IBOutlet var label_unread: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundColor = .gray_BAB6B6_60
                }) { (completion) in
                    UIView.animate(withDuration: 0.01, animations: {
                        self.backgroundColor = .white
                    })
                }
            }
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                UIView.animate(withDuration: 0.3, animations: {
                    self.backgroundColor = .gray_BAB6B6_60
                })
            } else {
                self.backgroundColor = .white
            }
        }
    }
    
    func setCell(index: Int, isSelected: Bool, unreadCnt: Int = 0) {
        var imgName: String = ""
        var selectedName: String = ""
        switch index {
        case 0: // schedule
            imgName = "schedule"
            selectedName = "schedule_selected"
        case 1: // list
            imgName = "list"
            selectedName = "list_selected"
        case 2: // userSetting
            imgName = "userSetting"
            selectedName = "userSetting_selected"
        default:
            break
        }
        imageView.image = UIImage(named: imgName)
        imageView_selected.image = UIImage(named: selectedName)
        
        label_unread.isHidden = unreadCnt == 0
        label_unread.text = unreadCnt > 9 ? "N" : "\(unreadCnt)"
        
        view_image.isHidden = isSelected
        imageView_selected.isHidden = !isSelected
    }

}
