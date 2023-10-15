//
//  RSSListSideViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class RSSListSideViewController: UIViewController {

    // MARK: IBOutlets  複数TableViewの実装に際し、Storyboard上で各TableViewにタグ0,1を割当
    @IBOutlet weak var sortTableView: UITableView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    // MARK: Properties
    var sortProperty: [String]?
    var categoryProperty: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortProperty = ["All", "Unread", "Favorite", "Read Later"]
        categoryProperty = ["主要", "国内", "国際", "経済", "エンタメ"] // FIXME: カテゴリは登録状況で動的に変更される。自分が登録したチャンネルをならべられるようにあとで差し替え
        
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.isScrollEnabled = false // スクロール禁止

        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        categoryTableView.isScrollEnabled = false // スクロール禁止
    }
    
    override func viewWillAppear(_ animated: Bool) { //FIXME: ハーフでなくフル表示して戻るために実装　検証後、削除
        navigationController?.navigationBar.isHidden = false
    }
    
}


extension RSSListSideViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch tableView.tag { //各tableViewのタグで分岐
            case 0:
                guard let sP = sortProperty else { return 0 } // アンラップ
                let cellCount = sP.count
                return cellCount
            case 1:
                guard let cP = categoryProperty else { return 0 } // アンラップ
                let cellCount = cP.count
                return cellCount
            default:
                let cellCount = 0
                return cellCount
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForRSSListSideTableView", for: indexPath)
        switch tableView.tag { //各tableViewのタグで分岐
            case 0:
                guard let sP = sortProperty else { return cell } // アンラップ
                cell.textLabel?.text = sP[indexPath.row]
            case 1:
                guard let cp = categoryProperty else { return cell } // アンラップ
                cell.textLabel?.text = cp[indexPath.row]
            default:
                return cell
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //お気に入り、未読、あとで読む、各カテゴリでソートをかける
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
}
