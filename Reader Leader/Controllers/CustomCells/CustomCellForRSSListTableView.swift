//
//  CustomCellForRSSListTableViewTableViewCell.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/10.
//

import UIKit

class CustomCellForRSSListTableView: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    func setup(image: UIImage, name: String, description: String) {
//      iconImageView.image = image
//      nameLabel.text = name
//    }
    
}
