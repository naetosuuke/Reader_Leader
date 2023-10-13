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
    var preferenceProperty: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preference"
        preferenceTableView.delegate = self
        preferenceTableView.dataSource = self
        preferenceTableView.isScrollEnabled = false // スクロール禁止
        preferenceProperty = ["RSS List Type", "RSS Reload Interval", "RSS Feed Management", "Charactar Size", "Dark Mode","Log Out"] // FIXME: 前の画面で選択したセルによって、Tableに記入する内容がかわる その実装が完了したら消す
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
        guard let PP = preferenceProperty else { return 0 } // アンラップ
        let cellcount = PP.count
        return cellcount
    }
    //cellの中身を設定[preferencePropertyGroup1, preferencePropertyGroup2, preferencePropertyGroup3]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = preferenceTableView.dequeueReusableCell(withIdentifier: "cellForPreferenceTableView", for:indexPath)
        guard let PP = preferenceProperty else { return cell } // アンラップ
        cell.textLabel?.text = PP[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // channel選択画面への遷移
        if indexPath.row == 2 {
            self.performSegue(withIdentifier: "ManageRSSChannelViewControllerSegue", sender: nil)
        // ログアウト、最初の画面へ戻る
        } else if indexPath.row == 5 {
            let alert = UIAlertController(title: "Log Out and Back to Log In Page", message: "Please Confirm again..", preferredStyle: .actionSheet)
            let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popToRootViewController(animated: true) // NavigationControllerの最初の画面へ移動
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (acrion) in
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            alert.addAction(cancel)
            present(alert, animated: true, completion: nil)
            

        } else {
            // その他　設定画面への遷移
            self.performSegue(withIdentifier: "PreferenceSubViewControllerSegue", sender: nil)
        }
        
        
            
    }
    
    
}

