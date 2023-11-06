//
//  RSSListTableViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

// TODO:  検証用　sideボタン　本来はsideViewを呼び出すところ　仮でcollectionViewの呼び出しを行なっている。collectionViewの画面実装ができればsideView呼び出しに切り替え

import UIKit
import SafariServices

class RSSListTableViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var rssListTableView: UITableView!
    @IBOutlet weak var showSideViewButton: UIButton!
    @IBOutlet weak var moveToPreferenceButton: UIButton!
    
    // MARK: - Properties
    private var storedFeedDatas = [FeedData]()
    private var channelLinks = ["https://news.yahoo.co.jp/rss/topics/domestic.xml", "https://news.yahoo.co.jp/rss/topics/world.xml"] // UserDefaultからとってくる
    
    // MARK: - ViewInit
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListTableView", bundle: nil)
        rssListTableView.register(nib, forCellReuseIdentifier: "CustomCellForRSSListTableView") //cell登録
        rssListTableView.delegate = self
        rssListTableView.dataSource = self
        setupView() // layout, layer実装
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        async {
            let fetchedFeedDatas = await RSSFeedParser().downloadAndParseXML(channelLinks: channelLinks)
            let checkedFeedDatas = RSSFeedHandler().checkDuplicationAndStoreDatas(fetchedFeedDatas: fetchedFeedDatas, storedFeedDatas: storedFeedDatas)
            storedFeedDatas.append(contentsOf: checkedFeedDatas)
            //ソートする
            let category = UserDefaults.standard.string(forKey: "chosenCategoryForListView")!
            if category != "All" {
                var filteredFeedDatas: [FeedData] = []
                for feedData in storedFeedDatas {
                    switch category {
                    case "Unread" : if !feedData.isRead {filteredFeedDatas.append(feedData)}
                    case "Favorite" : if feedData.isFavorite {filteredFeedDatas.append(feedData)}
                    case "Read Later" : if feedData.isReadLater {filteredFeedDatas.append(feedData)}
                    default : if feedData.categoryID == category {filteredFeedDatas.append(feedData)}
                    }
                }
                self.storedFeedDatas = filteredFeedDatas
            }
            self.rssListTableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    // MARK: - Methods
    
    private func setupView() { // TODO: できる限りColorAndLayerモデルにプリセットを作成し、コードを分離
        // MARK: ライフサイクル上　viewDidAppearで記事情報を入手する。なのでViewDidLoad上では記事情報を使用できない
        rssListTableView.backgroundColor = .clear
        showSideViewButton.layer.cornerRadius = 10.0
        moveToPreferenceButton.layer.cornerRadius = 10.0
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame // グラデーションレイヤーの領域をviewと同じに設定
        let topColor = UIColor(red: 140/255, green: 255/255, blue: 241/255, alpha: 1).cgColor // グラデーション開始色
        let bottopColor = UIColor(red: 154/255, green: 170/255, blue: 224/255, alpha: 1).cgColor // グラデーション終了色
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        // ビューにグラデーションレイヤーを追加
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

extension RSSListTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    // MARK: - UITableView Delegate, Datasource Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = storedFeedDatas.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = rssListTableView.dequeueReusableCell(withIdentifier: "CustomCellForRSSListTableView", for: indexPath) as! CustomCellForRSSListTableView
        let fD = storedFeedDatas[indexPath.row] // セルの
        // TODO: - ここにソート用の分岐を作成する(お気に入り、未読、既読、各カテゴリによってfeedDataの取捨選択をする)
        
        cell.articleLabel.text = fD.title
        cell.dataLabel.text = fD.pubDate
        cell.categoryLabel.text = fD.category
        cell.link = fD.link
        
        cell.flagLabel.text = ""
        cell.isRead = fD.isRead
        if !cell.isRead {
            cell.flagLabel.text! += "🔵"
        }
        cell.isFavorite = fD.isFavorite
        if cell.isFavorite {
            cell.flagLabel.text! += "⭐️"
        }
        cell.isReadLater = fD.isReadLater
        if cell.isReadLater {
            cell.flagLabel.text! += "🔖"
        }

        guard let img = UIImage(named: "yahoo") else { return cell } // FIXME: 対象のURLからHTMLソースを入手し、サムネイルが入った要素から画像データを抽出してimgに当てる (作業が重そうだったので今回はパス)
        cell.iconImageView.image = img
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // セル選択時　グレーにならない
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Segueを実行し、URLをWebViewControllerに渡す
        self.storedFeedDatas[indexPath.row].isRead = true // 既読フラグつける
        self.storedFeedDatas[indexPath.row].isReadLater = false // あとで読むフラグ解除
        let fD = storedFeedDatas[indexPath.row] // セルと対応するindex番号のfeedDataをインスタンス化
        let url = URL(string:fD.link)
        if let url = url {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let readLaterAction = UIContextualAction(style: .normal, title:"Later") { (action, view, completionHandler) in
            let fD = self.storedFeedDatas[indexPath.row]
            if !fD.isReadLater {
                self.storedFeedDatas[indexPath.row].isReadLater = true
            } else {
                self.storedFeedDatas[indexPath.row].isReadLater = false
            }
            self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            completionHandler(true) // 実行結果に関わらず記述
        }
        readLaterAction.backgroundColor = UIColor.systemGreen // 編集ボタンの色を変更
        //readLaterAction.image = UIImage(named: "favorite")  // アクションボタンに画像を設定
        
        let favoriteAction = UIContextualAction(style: .normal, title:" Fav") { (action, view, completionHandler) in // https://qiita.com/JunichiHashimoto/items/5296d98b5e5a4bfbd6e3
            let fD = self.storedFeedDatas[indexPath.row]
            if !fD.isFavorite {
                self.storedFeedDatas[indexPath.row].isFavorite = true
            } else {
                self.storedFeedDatas[indexPath.row].isFavorite = false
            }
            self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            completionHandler(true) // 実行結果に関わらず記述
        }
        favoriteAction.backgroundColor = UIColor.systemYellow // 編集ボタンの色を変更
        //favoriteAction.image = UIImage(named: "favorite") // アクションボタンに画像を設定
        
        
        return UISwipeActionsConfiguration(actions: [readLaterAction,favoriteAction])
    }
    
    //吹き出しメニュー
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { return UIContextMenuConfiguration(actionProvider: { suggestedActions in
        return UIMenu(children: [
            // TODO: -  お気に入りに追加 or すでに追加済みアラートを出すfuncを起動
            UIAction(title: "Read Later") { _ in
                let fD = self.storedFeedDatas[indexPath.row]
                if !fD.isReadLater {
                    self.storedFeedDatas[indexPath.row].isReadLater = true
                } else {
                    self.storedFeedDatas[indexPath.row].isReadLater = false
                }
                self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            },
            // TODO: -  あとで読むに追加 or すでに追加済みアラートを出すfuncを起動
            UIAction(title: "Favorite") { _ in
                let fD = self.storedFeedDatas[indexPath.row]
                if !fD.isFavorite {
                    self.storedFeedDatas[indexPath.row].isFavorite = true
                } else {
                    self.storedFeedDatas[indexPath.row].isFavorite = false
                }
                self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
        ])
    })
    }
}


