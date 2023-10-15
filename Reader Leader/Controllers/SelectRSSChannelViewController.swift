//
//  SelectRSSChannelViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class SelectRSSChannelViewController: UIViewController{

    // MARK: IBOutlets
    @IBOutlet weak var label: UIView!
    @IBOutlet weak var launchRSSListButton: UIButton!
    @IBOutlet weak var selectRSSTableView: UITableView!
    

    // MARK: Properties
    var rssChannels: [String]?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForSelectRSSTableView", bundle: nil)
        selectRSSTableView.register(nib, forCellReuseIdentifier: "CustomCellForSelectRSSTableView") //cell登録
        selectRSSTableView.delegate = self
        selectRSSTableView.dataSource = self
        rssChannels = ["channel1", "channel2", "channel3", "channel4", "channel5", "channel6", "channel7", "channel8", "channel9", "channel10",]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    
    // MARK: segues
    
    
    // MARK: Methods
    
    
    // MARK: Controllers
    
    
    
}


extension SelectRSSChannelViewController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rc = rssChannels else { return 0 } // アンラップ
        let cellCount = rc.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellForSelectRSSTableView", for: indexPath) as! CustomCellForSelectRSSTableView
        guard let rc = rssChannels else { return cell } // アンラップ
        cell.nameLabel.text = rc[indexPath.row]
        guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
        cell.iconImageView.image = img
        // セルに表示する値を設定する
        return cell
    }
    
}
