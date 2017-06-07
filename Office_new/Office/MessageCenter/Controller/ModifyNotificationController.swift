//
//  ModifyNotificationController.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class ModifyNotificationController: UIViewController {
    var titleStr = ""
    var contentStr = ""
    var switchON = false
    var auditPerson = ""
    var UUID = ""
    var selectDataSource: [TxlModel1] = []
    var DetailSource: [TZGGDetailModel] = []
    var PersonSource: [TZGGDetailPersonModel] = []
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "修改通知"
        self.auditPerson = (DataCenter.ryxqModel?.zsldmc)!
        creatUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectDataSource = DataCenter.AdddataSource
        self.tableView.reloadData()
    }
}

extension ModifyNotificationController{
    func creatUI() {
        let item1 = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item1
        
        let item2 = UIBarButtonItem(title: "发送", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBtnClicked))
        self.navigationItem.rightBarButtonItem = item2
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.register(NotificationPersonCell.self, forCellReuseIdentifier: "NotificationPersonCellID")
    }
}

extension ModifyNotificationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 1
        }else{
            if switchON == false {
                return 1
            }else{
                return 3
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }else if indexPath.section == 1{
            return 40
        }else if indexPath.section == 2{
            return 40
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("NewNotificationCell1", owner: self, options: nil)?.last as! NewNotificationCell1
            cell.CintentBlock = {[weak self] content,title in
                self?.titleStr = title
                self?.contentStr = content
            }
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let cell  = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
                cell.title.text = "通知人员"
                cell.content.text = "\(self.selectDataSource.count)人"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
            
        }else if indexPath.section == 2{
            let cell  = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
            cell.title.text = "审批人"
            cell.content.text = self.auditPerson
            cell.accessoryType = .disclosureIndicator
            return cell
        }else{
            if indexPath.row == 0 {
                let cell  = Bundle.main.loadNibNamed("NotificationPersonCell4", owner: self, options: nil)?.last as! NotificationPersonCell4
                cell.title.text = "设为任务"
                cell.switchONClick = {[weak self] switchON in
                    self?.switchON = switchON
                    self?.tableView.reloadData()
                }
                if self.switchON == false {
                    cell.switck.isOn = false
                    
                }else{
                    cell.switck.isOn = true
                }
                return cell
                
            }else{
                let cell  = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
                if indexPath.row == 1 {
                    cell.title.text = "截止时间"
                    cell.content.text = "2018-12-22"
                }else{
                    cell.title.text = "提醒"
                    cell.content.text = "截止前15分钟"
                }
                cell.accessoryType = .disclosureIndicator
                return cell            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = HaveAcceptController()
                vc.AdddataSource = DataCenter.AdddataSource
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        if indexPath.section == 2 {
            let vc = MyLeaderViewController()
            vc.MyLeaderBlock = {[weak self] model in
                self?.auditPerson = model.ryxm
                self?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension ModifyNotificationController{
    func rightBtnClicked(){//发送
        
    }
    
    func leftBtnClicked(){//取消
        let alertController = UIAlertController(title: "", message: "是否保存为草稿?",preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction =  UIAlertAction(title: "保存", style: .destructive) { (baocun) in
            
            
        }
        let archiveAction =  UIAlertAction(title: "不保存", style: .default) { (baocun) in
            
            self.navigationController?.popViewController(animated: true)
        }
        let messageFont = UIFont.systemFont(ofSize: 15)
        let messageAttribute = NSMutableAttributedString.init(string: "是否保存为草稿?")
        messageAttribute.addAttributes([NSFontAttributeName:messageFont,
                                        NSForegroundColorAttributeName:UIColor.black],
                                       range:NSMakeRange(0, 7))
        alertController.setValue(messageAttribute, forKey: "attributedMessage")
        cancelAction.setValue(UIColor.black, forKey:"titleTextColor")
        deleteAction.setValue(UIColor.black, forKey:"titleTextColor")
        archiveAction.setValue(UIColor.orange, forKey:"titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
}
