//
//  CustomCellForRSSListTableViewTableViewCell.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/10.
//

import UIKit

class CustomCellForRSSListTableView: UITableViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    var link = "" // URLはStringで保村する
    var category = ""
    var isRead = false
    var readLater = false
    var favorite = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
