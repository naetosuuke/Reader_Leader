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
    
    

    // MARK: segue
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForSelectRSSTableView", bundle: nil)
        selectRSSTableView.register(nib, forCellReuseIdentifier: "CustomCellForSelectRSSTableView") //cell登録
        selectRSSTableView.delegate = self
        selectRSSTableView.dataSource = self
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
        return 10 // ⇦取得したRSS channelの件数に変更する。RSSChannels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "CustomCellForSelectRSSTableView", for: indexPath)
        // セルに表示する値を設定する
        return cell
    }
    
}
