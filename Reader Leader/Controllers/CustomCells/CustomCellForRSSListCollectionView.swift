//
//  CustomCellForRSSListCollectionView.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/12.
//

import UIKit

class CustomCellForRSSListCollectionView: UICollectionViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }

    
}
