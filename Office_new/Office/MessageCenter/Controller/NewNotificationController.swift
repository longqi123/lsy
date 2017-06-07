
//
//  NewNotificationController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class NewNotificationController: UIViewController {
    var titleStr = ""
    var contentStr = ""
    var switchON = false
    var auditPerson = ""
    var stopTime = ""
    var remindContent = ""
    var currentTime = ""
    var selectDataSource: [TxlModel1] = []
    var personNumArray:Array<Any>!
    var OrganizationArr:Array<Any>!
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    var selectedDate = Date(){
        didSet{
            let df = DateFormatter()
            df.timeStyle = .short
            df.dateStyle = .full
            df.dateFormat = "yyyy-MM-dd HH:mm"
            let date = df.string(from: selectedDate)
            self.stopTime = date
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新建通知"
        self.auditPerson = (DataCenter.ryxqModel?.zsldmc)!
        Network.getSystemDate(success: {(time, timeString) in
            let str = (timeString as NSString).substring(to: 16)
            self.currentTime = str.dateFormate1
        })
        self.creatUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.selectDataSource = DataCenter.AdddataSource
        self.tableView.reloadData()
    }
}

extension NewNotificationController{
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
    }
}

extension NewNotificationController: UITableViewDelegate,UITableViewDataSource{
    
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
                cell.title.text = "接收人"
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
                    if self.stopTime.isEmpty {
                        cell.content.text = self.currentTime
                    }else{
                        cell.content.text = self.stopTime
                    }
                    
                }else{
                    cell.title.text = "提醒"
                    cell.content.text = "截止前15分钟"
                }
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = AddaddressViewController()
                vc.AdddataSource = DataCenter.AdddataSource
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }else if indexPath.section == 2 {
            let vc = MyLeaderViewController()
            vc.MyLeaderBlock = {[weak self] model in
                self?.auditPerson = model.ryxm
                self?.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }else if  indexPath.section == 3 {
            if indexPath.row == 1 { //时间选择
                DatePickerView.show(selected: selectedDate, {[weak self] (date) in
                    self?.selectedDate = date
                    self?.tableView.reloadData()
                })
            }else if indexPath.row == 2{ //提醒
            
            }
        }
    }
}
extension NewNotificationController{
    func rightBtnClicked(){//发送
        DataCenter.AdddataSource.removeAll()
    
    }
    
    func leftBtnClicked(){//取消
        let alertController = UIAlertController(title: "", message: "是否保存为草稿?",preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let deleteAction =  UIAlertAction(title: "保存", style: .destructive) { (baocun) in
            DataCenter.AdddataSource.removeAll()
            
        }
        let archiveAction =  UIAlertAction(title: "不保存", style: .default) { (baocun) in
            DataCenter.AdddataSource.removeAll()
            self.navigationController?.popViewController(animated: true)
        }
        let messageFont = UIFont.H6
        let messageAttribute = NSMutableAttributedString.init(string: "是否保存为草稿?")
        messageAttribute.addAttributes([NSFontAttributeName:messageFont,
                                      NSForegroundColorAttributeName:UIColor.T1],
                                     range:NSMakeRange(0, 8))
        alertController.setValue(messageAttribute, forKey: "attributedMessage")
        cancelAction.setValue(UIColor.T1, forKey:"titleTextColor")
        deleteAction.setValue(UIColor.T1, forKey:"titleTextColor")
        archiveAction.setValue(UIColor.T8, forKey:"titleTextColor")
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        alertController.addAction(archiveAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    func save(){
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGBC", "s":"<TzggbcRequestForm><tzggbt>\(self.titleStr)</tzggbt><tzggnr>\(self.contentStr)</tzggnr><tzggztDm>01</tzggztDm><jsswryDmList><jsswryDmListGridlb>25100000001</jsswryDmListGridlb><jsswryDmListGridlb>25100000002</jsswryDmListGridlb></jsswryDmList><jsjgDmList><jsjgDmListGridlb>127053478</jsjgDmListGridlb><jsjgDmListGridlb>127077515</jsjgDmListGridlb></jsjgDmList><jzrq>\(self.stopTime)</jzrq><sfszrw>Y</sfszrw><txsj>2017-5-26 23:51:10</txsj><lrrDm>25100000000</lrrDm></TzggbcRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            
            }) { (error) in
                self.hideloading()
                ProgressHUD.toast(message: error)
        }
    }
    func getPerson() -> String {//拼接选择人员字段组
        self.personNumArray = (self.selectDataSource.map{ $0.jsrydm})
        var str = ""
        for (_,item) in self.personNumArray.enumerated() {
            str += "<YtdxxcxLB>"
            str += "<sxid>\(item)</sxid>"
            str += "</YtdxxcxLB>"
        }
        return str
    }

    func getOrganization() -> String {//拼接组织机构字段组
        var str = ""
        for (_,item) in self.OrganizationArr.enumerated() {
            str += "<YtdxxcxLB>"
            str += "<sxid>\(item)</sxid>"
            str += "</YtdxxcxLB>"
        }
        return str
    }
}