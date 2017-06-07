//
//  NotificationDetailController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SwiftyJSON
import HandyJSON

class NotificationDetailController: UIViewController {
    
    var UUID = ""
    var DetailSource: [TZGGDetailModel] = []
    var PersonSource: [TZGGDetailPersonModel] = []
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知详情"
        getData()
    }
}

extension NotificationDetailController{
    func creatUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
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
            self.creatUI()
            self.tableView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}

extension NotificationDetailController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("OrganizationCell", owner: self, options: nil)?.last as! OrganizationCell
                cell.title.text = self.DetailSource[0].tzggbt
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.isUserInteractionEnabled = false
                return cell
            }else{
                let cell = Bundle.main.loadNibNamed("NotificationDetailCell", owner: self, options: nil)?.last as! NotificationDetailCell
                cell.content.text = self.DetailSource[0].tzggnr
                cell.isUserInteractionEnabled = false
                return cell
            }
        }else if indexPath.section == 1{
             let cell = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
            if indexPath.row == 0 {
                cell.title.text = "发送人"
                cell.content.text = self.DetailSource[0].fbrmc
            }else{
                cell.title.text = "发送时间"
                cell.content.text = self.DetailSource[0].fbrq.dateFormate4.dateFormate1
            }
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
}
