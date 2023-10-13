//
//  RSSListTableViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

// FIXME:  検証用　sideボタン　本来はsideViewを呼び出すところ　仮でcollectionViewの呼び出しを行なっている。collectionViewの画面実装ができればsideView呼び出しに切り替え

import UIKit

class RSSListTableViewController: UIViewController{
    
    // MARK: IBOutlets
    @IBOutlet weak var rssListTableView: UITableView!
    @IBOutlet weak var showSideViewButton: UIButton!
    @IBOutlet weak var moveToPreferenceButton: UIButton!
    
    // MARK: Properties
    var rssFeedsName: [String]?
    var rssFeedsData: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListTableView", bundle: nil)
        rssListTableView.register(nib, forCellReuseIdentifier: "CustomCellForRSSListTableView") //cell登録
        rssListTableView.delegate = self
        rssListTableView.dataSource = self
        rssFeedsName = ["article1", "article2", "article3", "article4","article5","article6","article7","article8","article9","article10"]
        rssFeedsData = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10"]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }

    

    // MARK: - Navigation


    // MARK: Methods
    
    
}




extension RSSListTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rFN = rssFeedsName else { return 0 } // アンラップ
        let cellCount = rFN.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = rssListTableView.dequeueReusableCell(withIdentifier: "CustomCellForRSSListTableView", for: indexPath) as! CustomCellForRSSListTableView
        guard let rFN = rssFeedsName else { return cell } // アンラップ
        cell.articleLabel.text = rFN[indexPath.row]
        guard let rFD = rssFeedsData else { return cell } // アンラップ
        cell.dataLabel.text = rFD[indexPath.row]
        guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
        cell.iconImageView.image = img
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //遷移先に渡すURLを取得、prepareで次の画面に渡す
        
        //画面遷移
        self.performSegue(withIdentifier: "ArticleViewControllerSegue", sender: nil)
    }
    
}
