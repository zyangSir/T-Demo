//
//  TCodeConfirmViewController.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/18.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import Amplify
import SVProgressHUD

let TD_REGISTER_SUCC_NOTIFICATION = NSNotification.Name(rawValue: "TD_REGISTER_SUCC")
class TCodeConfirmViewController: TBaseViewController {
    
    var userName: String?
    var psw: String?
    
    @IBOutlet weak var confirmCodeTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    //MARK: - Action
    
    @IBAction func goBtnClicked(_ sender: Any) {
        SVProgressHUD.show(withStatus: "稍等片刻")
        confirmCodeTextField.resignFirstResponder()
        confirmSignUp(for: userName!, with: confirmCodeTextField.text!)
    }
    
    func confirmSignUp(for username: String, with confirmationCode: String) {
        _ = Amplify.Auth.confirmSignUp(for: username, confirmationCode: confirmationCode) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            switch result {
            case .success(_):
                print("Confirm signUp succeeded")
                DispatchQueue.main.async {
                    self.navigationController?.popToRootViewController(animated: true)
                    SVProgressHUD.showSuccess(withStatus: "注册完成!")
                    self.postRegisteSuccessNotification()
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "注册失败: \(error)")
                }
            }
        }
    }
    
    
    func postRegisteSuccessNotification() {
        let noti = NotificationCenter.default
        noti.post(name: TD_REGISTER_SUCC_NOTIFICATION, object: ["userName": userName!, "psw": psw!])
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

func TCodeConfirmViewControllerStoryBoard() -> TCodeConfirmViewController {
    TDLoginStoryBoard().instantiateViewController(withIdentifier: "TCodeConfirmViewController") as! TCodeConfirmViewController
}
