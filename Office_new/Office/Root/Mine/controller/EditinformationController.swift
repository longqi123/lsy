//
//  EditinformationController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/19.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class  EditinformationController: UIViewController {
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var footView:PersonaldetailView!
    var qq = ""
    var wechat = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人详情"
        self.CreatUI()
        qq = (DataCenter.ryxqModel?.qqzh)!
        wechat = (DataCenter.ryxqModel?.wxzh)!
    }
}
extension  EditinformationController {
    func CreatUI(){
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:  #selector(setMyAccount))
        navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view).offset(50)
        }
    }
}

extension EditinformationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = Bundle.main.loadNibNamed("EditpersonalinformationCell", owner: self, options: nil)?.first as? EditpersonalinformationCell
        if indexPath.row == 0 {
            cell?.title.text = "姓名"
            cell?.content.text = DataCenter.ryxqModel?.ryxm
            cell?.content.isUserInteractionEnabled = false
            cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }else if indexPath.row == 1 {
            cell?.title.text = "电话"
            cell?.content.text = DataCenter.ryxqModel?.sj
            cell?.content.isUserInteractionEnabled = false
               
        }else if indexPath.row == 2 {
            cell?.title.text = "座机"
            cell?.content.text = DataCenter.ryxqModel?.jtdh
            cell?.content.isUserInteractionEnabled = false
                
        }else if indexPath.row == 3 {
            cell?.title.text = "邮箱"
            cell?.content.text = DataCenter.ryxqModel?.dzyj
            cell?.content.isUserInteractionEnabled = false
                
        }else if indexPath.row == 4 {
            cell?.title.text = "部门"
            cell?.content.text = DataCenter.ryxqModel?.swjgmc
            cell?.content.isUserInteractionEnabled = false
            cell?.accessoryType = .disclosureIndicator
                
        }else if indexPath.row == 5 {
            cell?.title.text = "职务"
            cell?.content.text = DataCenter.ryxqModel?.dutyname
            cell?.content.isUserInteractionEnabled = false
                
        }else if indexPath.row == 6 {
            cell?.title.text = "QQ"
            cell?.content.text = DataCenter.ryxqModel?.qqzh
            cell?.content.tag = 201
            cell?.content.addTarget(self, action: #selector(setDataValue(textField:)), for: .editingChanged)
            
        }else if indexPath.row == 7 {
            cell?.title.text = "微信"
            cell?.content.text = DataCenter.ryxqModel?.wxzh
            cell?.content.tag = 202
            cell?.content.addTarget(self, action: #selector(setDataValue(textField:)), for: .editingChanged)

        }
        cell?.selectionStyle = .none
        return cell!
    }
}

extension EditinformationController {
    
    func setDataValue(textField: UITextField) {
        switch textField.tag - 200 {
        case 1:
            qq = textField.text!
        case 2:
            wechat = textField.text!
        default:
            break
        }
    }
   
}

extension EditinformationController {
    func setMyAccount() {
        
        guard let rydm = DataCenter.ryxqModel?.rydm  else {
            return
        }
        guard let zsldmc = DataCenter.ryxqModel?.zsldmc, let zslddm = DataCenter.ryxqModel?.zsldDm else {
            return
        }

        let para: [String: Any]
        var s = ""
        
        s += "<RykzxxbjRequestForm>"
        s += "<rydm>\(rydm)</rydm>"
        s += "<qqzh>\(qq)</qqzh>"
        s += "<wxzh>\(wechat)</wxzh>"
        s += "<zsldDm>\(zslddm)</zsldDm>"
        s += "<zsldmc>\(zsldmc)</zsldmc>"
        s += "</RykzxxbjRequestForm>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.RYKZXXBJ", "s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            print(json)

            DataCenter.ryxqModel?.qqzh = self.qq
            DataCenter.ryxqModel?.wxzh = self.wechat
            let returnMsg = json["result"]["returnMsg"].stringValue
            let returnBz = json["result"]["returnBz"].stringValue
            if returnBz == "0" {
                ProgressHUD.toast(message: returnMsg)
            } else {
                self.navigationController?.popViewController(animated: true)
                ProgressHUD.toast(message: "修改成功")
            }
            self.hideloading()
        }) { (error) in
            print(error)
        }
    }
}

