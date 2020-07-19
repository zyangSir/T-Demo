//
//  TRegisteViewController.swift
//  T-Demo
//
//  Created by 张杨清 on 2020/7/18.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import Amplify

class TRegisteViewController: TBaseViewController {

    
    @IBOutlet weak var accounTextField: UITextField!
    
    @IBOutlet weak var pswTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: - Action
    @IBAction func goBtnClicked(_ sender: Any) {
        
        let email = emailTextField.text
        let username = accounTextField.text
        let password = pswTextField.text
        
        let userAttributes = [AuthUserAttribute(.email, value: email!)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        _ = Amplify.Auth.signUp(username: username!, password: password!, options: options) { result in
            switch result {
            case .success(let signUpResult):
                if case let .confirmUser(deliveryDetails, _) = signUpResult.nextStep {
                    print("Delivery details \(String(describing: deliveryDetails))")
                } else {
                    print("SignUp Complete")
                    
                    let codeConfirmVC = TCodeConfirmViewControllerStoryBoard()
                    self.navigationController?.pushViewController(codeConfirmVC, animated: true)
                }
            case .failure(let error):
                print("An error occurred while registering a user \(error)")
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
