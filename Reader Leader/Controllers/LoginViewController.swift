//
//  ViewController.swift
//  Reader Leader
//
//  Created by Daisuke Doi on 2023/10/04.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passwordInputField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var containerParentView: UIView!
    
    // MARK: ViewInit
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) { //キーボード　枠外タップで閉じる
        self.view.endEditing(true)
    }
    
    // MARK: - Methods
    private func setUpView() {
        containerParentView.layer.cornerRadius = 10.0
        containerParentView.layer.shadowColor = UIColor.black.cgColor
        containerParentView.layer.shadowOpacity = 0.2
        containerParentView.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        containerParentView.layer.shadowRadius = 3.0 // ぼかし具合
        
        emailInputField.layer.shadowColor = UIColor.black.cgColor
        emailInputField.layer.shadowOpacity = 0.2
        emailInputField.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        emailInputField.layer.shadowRadius = 3.0 // ぼかし具合
        
        passwordInputField.layer.shadowColor = UIColor.black.cgColor
        passwordInputField.layer.shadowOpacity = 0.2
        passwordInputField.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        passwordInputField.layer.shadowRadius = 3.0 // ぼかし具合
        
        loginButton.layer.cornerRadius = 10.0
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOpacity = 0.2
        loginButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        loginButton.layer.shadowRadius = 3.0 // ぼかし具合

        signUpButton.layer.cornerRadius = 10.0
        signUpButton.layer.shadowColor = UIColor.black.cgColor
        signUpButton.layer.shadowOpacity = 0.2
        signUpButton.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        signUpButton.layer.shadowRadius = 3.0 // ぼかし具合
        
        // FIXME: グラデーション　別のswiftファイルで定義
        let gradientLayer = CAGradientLayer()
        // グラデーションレイヤーの領域をviewと同じに設定
        gradientLayer.frame = self.view.bounds // boundsでなくframeにするとNavigationBarが表示される
        // グラデーション開始色
        let topColor = UIColor(red: 140/255, green: 255/255, blue: 241/255, alpha: 1).cgColor
        // グラデーション終了色
        let bottopColor = UIColor(red: 154/255, green: 170/255, blue: 224/255, alpha: 1).cgColor
        let gradientColors: [CGColor] = [topColor, bottopColor]
        gradientLayer.colors = gradientColors
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        // ビューにグラデーションレイヤーを追加
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
}

