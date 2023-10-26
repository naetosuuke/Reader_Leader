//
//  ManageRSSChannelViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class ManageRSSChannelViewController: UIViewController {
    
    
    @IBOutlet weak var manageChannelsTableView: UITableView!
    
    
    var channels: [String]?
    var subscribedChannels: [String]?
    var addChannels: [String]?
    var channelCategory: [String]?
    // Sectionのタイトル
    let sectionTitle = ["Subscribed Channels", "Add Channels"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "RSS Feed Management"
        navigationItem.rightBarButtonItem = editButtonItem
        
        //配列ダミーデータ　あとでmodelから引っ張るよう書き換え
        channels = ["channel1", "channel2", "channel3", "channel4", "channel5", "channel6", "channel7", "channel8", "channel9", "channel10"]
        subscribedChannels = ["channel1", "channel2", "channel3",  "channel7", "channel8", "channel9", "channel10"]
        addChannels = channels?.filter { ch in // MARK: - filterメソッドの使い方　慣れてないので要確認(chatGPTで実装)
            guard let subscribedChannels = subscribedChannels else { return false }
            return !subscribedChannels.contains(ch)
        }
        channelCategory = ["Yahooニュース・トピックス"]
                           
        let nib = UINib(nibName: "CustomCellForSelectRSSTableView", bundle: nil) //cell登録
        // subscribed channels　設定
        manageChannelsTableView.delegate = self
        manageChannelsTableView.dataSource = self
        manageChannelsTableView.register(nib, forCellReuseIdentifier: "CustomCellForSelectRSSTableView")
        manageChannelsTableView.allowsSelectionDuringEditing = true
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) { //Editボタン押下時に発火　UIViewのisEditing状態をTableViewnに反映　https://qiita.com/am10/items/072857551c2c6ad5b2ed
        super.setEditing(editing, animated: animated)
        manageChannelsTableView.isEditing = editing
    }
}




extension ManageRSSChannelViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)

        //subscribed, addChannelsラベル
        let title = UILabel()
        title.text = sectionTitle[section]
        title.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        title.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        title.sizeToFit()
        headerView.addSubview(title)

        // title オートレイアウト
        title.translatesAutoresizingMaskIntoConstraints = false
        title.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        title.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true

        //RSSチャンネルのカテゴリラベル(今はYahooニューストピックスのみ)
        let channelCategoryTitle = UILabel()
        guard let cC = channelCategory else { return headerView}
        channelCategoryTitle.text = cC[0]
        channelCategoryTitle.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        channelCategoryTitle.backgroundColor = .quaternaryLabel
        channelCategoryTitle.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        channelCategoryTitle.sizeToFit()
        headerView.addSubview(channelCategoryTitle)

        // channelCategoryTitle オートレイアウト
        channelCategoryTitle.translatesAutoresizingMaskIntoConstraints = false
        channelCategoryTitle.centerXAnchor.constraint(equalTo: headerView.centerXAnchor).isActive = true
        channelCategoryTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10).isActive = true

        return headerView
    }
    
    // ヘッダーのたかさ
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
           return 80
       }

    //セルの数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{ //各sectionの番号で分岐　参考　https://i-app-tec.com/ios/tableview-section.html
        case 0:
            guard let sC = subscribedChannels else { return 0 } // アンラップ
            let cellCount = sC.count
            return cellCount
        case 1:
            guard let uC = addChannels else { return 0 } // アンラップ
            let cellCount = uC.count
            return cellCount
        default:
            let cellCount = 0
            return cellCount
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCellForSelectRSSTableView", for: indexPath) as! CustomCellForSelectRSSTableView
        switch indexPath.section { //sectionの番号で分岐
        case 0:
            guard let sC = subscribedChannels else { return cell } // アンラップ
            cell.nameLabel?.text = sC[indexPath.row]
            guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
            cell.iconImageView.image = img
        case 1:
            guard let aC = addChannels else { return cell } // アンラップ
            cell.nameLabel?.text = aC[indexPath.row]
            guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
            cell.iconImageView.image = img
            
        default:
            return cell
        }
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // FIXME: - ここに登録済み配列への追加、解除を行うメソッドを作る
        // if 登録済み配列の中にある　＝　該当の値をリストから削除、 else 該当の値をリストに追加
        viewDidLoad()
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
    }
    
    //Edit状態で、追加、削除を追加するシーン
    

    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        switch indexPath.section { //sectionの番号で分岐
        case 0: // subscribedChannels
            guard let sC: String = subscribedChannels?[indexPath.row] else { return }
            addChannels?.insert(sC, at: 0)
            subscribedChannels?.remove(at: indexPath.row) // MARK: - セルの追加、削除は直接行わず、配列の増減を行なった後にreloadDataを行う
            // FIXME: - subscribedChannel 通し番号(Key)順に整列させる
            tableView.reloadData()

        case 1: // addChannels
            guard let aC: String = addChannels?[indexPath.row] else { return }
            subscribedChannels?.insert(aC, at: 0)
            addChannels?.remove(at: indexPath.row)
            // FIXME: - addChannels 通し番号(Key)順に整列させる
            tableView.reloadData()
        default:
            return
        }
    }
}

                                
