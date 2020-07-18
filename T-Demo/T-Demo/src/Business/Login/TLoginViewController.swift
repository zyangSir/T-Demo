//
//  TLoginViewController.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit

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
    }
    
    // FB 登录
    @IBAction func fbLoginBtnClicked(_ sender: Any) {
        
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
