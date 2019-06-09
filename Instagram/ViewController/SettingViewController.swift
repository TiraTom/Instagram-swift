//
//  SettingViewController.swift
//  Instagram
//
//  Created by masao on 2019/06/07.
//  Copyright © 2019 TiraTom. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase
import SVProgressHUD

class SettingViewController: UIViewController {

    @IBOutlet weak var displayNameTextField: UITextField!
    
    // 表示名更新処理
    @IBAction func handleChangeButton(_ sender: Any) {
        if let displayName = displayNameTextField.text {
            
            // 表示名が空の時はHUDを出して何もしない
            if displayName.isEmpty {
                print("DEBUG_PRINT: 表示名欄が空です")
                SVProgressHUD.showError(withStatus: "表示名欄を入力してください")
                return
            }
            
            let user = Auth.auth().currentUser
            if let user = user {
                let changeRequest = user.createProfileChangeRequest()
                changeRequest.displayName = displayName
                changeRequest.commitChanges(){ error in
                    if let error = error {
                        print("DEBUG_PRINT: " + error.localizedDescription)
                        SVProgressHUD.showError(withStatus: "表示名の更新でエラーが発生しました")
                        return
                    }
                    print("DEBUG_PRINT: 表示名[displayName = \(user.displayName!)]の更新に成功しました")
                    SVProgressHUD.showSuccess(withStatus: "表示名を更新しました")
                }
            }
        }
        
        // キーボードを閉じる
        self.view.endEditing(true)
        
    }
    
    // ログアウト処理
    @IBAction func handleLogoutButton(_ sender: Any) {
        try! Auth.auth().signOut()
        
        // ログイン画面を表示
        let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
        self.present(loginViewController!, animated: true, completion: nil)
        
        // ログイン画面から戻ってきた時用に、ホーム画面を選択した状態にしておく
        let tabBarController = parent as! ESTabBarController
        tabBarController.setSelectedIndex(0, animated: false) 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // 表示名を取得してTextFieldに設定する
        let user = Auth.auth().currentUser
        if let user = user {
            displayNameTextField.text = user.displayName
        }
        
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
