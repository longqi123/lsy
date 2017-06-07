//
//  NotificationContenController.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SwiftyJSON
import HandyJSON

class NotificationContenController: UIViewController {
    var titleStr = ""
    var contentStr = ""
    var switchON = false
    var UUID = ""
    var DetailSource: [TZGGDetailModel] = []
    var PersonSource: [TZGGDetailPersonModel] = []
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知详情"
        self.getData()
    }
}

extension NotificationContenController{
    func creatUI() {
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
    func getData(){
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGCK", "s":"<tzgguuid>\(self.UUID)</tzgguuid><Fenye><FenyeVO><dqys>1</dqys><myts>100</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let data = json["result"]["TzggcktzReturnVO"]["TzggcktzResponseGridlb"]
            let personData = json["result"]["TzggckryReturnVO"]["TzggckryResponseFormlb"]["TzggckryResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.DetailSource = data.arrayValue.map(TZGGDetailModel.init)
                }else{
                    self.DetailSource = [JSONDeserializer<TZGGDetailModel>.deserializeFrom(json:data.rawString())!]
                }
            }
            if personData.count > 0{
                if personData.array != nil{
                    self.PersonSource = personData.arrayValue.map(TZGGDetailPersonModel.init)
                }else{
                    self.PersonSource = [JSONDeserializer<TZGGDetailPersonModel>.deserializeFrom(json:personData.rawString())!]
                }
            }
            self.creatUI()
            self.tableView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }

}

extension NotificationContenController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else if section == 2{
            return 5
        }else{
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 160
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                return 45
            }
        }else if indexPath.section == 2{
            if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3  {
                return 45
            }else {
                return 100
            }
        
        }else if indexPath.section == 3{
            return 45
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("NewNotificationCell1", owner: self, options: nil)?.last as! NewNotificationCell1
            cell.titleText.text = self.DetailSource[0].tzggbt
            cell.contentText.text = self.DetailSource[0].tzggnr
            cell.CintentBlock = {[weak self] content,title in
                self?.titleStr = title
                self?.contentStr = content
            }
            cell.placehoderLab.isHidden = true
            cell.isUserInteractionEnabled = false
            cell.selectionStyle = .none
            return cell
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let cell  = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
                cell.title.text = "选择接收人"
                cell.accessoryType = .disclosureIndicator
                cell.content.text = "\(self.PersonSource.count)人"
                cell.selectionStyle = .none
                return cell

            }
            
        }else if indexPath.section == 2{
            let cell  = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
            if indexPath.row == 0 {
                cell.title.text = "审批人"
                cell.content.text = self.DetailSource[0].sprmc
            }else if indexPath.row == 1{
                cell.title.text = "审批结果"
                cell.content.text = self.DetailSource[0].spjg
            }else if indexPath.row == 2{
                cell.title.text = "审批时间"
                cell.content.text = self.DetailSource[0].sprq
            }else if indexPath.row == 3{
                cell.title.text = "审批意见"
                cell.content.text = ""
            }else if indexPath.row == 4{
                let celll = Bundle.main.loadNibNamed("AuditOpinionCell", owner: self, options: nil)?.last as! AuditOpinionCell
                celll.placeLab.isHidden = true
                celll.content.text = self.DetailSource[0].spyj
                celll.content.isUserInteractionEnabled = false
                cell.isUserInteractionEnabled = false
                return celll
            }
            cell.content.isUserInteractionEnabled = false
            cell.content.textAlignment = .right
            cell.isUserInteractionEnabled = false
            return cell
        }else if indexPath.section == 3{
           
            let cell  = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
            if indexPath.row == 1 {
                cell.title.text = "截止时间"
                cell.content.text = self.DetailSource[0].jzrq
            }else{
                cell.title.text = "提醒"
                cell.content.text = self.DetailSource[0].txsj
            }
                cell.isUserInteractionEnabled = false
                return cell
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
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                let vc = HaveAcceptController2()
                vc.PersonSource = self.PersonSource
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
