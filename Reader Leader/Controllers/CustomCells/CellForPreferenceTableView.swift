//
//  CellForPreferenceTableView.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/12.
//

import UIKit
class CellForPreferenceTableView: UITableViewCell {
    

    @IBOutlet weak var preferenceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
