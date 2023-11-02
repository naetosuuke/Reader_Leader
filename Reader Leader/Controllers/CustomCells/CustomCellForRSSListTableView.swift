//
//  CustomCellForRSSListTableViewTableViewCell.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/10.
//

import UIKit

class CustomCellForRSSListTableView: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!


    // MARK: - Properties
    var link = "" // URLはStringで保存する
    var category = ""
    var isRead = false
    var readLater = false
    var favorite = false
    
    // MARK: - ViewInit
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
