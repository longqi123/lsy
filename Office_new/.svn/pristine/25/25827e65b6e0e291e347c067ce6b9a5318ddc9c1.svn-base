//
//  SendAssistantContentViewController.swift
//  Office
//
//  Created by roger on 2017/6/7.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class SendAssistantContentViewController: UIViewController {

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    var dataSource: [TxlModel1]!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "群发助手"
        contentLabel.textColor = UIColor.T2
        contentLabel.font = UIFont.H5
        var str = ""
        for data in dataSource {
            str.append(data.ryxm + " ")
        }
        contentLabel.text = str
        
        titleLabel.textColor = UIColor.T4
        titleLabel.font = UIFont.H5
        titleLabel.text = "你将发消息给\(dataSource.count)位好友"
        
        let inputView = CSInputView.init()
        self.view.addSubview(inputView)
        inputView.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.view.snp.bottom)
            make.width.equalTo(screenWidth)
            make.height.equalTo(44)
        })
        
        inputView.autoresizingMask = .flexibleTopMargin
        inputView.setInputConfig(nil)
        inputView.setInputActionDelegate(self)
    }
}

extension SendAssistantContentViewController: CSInputActionDelegate{
    func onSendText(_ text: String!) {        
        for data in dataSource {
            let message = NIMMessage()
            message.text = text
            let session = NIMSession.init(data.jsrydm, type: .P2P)
            
            do {
                try NIMSDK.shared().chatManager.send(message, to: session)
            } catch {
                ProgressHUD.toast(message: error.localizedDescription)
            }
        }
        self.navigationController?.popToRootViewController(animated: true)
        ProgressHUD.toast(message: "群发成功！")
    }
}
