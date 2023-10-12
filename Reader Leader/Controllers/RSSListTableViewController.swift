//
//  RSSListTableViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

// FIXME:  検証用　sideボタン　本来はsideViewを呼び出すところ　仮でcollectionViewの呼び出しを行なっている。collectionViewの画面実装ができればsideView呼び出しに切り替え

import UIKit

class RSSListTableViewController: UIViewController{
 
    @IBOutlet weak var rssListTableView: UITableView!
    @IBOutlet weak var showSideViewButton: UIButton!
    @IBOutlet weak var moveToPreferenceButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListTableView", bundle: nil)
        rssListTableView.register(nib, forCellReuseIdentifier: "CustomCellForRSSListTableView") //cell登録
        rssListTableView.delegate = self
        rssListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true 
    }

    

    // MARK: - Navigation


    // MARK: Methods
    
    
}




extension RSSListTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ rssListTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10 // ⇦取得したRSS channelの件数に変更する。RSSChannels.count
    }
    
    func tableView(_ rssListTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = rssListTableView.dequeueReusableCell(withIdentifier: "CustomCellForRSSListTableView", for: indexPath)
        // セルに表示する値を設定する　後日対応
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //遷移先に渡すURLを取得、prepareで次の画面に渡す
        
        //画面遷移
        self.performSegue(withIdentifier: "ArticleViewControllerSegue", sender: nil)
    }
    
}
