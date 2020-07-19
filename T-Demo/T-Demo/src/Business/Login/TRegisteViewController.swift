//
//  TRegisteViewController.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/18.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import Amplify
import SVProgressHUD

class TRegisteViewController: TBaseViewController {

    
    @IBOutlet weak var accounTextField: UITextField!
    
    @IBOutlet weak var pswTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCurrentAuthSession()
        // Do any additional setup after loading the view.
    }
    
    func fetchCurrentAuthSession() {
        _ = Amplify.Auth.fetchAuthSession { result in
            switch result {
            case .success(let session):
                print("Is user signed in - \(session.isSignedIn)")
            case .failure(let error):
                print("Fetch session failed with error \(error)")
            }
        }
    }
    

    // MARK: - Action
    
    @IBAction func bgTapped(_ sender: UITapGestureRecognizer) {
        accounTextField.resignFirstResponder()
        pswTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    
    @IBAction func goBtnClicked(_ sender: Any) {
        
        //藏起键盘
        emailTextField.resignFirstResponder()
        
        let email = emailTextField.text
        let username = accounTextField.text
        let password = pswTextField.text
        
        let userAttributes = [AuthUserAttribute(.email, value: email!)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        SVProgressHUD.show(withStatus: "稍等片刻")
        _ = Amplify.Auth.signUp(username: username!, password: password!, options: options) { result in
            DispatchQueue.main.async {
                SVProgressHUD.dismiss()
            }
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("需要进一步验证: \(String(describing: deliveryDetails))")
                    DispatchQueue.main.async {
                        let codeConfirmVC = TCodeConfirmViewControllerStoryBoard()
                        codeConfirmVC.userName = self.accounTextField.text
                        codeConfirmVC.psw = self.pswTextField.text
                        self.navigationController?.pushViewController(codeConfirmVC, animated: true)
                    }
                } else {
                    //如果不需要验证邮箱，到这里就算注册成功了，这种情况先不考虑
                    print("SignUp Complete")
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
                DispatchQueue.main.async {
                    SVProgressHUD.showError(withStatus: "\(error.localizedDescription)")
                }
            }
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


func TRegisteViewControllerStoryBoard() -> TRegisteViewController {
    TDLoginStoryBoard().instantiateViewController(withIdentifier: "TRegisteViewController") as! TRegisteViewController
}
