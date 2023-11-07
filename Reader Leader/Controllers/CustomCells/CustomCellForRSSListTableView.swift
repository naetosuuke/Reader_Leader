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
    override func prepareForReuse() { //セルの再利用時に読み込む初期化内容
        super.prepareForReuse() // ここで初期化しておくことで、セルをIndexRowAtで指定してラベルや色を変えたときに再利用起因で起きるバグを回避できる
        flagLabel.text = ""
        backgroundColor = .systemBackground
    }
    

    
}
