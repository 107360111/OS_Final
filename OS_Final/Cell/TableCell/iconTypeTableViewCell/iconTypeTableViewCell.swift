//
//  iconTypeTableViewCell.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/12.
//

import UIKit
import SDWebImage

class iconTypeTableViewCell: UITableViewCell {
    @IBOutlet var imageView_Icon: UIImageView!
    @IBOutlet var label_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(icon: String, name: String) {
        imageView_Icon.image = UIImage(named: icon)
        
        if name.contains("其他") {
            label_name.text = "其他"
        } else {
            label_name.text = name
        }
    }
}
