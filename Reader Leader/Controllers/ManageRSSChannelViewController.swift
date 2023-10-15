//
//  ManageRSSChannelViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class ManageRSSChannelViewController: UIViewController {


    @IBOutlet weak var manageChannelsTableView: UITableView!


    
    //MARK: TableViewの高さを動的に設定し、その値を利用してScrollViewの高さもコードで設定する
    
    
    var subscribedChannels: [String]?
    var unsubscribedChannels: [String]?
    var channelCategory: [String]?
    // Sectionのタイトル
    let sectionTitle = ["SubscribedChannels", "UnSubscribedChannels"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "RSS Feed Management"

        //配列ダミーデータ　あとでmodelから引っ張るよう書き換え
        subscribedChannels = ["channel1 subscribed", "channel2 subscribed", "channel3 subscribed",  "channel7 subscribed", "channel8 subscribed", "channel9 subscribed", "channel10 subscribed"]
        unsubscribedChannels = ["channel4 unsubscribed", "channel5 unsubscribed", "channel6 unsubscribed"]
        channelCategory = ["Yahooニュース・トピックス"]
        let nib = UINib(nibName: "CustomCellForSelectRSSTableView", bundle: nil) //cell登録
        
        // subscribed channels　設定
        manageChannelsTableView.delegate = self
        manageChannelsTableView.dataSource = self
        manageChannelsTableView.register(nib, forCellReuseIdentifier: "CustomCellForSelectRSSTableView")
    
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
        headerView.backgroundColor = .systemBackground
        headerView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100)

        //subscribed, unsubscribedラベル
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
        channelCategoryTitle.backgroundColor = .gray
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
            guard let uC = unsubscribedChannels else { return 0 } // アンラップ
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
            guard let uC = unsubscribedChannels else { return cell } // アンラップ
            cell.nameLabel?.text = uC[indexPath.row]
            guard let img = UIImage(named: "KariImage") else { return cell } // アンラップ
            cell.iconImageView.image = img
        default:
            return cell
        }
        return cell
    }
}

