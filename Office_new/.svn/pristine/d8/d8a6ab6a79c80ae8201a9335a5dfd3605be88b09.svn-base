//
//  SendAssistantViewController.swift
//  Office
//
//  Created by roger on 2017/6/7.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class SendAssistantViewController: UIViewController {

    @IBOutlet weak var creatBtn: UIButton!
    @IBOutlet weak var tipsLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群发助手"
        creatBtn.backgroundColor = UIColor.B1;
        creatBtn.titleLabel?.textColor = UIColor.T6;
        creatBtn.titleLabel?.font = UIFont.H2;
        
        tipsLabel.textColor = UIColor.T4;
        tipsLabel.font = UIFont.H5;
        // Do any additional setup after loading the view.
    }

    @IBAction func CreatBtnClicked(_ sender: Any) {
        let vc = MessgeAddressListViewController()
        vc.PersonMaxiNum = 50
        vc.isSingleSelect = false
        vc.AddFringBlock = {[weak self] selectArr in
            print(selectArr.count)
            let vc = SendAssistantContentViewController()
            vc.dataSource = selectArr
            self?.navigationController?.pushViewController(vc, animated: true)
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
