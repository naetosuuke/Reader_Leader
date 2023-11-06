//
//  PreferenceViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class PreferenceViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var preferenceTableView: UITableView!
    
    // MARK: - Properties
    var preferenceProperty: [String]?
    
    // MARK: - ViewInit
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preference"
        preferenceTableView.delegate = self
        preferenceTableView.dataSource = self
        preferenceTableView.isScrollEnabled = false // スクロール禁止
        preferenceProperty = ["RSS List Type", "RSS Reload Interval", "RSS Feed Management", "Charactar Size", "Dark Mode","Log Out"] // FIXME: 前の画面で選択したセルによって、Tableに記入する内容がかわる その実装が完了したら消す
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - Navigation
    
    
}


extension PreferenceViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: - UITableView Delegate, Datasource Method
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
    //cellの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = preferenceTableView.dequeueReusableCell(withIdentifier: "cellForPreferenceTableView", for:indexPath)
        guard let PP = preferenceProperty else { return cell } // アンラップ
        cell.textLabel?.text = PP[indexPath.row] // PreferencePropertyを渡す
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // セル選択時　グレーにならない
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        
        case 0: // RSS List Type
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PreferenceSubViewController") as! PreferenceSubViewController
            nextVC.preferenceIdentifier = "ListType"
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 1: // RSS Reload Interval
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PreferenceSubViewController") as! PreferenceSubViewController
            nextVC.preferenceIdentifier = "ReloadInterval"
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 2: // RSS Feed Management
            
            self.performSegue(withIdentifier: "ManageRSSChannelViewControllerSegue", sender: nil)

        case 3: // Charactar Size
        
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PreferenceSubViewController") as! PreferenceSubViewController
            nextVC.preferenceIdentifier = "CharacterSize"
            self.navigationController?.pushViewController(nextVC, animated: true)

        case 4: // Dark Mode
            let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "PreferenceSubViewController") as! PreferenceSubViewController
            nextVC.preferenceIdentifier = "DarkMode"
            self.navigationController?.pushViewController(nextVC, animated: true)
            
        case 5: // Log Out
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
            
        default:
            // その他　設定画面への遷移
            fatalError("unexpected indexPath")
        }
        
    }
    
}

