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
    
    deinit {
        unRegisteNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        registeNotification()
    }
    
    // MARK: - Notification
    func registeNotification() {
        //监测登录成功通知
        let noti = NotificationCenter.default
        noti.addObserver(self, selector: #selector(onRegisteSuccess(noti:)), name: TD_REGISTER_SUCC_NOTIFICATION, object: nil)
    }
    
    func unRegisteNotification() {
        //移除通知
        let noti = NotificationCenter.default
        noti.removeObserver(self, name: TD_REGISTER_SUCC_NOTIFICATION, object: nil)
    }
    
    @objc func onRegisteSuccess(noti: Notification) {
        //自动填充注册好的账号，密码
        let info = noti.object as! Dictionary<String, String>
        accountTextField.text = info["userName"]
        pswTextField.text = info["psw"]
        
        
    }
    
    
    // MARK: - Action
    
    @IBAction func registeBtnClicked(_ sender: Any) {
        let registeVC = TRegisteViewControllerStoryBoard()
        self.navigationController?.pushViewController(registeVC, animated: true)
    }
    
    // 普通AWS 登录
    @IBAction func loginBtnClick(_ sender: Any) {
        let userManager = TDUserManager.sharedInstance
        SVProgressHUD.show(withStatus: "稍等片刻")
        userManager.login(acc: accountTextField.text, psw: pswTextField.text, type: .ACC_TYPE_AWS) { (success, err, msg) in
            SVProgressHUD.dismiss()
            if success == true {
                //登录成功了
                DispatchQueue.main.async {
                    self.postLoginSuccNotification()
                    self.dismiss(animated: true, completion: nil)
                }
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
