//
//  ArticleViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/06.
//
// progressBar実装　リンク先参照　https://qiita.com/MilanistaDev/items/be545a5d6387c1e4a3ac
//
// This method should not be called on the main thread as it may lead to UI unresponsiveness.→バグのため無視
// https://ios-docs.dev/this-method-should/
//

// FIXME: - NavigationBarにWebViewが干渉して見ずらい。Barの下とWebView(とprogressBar)の上が同じ位置になるように修正

import UIKit
import WebKit

class ArticleViewController: UIViewController {


    @IBOutlet weak var articleWebView: WKWebView!

    // NavigationBarItem
    @IBOutlet weak var fontSizeChangeButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var progressBar: UIProgressView!

    // ToolBarItem
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var goButton: UIBarButtonItem!
    @IBOutlet weak var addFavoriteButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var goSafariButton: UIBarButtonItem!
    
    // MARK: - Property 
    
    var link = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        articleWebView.allowsBackForwardNavigationGestures = true //スワイプによる進む、戻るを許可する
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false // NavigationControllerのスワイプバックを無効化する
        // KVO 監視
        self.articleWebView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        self.articleWebView.addObserver(self, forKeyPath: "loading", options: .new, context: nil)
        
        // URL読み込み
        let url = URL(string: link)
        let request = URLRequest(url:url!)
        articleWebView.load(request)  // FIXME: - 通信はいるので、Main Threadで描写するように設定する

    }
    
    deinit { //画面遷移次に監視対象から外す
            self.articleWebView.removeObserver(self, forKeyPath: "estimatedProgress", context: nil)
            self.articleWebView.removeObserver(self, forKeyPath: "loading", context: nil)
        }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false

    }

    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true // NavigationControllerのスワイプバックを有効化する
    }
    
    
    // 監視しているWKWebViewのestimatedProgressの値をUIProgressViewに反映
    // TODO: Observer Patternとanimationの実装がわかっていないので、仕様の学習が必要。今回はコードを拝借して実装している。
    // https://qiita.com/MilanistaDev/items/be545a5d6387c1e4a3ac
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {

        if (keyPath == "estimatedProgress") {
            // alphaを1にする(表示)
            self.progressBar.alpha = 1.0
            // estimatedProgressが変更されたときにプログレスバーの値を変更
            self.progressBar.setProgress(Float(self.articleWebView.estimatedProgress), animated: true)

            // estimatedProgressが1.0になったらアニメーションを使って非表示にしアニメーション完了時0.0をセットする
            if (self.articleWebView.estimatedProgress >= 1.0) {
                UIView.animate(withDuration: 0.3,
                               delay: 0.3,
                               options: [.curveEaseOut],
                               animations: { [weak self] in
                                self?.progressBar.alpha = 0.0
                    }, completion: {
                        (finished : Bool) in
                        self.progressBar.setProgress(0.0, animated: false)
                })
            }
        }
    }
}
