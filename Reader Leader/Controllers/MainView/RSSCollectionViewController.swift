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
    var storedFeedDatas = [FeedData]()
    var feedData: FeedData?
    var channelLinks = ["https://news.yahoo.co.jp/rss/topics/domestic.xml", "https://news.yahoo.co.jp/rss/topics/world.xml"]
    
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
        navigationController?.navigationBar.isHidden = true
        async {
            let fetchedFeedDatas = await RSSFeedParser().downloadAndParseXML(channelLinks: channelLinks)
            let checkedFeedDatas = RSSFeedHandler().checkDuplicationAndStoreDatas(fetchedFeedDatas: fetchedFeedDatas, storedFeedDatas: storedFeedDatas)
            storedFeedDatas.append(contentsOf: checkedFeedDatas)
            rssListCollectionView.reloadData()
        }
    }
    // TODO: お気に入りのみ表示する場合は、XMLの取得、パース手配が不要になる。UserDefaultからFeedDatasを呼び出す別メソッドを用意しなければならない
    
    // MARK: - Methods
    private func setUpView() {
        showSideViewButton.layer.cornerRadius = 10.0
        moveToPreferenceButton.layer.cornerRadius = 10.0
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
    
    // TODO: 検証用　sideボタン　本来はsideViewを呼び出すところ　仮でcollectionViewの呼び出しを行なっている。collectionViewの画面実装ができればsideView呼び出しに切り替え
    @IBAction func backToTableView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true) //navigationController中の1つ前の階層にもどる
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
        let fD = storedFeedDatas[indexPath.row] // feed情報を読み込む
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
        cell.isReadLater = fD.isReadLater
        if cell.isReadLater {
            cell.flagLabel.text! += "🔖"
        }
        cell.isFavorite = fD.isFavorite
        if cell.isFavorite {
            cell.flagLabel.text! += "⭐️"
        }
        
        
        guard let img = UIImage(named: "yahoo") else { return cell } // FIXME: 対象のURLからHTMLソースを入手し、サムネイルが入った要素から画像データを抽出してimgに当てる (作業が重そうだったので今回はパス)
        cell.iconImageView.image = img
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cell.layer.shadowRadius = 3.0 // ぼかし具合
        cell.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) { // Segueを実行し、URLをWebViewControllerに渡す
        let fD = storedFeedDatas[indexPath.row] // セルと対応するindex番号のfeedDataをインスタンス化
        let url = URL(string:fD.link)
        if let url = url {
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }
    
    // サイズ調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 340)
    }
    
    // 長押しで出る吹き出しメニュー https://developer.apple.com/documentation/uikit/uicollectionviewdelegate/4002186-collectionview
    // iOS14から使用可能
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? { return UIContextMenuConfiguration(actionProvider: { suggestedActions in
        
        return UIMenu(children: [
            UIAction(title: "Read Later") { _ in
                for indexPath in indexPaths {
                    let fD = self.storedFeedDatas[indexPath.row]
                    if !fD.isReadLater {
                        self.storedFeedDatas[indexPath.row].isReadLater = true
                    } else {
                        self.storedFeedDatas[indexPath.row].isReadLater = false
                    }
                    self.rssListCollectionView.reloadItems(at: [indexPath])
                }
            },
            UIAction(title: "Favorite") { _ in
                for indexPath in indexPaths {
                    let fD = self.storedFeedDatas[indexPath.row]
                    if !fD.isFavorite {
                        self.storedFeedDatas[indexPath.row].isFavorite = true
                    } else {
                        self.storedFeedDatas[indexPath.row].isFavorite = false
                    }
                    self.rssListCollectionView.reloadItems(at: [indexPath])
                }
            }
        ])
    })
    }
}
