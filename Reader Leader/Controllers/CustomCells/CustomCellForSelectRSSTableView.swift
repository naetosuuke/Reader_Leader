//
//  CustomCellForSelectRSSTableView.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/12.
//

import UIKit

class CustomCellForSelectRSSTableView: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
