//
//  NavigationController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/09.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "ページタイトル"
              // NavigationBarのスタイル設定（デフォルトは白の半透明）
              self.navigationController?.navigationBar.barStyle = .black
              // NavigationBarの半透明化（デフォルトはtrue）
              self.navigationController?.navigationBar.isTranslucent = false
              // NavigationItemの色設定（デフォルトは.barStyleによって黒か白）
              self.navigationController?.navigationBar.tintColor = UIColor.red


        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
