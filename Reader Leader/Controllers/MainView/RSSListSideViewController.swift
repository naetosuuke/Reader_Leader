//
//  RSSListSideViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class RSSListSideViewController: UIViewController {

    // MARK: - IBOutlets  複数TableViewの実装に際し、Storyboard上で各TableViewにタグ0,1を割当
    @IBOutlet weak var sortTableView: UITableView!
    @IBOutlet weak var categoryTableView: UITableView!
    
    // MARK: - Properties
    var sortProperty: [String]?
    var categoryProperty: [String]?
    var sectionTitle = ["MY FEEDS","CATEGORY"]
    
    // MARK: - ViewInit
    override func viewDidLoad() {
        super.viewDidLoad()
        sortProperty = ["All", "Unread", "Favorite", "Read Later"]
        categoryProperty = RSSChannelResource().rssChannelResource // FIXME: カテゴリは登録状況で動的に変更される。自分が登録したチャンネルをならべられるようにあとで差し替え
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.allowsMultipleSelection = false //　複数チェックを無効
        // TODO: ダークテーマ用の配色、分岐を行う。
        
    }
    
    override func viewWillAppear(_ animated: Bool) { 
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        // TODO: モデルとして分離
        if let darkMode = UserDefaults.standard.string(forKey: "DarkMode"){
            switch darkMode {
            case "light": self.overrideUserInterfaceStyle = .light
            case "dark": self.overrideUserInterfaceStyle = .dark
            default: print("dark theme ...match as devise setting")
            }
        }
    }
    
}


extension RSSListSideViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: - UITableView Delegate, Datasource Method
    //セクション数
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitle.count
    }
    
    //セクションのタイトル
    func tableView(_ tableView: UITableView,
                   titleForHeaderInSection section: Int) -> String? {
        return sectionTitle[section]
    }
    
    // ヘッダー生成
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 60)

        //subscribed, addChannelsラベル
        let title = UILabel()
        title.text = sectionTitle[section]
        title.font = UIFont.systemFont(ofSize: 26, weight: .bold)
        title.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        title.sizeToFit()
        headerView.addSubview(title)

        // title オートレイアウト
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true

        return headerView
    }
    
    // ヘッダーのたかさ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 60
       }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{ //各sectionの番号で分岐　参考　https://i-app-tec.com/ios/tableview-section.html
        case 0:
            guard let sC = sortProperty else { return 0 } // アンラップ
            let cellCount = sC.count
            return cellCount
        case 1:
            guard let uC = categoryProperty else { return 0 } // アンラップ
            let cellCount = uC.count
            return cellCount
        default:
            let cellCount = 0
            return cellCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForRSSListSideTableView", for: indexPath)
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // セル選択時　グレーにならない
        switch indexPath.section { //sectionの番号で分岐
        case 0:
            guard let sC = sortProperty else { return cell } // アンラップ
            cell.textLabel?.text = sC[indexPath.row]
        case 1:
            guard let aC = categoryProperty else { return cell } // アンラップ
            cell.textLabel?.text = aC[indexPath.row]
        default:
            return cell
        }
        if cell.textLabel!.text == UserDefaults.standard.string(forKey: "chosenCategoryForListView") {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for cell in tableView.visibleCells { //見えるセルを全て.none型に変える　chatGPT実装
            cell.accessoryType = .none
        }
        
        guard let cell = tableView.cellForRow(at:indexPath) else { return }
        cell.accessoryType = .checkmark
        UserDefaults.standard.set(cell.textLabel!.text, forKey: "chosenCategoryForListView") //UserDefaultにカテゴリ名を保存
        
//        NotificationCenter.default.post( // https://cpoint-lab.co.jp/article/201910/12386/ 押した後、ListViewをリロードして整列させ直す方法を考える(delegateか？)
//                    name: Notification.Name("SelectMenuNotification"),
//                    object: nil,
//                    userInfo: ["itemNo": indexPath.row] // 返したいデータをセットする
//                )
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
    }
}
