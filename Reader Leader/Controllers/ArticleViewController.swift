//
//  ArticleViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//

import UIKit
import WebKit

class ArticleViewController: UIViewController {


    @IBOutlet weak var articleWebView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        let url = URL(string: "https://kyadx7.wixsite.com/naetos---workspace")
        let request = URLRequest(url:url!)
        articleWebView.load(request)
    }
    

}
