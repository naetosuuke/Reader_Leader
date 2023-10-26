//
//  RSSCollectionViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class RSSCollectionViewController: UIViewController {

    // MARK: IBOutlets
    @IBOutlet weak var rssListCollectionView: UICollectionView!
    @IBOutlet weak var showSideViewButton: UIButton!
    @IBOutlet weak var moveToPreferenceButton: UIButton!
    
    // MARK: Properties
    var rssFeedsName: [String]?
    var rssFeedsData: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListCollectionView", bundle: nil)
        rssListCollectionView.backgroundColor = .clear
        rssListCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCellForRSSListCollectionView") //cell登録
        rssListCollectionView.delegate = self
        rssListCollectionView.dataSource = self

        
        rssFeedsName = ["article1", "article2", "article3", "article4","article5","article6","article7","article8","article9","article10"]
        rssFeedsData = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10"]
        
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
    }

    //FIXME: 検証用　sideボタン　本来はsideViewを呼び出すところ　仮でcollectionViewの呼び出しを行なっている。collectionViewの画面実装ができればsideView呼び出しに切り替え
    
    // MARK: Methods
    
    @IBAction func backToTableView(_ sender: Any) {
        self.navigationController?.popViewController(animated: true) //navigationController中の1つ前の階層にもどる
    }
    
    
}

extension RSSCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let rFN = rssFeedsName else { return 0 } // アンラップ
        let cellCount = rFN.count
        return cellCount
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // セルを取得する
        let cell = rssListCollectionView.dequeueReusableCell(withReuseIdentifier: "CustomCellForRSSListCollectionView", for: indexPath) as! CustomCellForRSSListCollectionView
        guard let rFN = rssFeedsName else { return cell } // アンラップ
        cell.articleLabel.text = rFN[indexPath.row]
        guard let rFD = rssFeedsData else { return cell } // アンラップ
        cell.dataLabel.text = rFD[indexPath.row]
        guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
        cell.iconImageView.image = img
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cell.layer.shadowRadius = 3.0 // ぼかし具合
        cell.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        
        return cell
    }
        
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //FIXME: URLを送る
        self.performSegue(withIdentifier: "ArticleViewControllerSegueFromCollectionView", sender: nil)
    }
    
    // サイズ調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 170, height: 340)
    }
 
    // 長押しで出る吹き出しメニュー https://developer.apple.com/documentation/uikit/uicollectionviewdelegate/4002186-collectionview
    // iOS14から使用可能
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? { return UIContextMenuConfiguration(actionProvider: { suggestedActions in
        
        return UIMenu(children: [
            // FIXME: -  お気に入りに追加 or すでに追加済みアラートを出すfuncを起動
            UIAction(title: "Favorite") { _ in /* Implement the action. */ },
            // FIXME: -  あとで読むに追加 or すでに追加済みアラートを出すfuncを起動
            UIAction(title: "Read Later") { _ in /* Implement the action. */ }
            ])
        })
    }
}
