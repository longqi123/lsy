//
//  ConfirmController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class ConfirmController: UIViewController {
    
    var UUID = ""
    var DetailSource = [TZGGDetailModel]()
    var PersonSource = [TZGGDetailPersonModel]()
    var YesPersonSource = [TZGGDetailPersonModel]()
    var NoPersonSource = [TZGGDetailPersonModel]()
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "确认情况"
        creatUI()
        getData()
    }
}

extension ConfirmController{
    func creatUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.register(SendNotificationHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    func getData(){
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGCK", "s":"<tzgguuid>\(self.UUID)</tzgguuid><Fenye><FenyeVO><dqys>1</dqys><myts>5</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
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
            self.YesPersonSource = self.PersonSource.filter({$0.yhqrbj == "Y"})
            self.NoPersonSource = self.PersonSource.filter({$0.yhqrbj == "N"})
            self.tableView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}

extension ConfirmController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.NoPersonSource.count
        }else{
            return self.YesPersonSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = Bundle.main.loadNibNamed("ContactCell", owner: self, options: nil)?.last as! ContactCell
        if indexPath.section == 0 {
            if self.NoPersonSource[indexPath.row].sfsddxtz == "N"{
                cell.notification.text = "已发送通知"
            }else{
                cell.notification.text = "已收到短信提醒"
            }
            cell.nameLabel.text = self.NoPersonSource[indexPath.row].jsswrymc
            if self.NoPersonSource[indexPath.row].jsswrymc.characters.count > 2 {
                cell.photoLabel.text = (self.NoPersonSource[indexPath.row].jsswrymc as NSString).substring(with: NSMakeRange(self.NoPersonSource[indexPath.row].jsswrymc.characters.count - 2, 2))
            }else{
                cell.photoLabel.text = self.NoPersonSource[indexPath.row].jsswrymc
            }
            cell.photoLabel.backgroundColor = setNameBackColor(name: self.NoPersonSource[indexPath.row].jsswrymc, dm:self.NoPersonSource[indexPath.row].jsswryDm)
        }else{
            if self.YesPersonSource[indexPath.row].sfsddxtz == "N"{
                cell.notification.text = "已发送通知"
            }else{
                cell.notification.text = "已收到短信提醒"
            }
            cell.nameLabel.text = self.YesPersonSource[indexPath.row].jsswrymc
            if self.YesPersonSource[indexPath.row].jsswrymc.characters.count > 2 {
                cell.photoLabel.text = (self.YesPersonSource[indexPath.row].jsswrymc as NSString).substring(with: NSMakeRange(self.YesPersonSource[indexPath.row].jsswrymc.characters.count - 2, 2))
            }else{
                cell.photoLabel.text = self.YesPersonSource[indexPath.row].jsswrymc
            }
            cell.photoLabel.backgroundColor = setNameBackColor(name: self.YesPersonSource[indexPath.row].jsswrymc, dm:self.YesPersonSource[indexPath.row].jsswryDm)
        }
        cell.selectionStyle = .none
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! SendNotificationHeader
        if section == 0 {
            header.headerLab.text = "未确认"
        }else{
            header.headerLab.text = "已确认"
        }
        return header
    }
}
