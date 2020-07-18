//
//  TLoginViewController.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import SVProgressHUD

class TLoginViewController: TBaseViewController {
    
    
    @IBOutlet weak var accountTextField: UITextField!
    
    @IBOutlet weak var pswTextField: UITextField!
    
    @IBOutlet weak var registeBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    // MARK: - Action
    
    @IBAction func registeBtnClicked(_ sender: Any) {
    }
    
    // 普通AWS 登录
    @IBAction func loginBtnClick(_ sender: Any) {
        let userManager = TDUserManager.sharedInstance
        userManager.login(acc: nil, psw: nil, type: .ACC_TYPE_AWS) { (success, err, msg) in
            if success == true {
                //登录成功了
                self.postLoginSuccNotification()
                self.dismiss(animated: true, completion: nil)
            }else {
                SVProgressHUD.showError(withStatus: msg)
            }
        }
    }
    
    // FB 登录
    @IBAction func fbLoginBtnClicked(_ sender: Any) {
        let userManager = TDUserManager.sharedInstance
        userManager.login(acc: nil, psw: nil, type: .ACC_TYPE_FACEBOOK) { (success, err, msg) in
            if success == true {
                //登录成功了
                self.postLoginSuccNotification()
                self.dismiss(animated: true, completion: nil)
            }else {
                SVProgressHUD.showError(withStatus: msg)
            }
        }
    }
    
    // MARK: - Notification
    func postLoginSuccNotification() {
        NotificationCenter.default.post(name: TD_LOGIN_SUCC_NOTIFICATION, object: nil)
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
