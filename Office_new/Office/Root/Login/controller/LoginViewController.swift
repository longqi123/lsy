//
//  LoginViewController.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework
import Toast

class LoginViewController: UITableViewController {
    var imageCell = LoginTopCell()
    var passCell: passAndNameCell!
    var usernameCell: passAndNameCell!
    var verifyCell: VerifyCell!
    var loginCell = LoginButtonCell()
    
    var username = ""
    var password = ""
    var code = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none

        imageCell = LoginTopCell()
        usernameCell = initUsernameCell()
        passCell = initPasswordCell()
        verifyCell = initVerifyCell()
        
    }

}

// MARK: - tableView
extension LoginViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            return imageCell
        } else if indexPath.row == 1 {
            return usernameCell
        } else if indexPath.row == 2 {
            return passCell
        } else if indexPath.row == 3 {
            return verifyCell
        } else {
            if loginCell.loginButton.allTargets.count == 0 {
                loginCell.loginButton.addTarget(self, action: #selector(login), for: .touchUpInside)
            }
            return loginCell
        }
    }

    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

}

// MARK: - Appearance
extension LoginViewController {
    func initUsernameCell() -> passAndNameCell {
        let cell = passAndNameCell()
        cell.textFiled.placeholder = "用户名／手机号"
        cell.textFiled.tag = 1000
        let imageView = UIImageView()
        imageView.image = UIImage.init(named:"user")
        imageView.contentMode = .center
        cell.textFiled.leftView = imageView
        cell.textFiled.text = "25109231221"
//        cell.textFiled.text = "25115001202"
        setDataValue(textField: cell.textFiled)
        cell.textFiled.addTarget(self, action: #selector(setDataValue(textField:)), for: .editingChanged)
        return cell
    }
    
    func initPasswordCell() -> passAndNameCell {
        let cell = passAndNameCell()
        cell.textFiled.placeholder = "密码"
        cell.textFiled.tag = 1001
        cell.textFiled.isSecureTextEntry = true
        let imageView = UIImageView()
        imageView.image = UIImage.init(named:"password")
        imageView.contentMode = .center
        cell.textFiled.leftView = imageView
        cell.textFiled.text = "ScdsJs528"
        setDataValue(textField: cell.textFiled)
        cell.textFiled.addTarget(self, action: #selector(setDataValue(textField:)), for: .editingChanged)

        return cell
    }
    
    func initVerifyCell() -> VerifyCell{
        let cell = VerifyCell()
        cell.textFiled.placeholder = "请输入验证码"
        cell.textFiled.tag = 1002
        let imageView = UIImageView()
        imageView.image = UIImage.init(named: "verify")
        imageView.contentMode = .center
        cell.textFiled.leftView = imageView
        cell.textFiled.addTarget(self, action: #selector(setDataValue(textField:)), for: .editingChanged)
        return cell
    }
}

extension LoginViewController {
    func setDataValue(textField: UITextField) {
        switch textField.tag - 1000 {
        case 0:
            username = textField.text!
        case 1:
            password = textField.text!
        case 2:
            code = textField.text!
        default:
            break
        }
    }
}

// MARK: - login
extension LoginViewController {
    
    /// 登录
    func login() {
        view.endEditing(true)
        
        guard username != "" else {
           _ = usernameCell.textFiled.becomeFirstResponder()
            usernameCell.textFiled.shake()
            return
        }
        
        guard password != "" else {
            _ = passCell.textFiled.becomeFirstResponder()
            passCell.textFiled.shake()
            return
        }
        
        guard code != "" else {
            _ = verifyCell.textFiled.becomeFirstResponder()
            verifyCell.textFiled.shake()
            return
        }
        
        DataCenter.username = username
        DataCenter.password = password

        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YHDLRZ", "s":"<dlzhDm>\(username)</dlzhDm><dlzhkl>\(password.getMd5().uppercased())</dlzhkl>","code": code], sid: "D1062", extra: [:])
        
        self.showloading(text: "登录中")
        Network.post(parameter: para, success: { (json) in
            print(json)
            let result = json["result"]
            let code: String
            if let errorCode = result["error"]["code"].string {
                code = errorCode
                ProgressHUD.toast(message: result["error"]["message"].stringValue)
                self.hideloading()
            } else {
                code = result["data"]["returnMsg"]["rtn_code"].stringValue
                if code == "0" {
                    DataCenter.dlzhxxModel = DlzhxxModel(json: result["data"]["dlzhxxForm"])
                    System.isLogin = true
                    self.getMyData()
                } else {
                    self.hideloading()
                }
            }

        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    
    /// 获取登录人员详情
    func getMyData() {
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.RYXQ","s":"<RyxqRequestForm><rydm></rydm><jsrydm>\(username)</jsrydm></RyxqRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { [weak self](json) in
            let result = json["result"]["RyxqReturnVO"]["RyxqResponseGridlb"]
            DataCenter.ryxqModel = RyxqModel(json: result)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getData"), object: nil)

            self?.loginIM()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    
    func loginIM(){
        
        let appKey2 = CSSDemoConfig.shared().appKey
        let cerName2 = CSSDemoConfig.shared().cerName
        NIMSDK.shared().register(withAppID: appKey2!, cerName: cerName2)
        NIMCustomObject.registerCustomDecoder(CSSCustomAttachmentDecoder())
        CSKit.shared().provider = CSSDataManager.sharedInstance()
        CSSLogManager.shared().start()
        
        
        func regiset(){
            
            let data = CSSRegisterData()
            data.account = DataCenter.username!
            data.nickname = DataCenter.ryxqModel?.ryxm
            data.token = DataCenter.username!.getMd5()
            //注册
            
            CSSDemoService.shared().registerUser(data, completion: {(error, errorMsg) in
                //注册成功
                if error == nil {
                    login2()
                    self.hideloading()
                }
                    //注册失败，或者已经注册用户
                else{
                    if errorMsg! == "帐号已注册" {
                        //登录会议
                        login2()
                    }else{
                        ProgressHUD.toast(message: errorMsg!)
                        self.hideloading()
                    }
                }
            })
            
            
        }
        
        func login2() {

            NIMSDK.shared().loginManager.login(DataCenter.username!, token:DataCenter.username!.getMd5(), completion: { (error) in
                
                if error == nil {
                    let sdkData = NTESLoginData()
                    sdkData.account = DataCenter.username!
                    sdkData.token = DataCenter.username!.getMd5()
                    CSSLoginManager.shared().currentNTESLoginData = sdkData
                    CSSServiceManager.shared().start()

                    UIApplication.shared.keyWindow?.rootViewController = RootViewController()
                }else{
                    
                    print(error.debugDescription)
                    if let str = error?.localizedDescription {
                        if str == "未能完成操作。（“NIMRemoteErrorDomain”错误 302。）" || str == "The operation couldn’t be completed. (NIMRemoteErrorDomain error 302.)"{
                            regiset()
                }
                    }
                }
            })
            
        }
        
        login2()

    }
}
