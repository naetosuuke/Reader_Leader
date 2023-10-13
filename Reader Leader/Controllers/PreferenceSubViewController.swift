//
//  PreferenceSubViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class PreferenceSubViewController: UIViewController {
    

    @IBOutlet weak var subPreferenceTableView: UITableView!
    
    // MARK: - property
    var subPreferenceProperty: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preference"
        subPreferenceTableView.delegate = self
        subPreferenceTableView.dataSource = self
        subPreferenceTableView.isScrollEnabled = false // スクロール禁止
        subPreferenceProperty = ["pref1", "pref2", "pref3"] // FIXME: 前の画面で選択したセルによって、Tableに記入する内容がかわる その実装が完了したら消す
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Navigation
}



extension PreferenceSubViewController: UITableViewDelegate, UITableViewDataSource{
    //Cellの高さ
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    //セルの個数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let subPP = subPreferenceProperty else { return 0 } // アンラップ
        let cellcount = subPP.count
        return cellcount
    }
    //cellの中身を設定[preferencePropertyGroup1, preferencePropertyGroup2, preferencePropertyGroup3]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subPreferenceTableView.dequeueReusableCell(withIdentifier: "cellForSubPreferenceTableView", for:indexPath)
        guard let subPP = subPreferenceProperty else { return cell } // アンラップ
        cell.textLabel?.text = subPP[indexPath.row]
        return cell
    }
    
}

