//
//  TVideoListViewController.swift
//  T-Demo
//
//  Created by BeiTianSoftware on 2020/7/9.
//  Copyright © 2020 BeiTianSoftware .LLC. All rights reserved.
//

import UIKit
import Amplify
import AmplifyPlugins

class TVideoListViewController: TBaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        runAmplifyTest()
    }
    
    func runAmplifyTest() {
        let item = TUser(nickName: "Tom", account: "momo", priority: .high, description: "This is a test")
        
        Amplify.DataStore.save(item) { (result) in
            switch(result) {
            case .success(let savedItem):
                print("Saved item: \(savedItem.account)")
                
            case .failure(let err):
                print("Could not save item to datastore: \(err)")
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
