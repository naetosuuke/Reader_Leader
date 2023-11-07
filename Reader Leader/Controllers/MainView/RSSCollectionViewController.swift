//
//  RSSCollectionViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit
import SafariServices

class RSSCollectionViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var rssListCollectionView: UICollectionView!
    @IBOutlet weak var showSideViewButton: UIButton!
    @IBOutlet weak var moveToPreferenceButton: UIButton!
    
    // MARK: - Properties
    private var storedFeedDatas = [FeedData]()
    private var filteredFeedDatas = [FeedData]()
    private var channelLinks = ["https://news.yahoo.co.jp/rss/topics/domestic.xml", "https://news.yahoo.co.jp/rss/topics/world.xml"]
    
    // MARK: - ViewInit
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListCollectionView", bundle: nil)
        rssListCollectionView.backgroundColor = .clear
        rssListCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCellForRSSListCollectionView") //cell登録
        rssListCollectionView.delegate = self
        rssListCollectionView.dataSource = self
        setUpView() // layout, layer実装
        
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
            self.rssListCollectionView.reloadData()
        }
    }

    
    // MARK: - Methods
    private func setUpView() {
        showSideViewButton.layer.cornerRadius = 10.0
        moveToPreferenceButton.layer.cornerRadius = 10.0
        let gradientLayer = CAGradientLayer()
        // グラデーションレイヤーの領域をviewと同じに設定
        gradientLayer.frame = self.view.frame
        // グラデーション開始色 // TODO: ダークテーマ用の配色、分岐を行う。
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
}

extension RSSCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let cellCount = storedFeedDatas.count
        return cellCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Xibでつくったセル情報を読みこむ
        let cell = rssListCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellForRSSListCollectionView", for: indexPath) as! CustomCellForRSSListCollectionView
        let fD = storedFeedDatas[indexPath.item] // feed情報を読み込む
        // TODO: - ここにソート用の分岐を作成する(お気に入り、未読、既読、各カテゴリによってfeedDataの取捨選択をする)
        
        cell.articleLabel.text = fD.title
        cell.dataLabel.text = fD.pubDate // FIXME: 20xx/xx/xx(date) 等　見やすい形に変換する
        cell.categoryLabel.text = fD.category
        cell.link = fD.link
        
        cell.flagLabel.text = ""
        cell.isRead = fD.isRead
        if !cell.isRead {
            cell.flagLabel.text! += "🔵"
        } else {
            cell.backgroundColor = UIColor.lightGray
        }
        cell.isReadLater = fD.isReadLater
        if cell.isReadLater {
            cell.flagLabel.text! += "🔖"
        }
        cell.isFavorite = fD.isFavorite
        if cell.isFavorite {
            cell.flagLabel.text! += "⭐️"
        }
        if let characterSize = UserDefaults.standard.string(forKey: "CharacterSize") { //設定により文字サイズ調整
            switch characterSize {
            case "min":
                cell.articleLabel.font = UIFont.systemFont(ofSize: 13) //フォントサイズのみ変更　!! cell.articleLabel.font.withSize(11) → withSizeは既存の文字のサイズを上書きできない(ChatGPT回答) https://qiita.com/shocho0101/items/678aef624fbcf87b5a51
                cell.dataLabel.font = UIFont.systemFont(ofSize: 9)
                cell.categoryLabel.font = UIFont.systemFont(ofSize: 9)
                cell.flagLabel.font = UIFont.systemFont(ofSize:13)
            case "mid":
                cell.articleLabel.font = UIFont.systemFont(ofSize: 15)
                cell.dataLabel.font = UIFont.systemFont(ofSize: 11)
                cell.categoryLabel.font = UIFont.systemFont(ofSize: 11)
                cell.flagLabel.font = UIFont.systemFont(ofSize: 15)
            case "max":
                cell.articleLabel.font = UIFont.systemFont(ofSize: 20)
                cell.dataLabel.font = UIFont.systemFont(ofSize: 16)
                cell.categoryLabel.font = UIFont.systemFont(ofSize: 16)
                cell.flagLabel.font = UIFont.systemFont(ofSize: 20)
                // cell.textLabel?.adjustsFontSizeToFitWidth = true //入らなかったらこれ使う
            default:
                print("characterSize has unexpected value")
                print(characterSize)
            }
        }
        
        guard let img = UIImage(named: "yahoo") else { return cell } // FIXME: 対象のURLからHTMLソースを入手し、サムネイルが入った要素から画像データを抽出してimgに当てる (作業が重そうだったので今回はパス)
        cell.iconImageView.image = img

        cell.layer.cornerRadius = 30
//        cell.layer.shadowColor = UIColor.black.cgColor
//        cell.layer.shadowOpacity = 0.2
//        cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//        cell.layer.shadowRadius = 3.0 // ぼかし具合
//        cell.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // Segueを実行し、URLをWebViewControllerに渡す
        let fD = self.filteredFeedDatas[indexPath.row]
        self.filteredFeedDatas[indexPath.row].isRead = true // 既読フラグつける
        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {// TODO: TableViewに表示しているデータはソート済の配列なので、ソート前の元データが持つフラグも同時に更新するように、firstIndexを用いて実装している。ただしコードが冗長になってる気がするので、もっと短く書く or ModelsのRSSFeedHandlerに分離したい
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
    
    // サイズ調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 340)
    }
    
    // 長押しで出る吹き出しメニュー https://developer.apple.com/documentation/uikit/uicollectionviewdelegate/4002186-collectionview
    // iOS14から使用可能
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? { return UIContextMenuConfiguration(actionProvider: { suggestedActions in
        
        return UIMenu(children: [
            UIAction(title: "Read Later") { _ in
                for indexPath in indexPaths {
                    let fD = self.storedFeedDatas[indexPath.item]
                    if !fD.isReadLater {
                        self.storedFeedDatas[indexPath.item].isReadLater = true
                        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                            self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = true
                        }
                    } else {
                        self.storedFeedDatas[indexPath.item].isReadLater = false
                        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                            self.storedFeedDatas[indexInStoredFeedDatas].isReadLater = false
                        }
                    }
                    self.rssListCollectionView.reloadItems(at: [indexPath])
                }
            },
            UIAction(title: "Favorite") { _ in
                for indexPath in indexPaths {
                    let fD = self.storedFeedDatas[indexPath.item]
                    if !fD.isFavorite {
                        self.storedFeedDatas[indexPath.item].isFavorite = true
                        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                            self.storedFeedDatas[indexInStoredFeedDatas].isFavorite = true
                        }
                    } else {
                        self.storedFeedDatas[indexPath.item].isFavorite = false
                        if let indexInStoredFeedDatas = self.storedFeedDatas.firstIndex(where: { $0.title == fD.title }) {
                            self.storedFeedDatas[indexInStoredFeedDatas].isFavorite = false
                        }
                    }
                    self.rssListCollectionView.reloadItems(at: [indexPath])
                }
            }
        ])
    })
    }
}
