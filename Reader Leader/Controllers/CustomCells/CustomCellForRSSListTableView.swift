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
    @IBOutlet weak var flagLabel: UILabel!
    
    // MARK: - Properties
    var link = "" // URLはStringで保存する
    var category = ""
    var isRead = false
    var isReadLater = false
    var isFavorite = false
    
    // MARK: - ViewInit
    override func awakeFromNib() { //  awakeFromNibは初回読み込み時しか呼び出されないので、reloadViewでは反映されない。 https://stackoverflow.com/questions/56042220/awakefromnimb-doesnt-get-called-on-tableview-reloaddata-swift
        super.awakeFromNib()
        flagLabel.text = ""
    }
    

    
}
