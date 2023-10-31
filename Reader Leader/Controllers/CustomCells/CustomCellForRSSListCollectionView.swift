//
//  CustomCellForRSSListCollectionView.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/12.
//

import UIKit

class CustomCellForRSSListCollectionView: UICollectionViewCell {
    
    
    @IBOutlet weak var articleLabel: UILabel!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    var link = "" // URLはStringで保村する
    var category = ""
    var isRead = false
    var readLater = false
    var favorite = false
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    
}
