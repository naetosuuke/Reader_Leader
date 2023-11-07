//
//  SelectRSSChannelViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class SelectRSSChannelViewController: UIViewController{

    // MARK: - IBOutlets
    @IBOutlet weak var label: UIView!
    @IBOutlet weak var launchRSSListButton: UIButton!
    @IBOutlet weak var selectRSSTableView: UITableView!
    

    // MARK: - Properties
    var rssChannels: [String]?
    
    // MARK: - VIewInit
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        selectRSSTableView.backgroundColor = view.backgroundColor
        let nib = UINib(nibName: "CustomCellForSelectRSSTableView", bundle: nil)
        selectRSSTableView.register(nib, forCellReuseIdentifier: "CustomCellForSelectRSSTableView") //cell登録
        selectRSSTableView.delegate = self
        selectRSSTableView.dataSource = self
        rssChannels = RSSChannelResource().rssChannelResource
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
    }
    

    // MARK: - Methods
    private func setUpView() {
        launchRSSListButton.layer.cornerRadius = 10.0
        launchRSSListButton.layer.shadowColor = UIColor.black.cgColor
        launchRSSListButton.layer.shadowOpacity = 0.2
        launchRSSListButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        launchRSSListButton.layer.shadowRadius = 3.0 // ぼかし具合
        launchRSSListButton.layer.masksToBounds = false // これを入れないと影が反映されない https://cpoint-lab.co.jp/article/202110/21167/
        
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
    
    
    
    
    @IBAction func moveToListView(_ sender: Any) {
        print(UserDefaults.standard.string(forKey: "ListType")! )
        switch UserDefaults.standard.string(forKey: "ListType") {
        case "table style" :
            self.performSegue(withIdentifier: "moveToTableView_AfterRegistration", sender: nil)
        case "collection style" :
            self.performSegue(withIdentifier: "moveToCollectionView_AfterRegistration", sender: nil)
        default:
            self.performSegue(withIdentifier: "moveToTableView", sender: nil)
            print("ListType is not loaded from UserDefaults correctry")
            print("ListType = ", UserDefaults.standard.string(forKey: "ListType")! )
        }
    }
}


extension SelectRSSChannelViewController:UITableViewDelegate, UITableViewDataSource{
    // MARK: - UITableView Delegate, Datasource Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let rc = rssChannels else { return 0 } // アンラップ
        let cellCount = rc.count
        return cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellForSelectRSSTableView", for: indexPath) as! CustomCellForSelectRSSTableView
        guard let rc = rssChannels else { return cell } // アンラップ
        cell.nameLabel.text = rc[indexPath.row]
        guard let img = UIImage(named: "yahoo") else { return cell } // アンラップ
        cell.iconImageView.image = img
        cell.iconImageView.layer.cornerRadius = 10
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // 選択時のグレー色変化をやらない
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        if cell?.accessoryType == .checkmark { // チェック済、未チェックで分岐
            cell?.accessoryType = .none
            // FIXME: - ここにUserDefaultにChannelの登録状況を保存/上書きする処理をかく
        } else {
            cell?.accessoryType = .checkmark
            // FIXME: - ここにUserDefaultにChannelの登録状況を保存/上書きする処理をかく
        }
    }
}
