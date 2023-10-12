//
//  PreferenceViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class PreferenceViewController: UIViewController {

    @IBOutlet weak var preferenceTableView: UITableView!
    
    // MARK: - property
    let preferenceProperty = ["RSS List Type", "RSS Reload Interval", "RSS Feed Management", "Charactar Size", "Dark Mode","Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preference"
        preferenceTableView.delegate = self
        preferenceTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Navigation
}



extension PreferenceViewController: UITableViewDelegate, UITableViewDataSource{
    //Cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellcount = preferenceProperty.count
        return cellcount
    }
    //cellの中身を設定[preferencePropertyGroup1, preferencePropertyGroup2, preferencePropertyGroup3]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = preferenceTableView.dequeueReusableCell(withIdentifier: "cellForPreferenceTableView", for:indexPath)
        cell.textLabel?.text = preferenceProperty[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //遷移先に渡すURLを取得、prepareで次の画面に渡す
        
        // 画面遷移
        self.performSegue(withIdentifier: "PreferenceSubViewControllerSegue", sender: nil)
    }
    
    
}

