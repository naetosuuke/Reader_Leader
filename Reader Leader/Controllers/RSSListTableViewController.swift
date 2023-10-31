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
    var feedDatas = [FeedData]()
    var feedData: FeedData?
    var channelLinks = ["https://news.yahoo.co.jp/rss/topics/domestic.xml", "https://news.yahoo.co.jp/rss/topics/world.xml"] // UserDefaultからとってくる
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListTableView", bundle: nil)
        rssListTableView.backgroundColor = .clear
        rssListTableView.register(nib, forCellReuseIdentifier: "CustomCellForRSSListTableView") //cell登録
        rssListTableView.delegate = self
        rssListTableView.dataSource = self
        
        
        // MARK: - ライフサイクル上　viewDidAppearで記事情報を入手する。なのでViewDidLoad上では記事情報を使用できない
        
        showSideViewButton.layer.cornerRadius = 10.0
        showSideViewButton.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        moveToPreferenceButton.layer.cornerRadius = 10.0
        moveToPreferenceButton.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        
        
        // FIXME: グラデーション　別のswiftファイルで定義
        let gradientLayer = CAGradientLayer()
        // グラデーションレイヤーの領域をviewと同じに設定
        gradientLayer.frame = self.view.frame
        // グラデーション開始色
        let topColor = UIColor(red: 140/255, green: 255/255, blue: 241/255, alpha: 1).cgColor
        // グラデーション終了色
        let bottopColor = UIColor(red: 154/255, green: 170/255, blue: 224/255, alpha: 1).cgColor
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        // ビューにグラデーションレイヤーを追加
        self.view.layer.insertSublayer(gradientLayer, at:0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        let rssFeedParser = RSSFeedParser()
        for channelLink in channelLinks {
            guard let cL = URL(string: channelLink) else { return }
            rssFeedParser.parseXML(url:cL)
            self.feedDatas.append(contentsOf: rssFeedParser.feedDatas)  // selfに返している
        }
        
        rssListTableView.reloadData()

    }

    
    // MARK: - Navigation


    // MARK: Methods
    
    
}




extension RSSListTableViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = feedDatas.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = rssListTableView.dequeueReusableCell(withIdentifier: "CustomCellForRSSListTableView", for: indexPath) as! CustomCellForRSSListTableView
        let fD = feedDatas[indexPath.row] // セルの
        cell.articleLabel.text = fD.title
        cell.dataLabel.text = fD.pubDate
        cell.link = fD.link
        guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
        cell.iconImageView.image = img
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // セル選択時　グレーにならない
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Segueを実行し、URLをWebViewControllerに渡す
        let webView = self.storyboard?.instantiateViewController(withIdentifier: "ArticleViewController") as! ArticleViewController
        let fD = feedDatas[indexPath.row] // セルと対応するindex番号のfeedDataをインスタンス化
        webView.link = fD.link
        print ("check fD.link" + fD.link)
        self.navigationController?.pushViewController(webView,animated: true) // 普通のpresentメソッドだとnavCの連続性が失われるので注意
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UIContextualAction(style: .normal, title:" Fav") { (action, view, completionHandler) in     //　お気に入り、あとで読むボタンの実装　参照　https://qiita.com/JunichiHashimoto/items/5296d98b5e5a4bfbd6e3
            print("tapped Favorite Action")
            // FIXME: -  お気に入りに追加 or すでに追加済みアラートを出すfuncを起動
            completionHandler(true) // 実行結果に関わらず記述
          }
        favoriteAction.backgroundColor = UIColor.systemYellow // 編集ボタンの色を変更
        //favoriteAction.image = UIImage(named: "favorite") // アクションボタンに画像を設定
        let readLaterAction = UIContextualAction(style: .normal, title:"Later") { (action, view, completionHandler) in
            print("tapped ReadLater Action")
            // FIXME: -  あとで読むに追加 or すでに追加済みアラートを出すfuncを起動
          completionHandler(true) // 実行結果に関わらず記述
          }
        readLaterAction.backgroundColor = UIColor.systemGreen // 編集ボタンの色を変更
        //readLaterAction.image = UIImage(named: "favorite")  // アクションボタンに画像を設定
        return UISwipeActionsConfiguration(actions: [favoriteAction, readLaterAction])
    }
    
    //吹き出しメニュー
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? { return UIContextMenuConfiguration(actionProvider: { suggestedActions in
            
        //
            return UIMenu(children: [
                // FIXME: -  お気に入りに追加 or すでに追加済みアラートを出すfuncを起動
                UIAction(title: "Favorite") { _ in /* Implement the action. */ },
                // FIXME: -  あとで読むに追加 or すでに追加済みアラートを出すfuncを起動
                UIAction(title: "Read Later") { _ in /* Implement the action. */ }
                ])
            })
    }
    
    
}
