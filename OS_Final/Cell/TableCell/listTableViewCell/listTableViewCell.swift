//
//  listTableViewCell.swift
//  OS_Final
//
//  Created by mmslab406-mini2018-2 on 2022/12/7.
//

import UIKit

class listTableViewCell: UITableViewCell {

    @IBOutlet var imageView_type: UIImageView!
    
    @IBOutlet var label_date: UILabel!
    @IBOutlet var label_cost: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(date: String, img: String, cost: Int) {
        label_date.text = date
        imageView_type.image = UIImage(named: img)
        label_cost.text = String(format: "%2d", cost)
    }
}
