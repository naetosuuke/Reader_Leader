//
//  PreferenceSubViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit

class PreferenceSubViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var subPreferenceTableView: UITableView!
    
    // MARK: - Properties
    var subPreferenceProperty: [String]?
    var preferenceIdentifier: String?
    
    // MARK: - ViewInit
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preference"
        subPreferenceTableView.delegate = self
        subPreferenceTableView.dataSource = self
        subPreferenceTableView.isScrollEnabled = false // スクロール禁止
        subPreferenceTableView.allowsMultipleSelection = false //　複数チェックを無効
        guard let preferenceIdentifier = self.preferenceIdentifier else { return }
        switch preferenceIdentifier {
        
        case "ListType":
            subPreferenceProperty = ["collection", "list"]
            
        case "ReloadInterval":
            subPreferenceProperty = ["30m", "60m", "120m"]
            
        case "CharacterSize":
            subPreferenceProperty = ["min", "mid", "max"]

        case "DarkMode":
            subPreferenceProperty = ["light", "dark", "match as device setting "]

        default:
            fatalError("unexpected preference identidfier")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }

    
}

extension PreferenceSubViewController: UITableViewDelegate, UITableViewDataSource{
    // MARK: - UITableView Delegate, Datasource Method
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
    //cellの中身を設定
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subPreferenceTableView.dequeueReusableCell(withIdentifier: "cellForSubPreferenceTableView", for:indexPath)
        guard let subPP = subPreferenceProperty else { return cell } // アンラップ
        cell.textLabel?.text = subPP[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none // セル選択時　グレーにならない
        // TODO: - UserDefaultに選択された文字列と、セルのsubPreferencePropertyが一致していればaccessoryTypeを.checkmarkに設定する。
        return cell
    }
    
    // セルが選択された時に呼び出される
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを入れる
        cell?.accessoryType = .checkmark
        // TODO: - UserDefaultに選択されたセルのsubPreferenceProperty文字列を登録
    }
    
    // セルの選択が外れた時に呼び出される
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        // チェックマークを外す
        cell?.accessoryType = .none
    }
    
}

