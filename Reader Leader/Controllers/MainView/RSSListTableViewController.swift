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
    private var filteredFeedDatas = [FeedData]()
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
        // TODO: モデルとして分離
        if let darkMode = UserDefaults.standard.string(forKey: "DarkMode"){
            switch darkMode {
            case "light": self.overrideUserInterfaceStyle = .light
            case "dark": self.overrideUserInterfaceStyle = .dark
            default: print("dark theme ...match as devise setting")
            }
        }
        navigationController?.navigationBar.isHidden = true
        let rssFeedParser = RSSFeedParser()
        let rssFeedHandler = RSSFeedHandler()
        async {
            let fetchedFeedDatas = await rssFeedParser.downloadAndParseXML(channelLinks: channelLinks)
            let checkedFeedDatas = rssFeedHandler.checkDuplication(fetchedFeedDatas: fetchedFeedDatas, storedFeedDatas: storedFeedDatas)
            self.storedFeedDatas.append(contentsOf: checkedFeedDatas)
            self.filteredFeedDatas = rssFeedHandler.filterFeedData(storedFeedDatas: storedFeedDatas)
            self.rssListTableView.reloadData()
        }
    }
    
    // MARK: - Navigation
    // MARK: - Methods
    
    private func setupView() { // TODO: できる限りColorAndLayerモデルにプリセットを作成し、コードを分離
        // MARK: ライフサイクル上　viewDidAppearで記事情報を入手する。なのでViewDidLoad上では記事情報を使用できない
        rssListTableView.backgroundColor = .clear
 
        showSideViewButton.layer.cornerRadius = 10.0
        showSideViewButton.layer.shadowColor = UIColor.black.cgColor
        showSideViewButton.layer.shadowOpacity = 0.2
        showSideViewButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        showSideViewButton.layer.shadowRadius = 3.0 // ぼかし具合
        
        moveToPreferenceButton.layer.cornerRadius = 10.0
        moveToPreferenceButton.layer.shadowColor = UIColor.black.cgColor
        moveToPreferenceButton.layer.shadowOpacity = 0.2
        moveToPreferenceButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        moveToPreferenceButton.layer.shadowRadius = 3.0 // ぼかし具合
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.frame // グラデーションレイヤーの領域をviewと同じに設定　// TODO: ダークテーマ用の配色、分岐を行う。
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
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { //FIXME: セルの高さ　フォントサイズで可変になるようしたほうがいい
        return 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellCount = filteredFeedDatas.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = rssListTableView.dequeueReusableCell(withIdentifier: "CustomCellForRSSListTableView", for: indexPath) as! CustomCellForRSSListTableView
        let fD = filteredFeedDatas[indexPath.row] // セルの
        // TODO: - ここにソート用の分岐を作成する(お気に入り、未読、既読、各カテゴリによってfeedDataの取捨選択をする)
        
        cell.link = fD.link
        
        cell.articleLabel.text = fD.title
        cell.dataLabel.text = fD.pubDate // FIXME: 20xx/xx/xx(date) 等　見やすい形に変換する
        cell.categoryLabel.text = fD.category
        cell.flagLabel.text = ""
        cell.isRead = fD.isRead
        if !cell.isRead {
            cell.flagLabel.text! += "🔵"
        } else {
            cell.backgroundColor = UIColor.systemGray5
        }
        cell.isFavorite = fD.isFavorite
        if cell.isFavorite {
            cell.flagLabel.text! += "⭐️"
        }
        cell.isReadLater = fD.isReadLater
        if cell.isReadLater {
            cell.flagLabel.text! += "🔖"
        }
        
        if let characterSize = UserDefaults.standard.string(forKey: "CharacterSize") { //設定により文字サイズ調整
            switch characterSize {
            case "min":
                cell.articleLabel.font = UIFont.systemFont(ofSize: 13) //フォントサイズのみ変更　!! cell.articleLabel.font.withSize(11) → withSizeは既存の文字のサイズを上書きできない(ChatGPT回答) https://qiita.com/shocho0101/items/678aef624fbcf87b5a51
                cell.dataLabel.font = UIFont.systemFont(ofSize: 9)
                cell.categoryLabel.font = UIFont.systemFont(ofSize: 9)
                cell.flagLabel.font = UIFont.systemFont(ofSize: 9)
            case "mid":
                cell.articleLabel.font = UIFont.systemFont(ofSize: 15)
                cell.dataLabel.font = UIFont.systemFont(ofSize: 11)
                cell.categoryLabel.font = UIFont.systemFont(ofSize: 11)
                cell.flagLabel.font = UIFont.systemFont(ofSize: 11)
            case "max":
                cell.articleLabel.font = UIFont.systemFont(ofSize: 20)
                cell.dataLabel.font = UIFont.systemFont(ofSize: 16)
                cell.categoryLabel.font = UIFont.systemFont(ofSize: 16)
                cell.flagLabel.font = UIFont.systemFont(ofSize: 16)
                // cell.textLabel?.adjustsFontSizeToFitWidth = true //入らなかったらこれ使う
            default:
                print("characterSize has unexpected value")
                print(characterSize)
            }
        }
        
        guard let img = UIImage(named: "yahoo") else { return cell } // FIXME: 対象のURLからHTMLソースを入手し、サムネイルが入った要素から画像データを抽出してimgに当てる (作業が重そうだったので今回はパス)
        cell.iconImageView.image = img
        
        // FIXME: 実装落ち着いたら TableViewのセルを見栄えよくする
        // example...
        // cell.layer.cornerRadius = 30.0
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // セル選択時　グレーにならない
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { // Segueを実行し、URLをWebViewControllerに渡す
        let fD = self.filteredFeedDatas[indexPath.row] 
        self.filteredFeedDatas[indexPath.row].isRead = true // 既読フラグつける
        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) { // FIXME: TableViewに表示しているデータはソート済の配列なので、ソート前の元データが持つフラグも同時に更新するように、firstIndexを用いて実装している。ただしコードが冗長になってる気がするので、もっと短く書く or ModelsのRSSFeedHandlerに分離したい
            self.storedFeedDatas[indexInStoredFeedDatas].isRead = true
        }
        self.filteredFeedDatas[indexPath.row].isReadLater = false // あとで読むフラグ解除
        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
            self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = false
        }

        let url = URL(string:fD.link)
        if let url = url {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    
    // セル スワイプアクション
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let readLaterAction = UIContextualAction(style: .normal, title:"Later") { (action, view, completionHandler) in
            let fD = self.filteredFeedDatas[indexPath.row]
            if !fD.isReadLater {
                self.filteredFeedDatas[indexPath.row].isReadLater = true
                if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                    self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = true
                }
            } else {
                self.filteredFeedDatas[indexPath.row].isReadLater = false
                if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                    self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = false
                }
            }
            self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            completionHandler(true) // 実行結果に関わらず記述
        }
        readLaterAction.backgroundColor = UIColor.systemGreen // 編集ボタンの色を変更
        //readLaterAction.image = UIImage(named: "favorite")  // アクションボタンに画像を設定
        
        let favoriteAction = UIContextualAction(style: .normal, title:" Fav") { (action, view, completionHandler) in // https://qiita.com/JunichiHashimoto/items/5296d98b5e5a4bfbd6e3
            let fD = self.filteredFeedDatas[indexPath.row]
            if !fD.isFavorite {
                self.filteredFeedDatas[indexPath.row].isFavorite = true
                if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                    self.storedFeedDatas[indexInStoredFeedDatas].isFavorite = true
                }
            } else {
                self.filteredFeedDatas[indexPath.row].isFavorite = false
                if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                    self.storedFeedDatas[indexInStoredFeedDatas].isFavorite = false
                }
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
                let fD = self.filteredFeedDatas[indexPath.row]
                if !fD.isReadLater {
                    self.filteredFeedDatas[indexPath.row].isReadLater = true
                    if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                        self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = true
                    }
                } else {
                    self.filteredFeedDatas[indexPath.row].isReadLater = false
                    if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                        self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = false
                    }
                }
                self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            },
            // TODO: -  あとで読むに追加 or すでに追加済みアラートを出すfuncを起動
            UIAction(title: "Favorite") { _ in
                let fD = self.filteredFeedDatas[indexPath.row]
                if !fD.isFavorite {
                    self.filteredFeedDatas[indexPath.row].isFavorite = true
                    if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                        self.storedFeedDatas[indexInStoredFeedDatas].isFavorite = true
                    }
                } else {
                    self.filteredFeedDatas[indexPath.row].isFavorite = false
                    if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                        self.storedFeedDatas[indexInStoredFeedDatas].isFavorite = false
                    }
                }
                self.rssListTableView.reloadRows(at: [indexPath], with: UITableView.RowAnimation.none)
            }
        ])
    })
    }
}


