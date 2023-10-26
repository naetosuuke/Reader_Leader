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
    var sectionTitle = ["MY FEEDS","CATEGORY"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sortProperty = ["All", "Unread", "Favorite", "Read Later"]
        categoryProperty = ["主要", "国内", "国際", "経済", "エンタメ"]// FIXME: カテゴリは登録状況で動的に変更される。自分が登録したチャンネルをならべられるようにあとで差し替え
        sortTableView.delegate = self
        sortTableView.dataSource = self
        sortTableView.allowsMultipleSelection = false //　複数チェックを無効

    }
    
    override func viewWillAppear(_ animated: Bool) { //FIXME: ハーフでなくフル表示して戻るために実装　検証後、削除
        navigationController?.navigationBar.isHidden = false
    }
    
}


extension RSSListSideViewController: UITableViewDelegate, UITableViewDataSource {

    
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
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        cell?.accessoryType = .checkmark
        // FIXME: - ここに登録済み配列への追加、解除を行うメソッドを作る
        // if 登録済み配列の中にある　＝　該当の値をリストから削除、 else 該当の値をリストに追加
        

    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
    }
    
    
    
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch tableView.tag { //各tableViewのタグで分岐
//            case 0:
//                guard let sP = sortProperty else { return 0 } // アンラップ
//                let cellCount = sP.count
//                return cellCount
//            case 1:
//                guard let cP = categoryProperty else { return 0 } // アンラップ
//                let cellCount = cP.count
//                return cellCount
//            default:
//                let cellCount = 0
//                return cellCount
//        }
//
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        // セルを取得する
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CellForRSSListSideTableView", for: indexPath)
//        switch tableView.tag { //各tableViewのタグで分岐
//            case 0:
//                guard let sP = sortProperty else { return cell } // アンラップ
//                cell.textLabel?.text = sP[indexPath.row]
//            case 1:
//                guard let cp = categoryProperty else { return cell } // アンラップ
//                cell.textLabel?.text = cp[indexPath.row]
//            default:
//                return cell
//        }
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at:indexPath)
//        // チェックマークを入れる
//        cell?.accessoryType = .checkmark
//        //お気に入り、未読、あとで読む、各カテゴリでソートをかける
//        // FIXME: - ここにUserDefaultに保存する設定を上書きする処理をかく
//        // FIXME: - NavigationController上　1つ前の画面にソート用のIdentifierをわたしてviewdidloadを再度行うよう実装
//    }
//
//    // セルの選択が外れた時に呼び出される
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at:indexPath)
//        // チェックマークを外す
//        cell?.accessoryType = .none
//    }
//
}
