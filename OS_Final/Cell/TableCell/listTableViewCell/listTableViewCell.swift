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
    @IBOutlet var label_detail: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setCell(date: String, img: String, cost: String, detail: String) {
        label_date.text = date
    }
}
