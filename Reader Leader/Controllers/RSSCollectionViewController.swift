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
    
    // MARK: Properties
    var rssFeedsName: [String]?
    var rssFeedsData: [String]?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "CustomCellForRSSListCollectionView", bundle: nil)
        rssListCollectionView.register(nib, forCellWithReuseIdentifier: "CustomCellForRSSListCollectionView") //cell登録
        rssListCollectionView.delegate = self
        rssListCollectionView.dataSource = self
        rssFeedsName = ["article1", "article2", "article3", "article4","article5","article6","article7","article8","article9","article10"]
        rssFeedsData = ["data1", "data2", "data3", "data4", "data5", "data6", "data7", "data8", "data9", "data10"]
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
        cell.layer.cornerRadius = 20
        
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        cell.layer.shadowRadius = 3.0 // ぼかし具合
        cell.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "ArticleViewControllerSegueFromCollectionView", sender: nil)
    }
    
    //サイズ調整
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 180, height: 360)
    }
 
    
}
