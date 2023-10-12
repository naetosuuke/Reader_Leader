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
    let preferenceProperty = ["subPreferenceProperty1", "SubPreferenceProperty2"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Preference"
        subPreferenceTableView.delegate = self
        subPreferenceTableView.dataSource = self
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
        let cellcount = preferenceProperty.count
        return cellcount
    }
    //cellの中身を設定[preferencePropertyGroup1, preferencePropertyGroup2, preferencePropertyGroup3]
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = subPreferenceTableView.dequeueReusableCell(withIdentifier: "cellForSubPreferenceTableView", for:indexPath)
        cell.textLabel?.text = preferenceProperty[indexPath.row]
        return cell
    }
    
}

