//
//  SendNotificationController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class SendNotificationController: UIViewController {
    
    var SendNotifiSource: [SendNotificationModel] = []
    var currentTime = ""
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "发送通知"
        Network.getSystemDate(success: {(time, timeString) in
            self.currentTime = timeString.dateFormate4.dateFormate1
        })
        creatUI()
        self.getData(swryDm: "25100000000")
    }
}

extension SendNotificationController{
    func creatUI() {
        let item2 = UIBarButtonItem(title: " +", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBtnClicked))
        self.navigationItem.rightBarButtonItem = item2
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
    func getData(swryDm:String){
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGLB", "s":"<TzgglbRequestForm><swryDm>\(swryDm)</swryDm><tzlb>fctz</tzlb></TzgglbRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>100</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let data = json["result"]["TzgglbfctzReturnVO"]["TzgglbfctzResponseFormlb"]["TzgglbfctzResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.SendNotifiSource = data.arrayValue.map(SendNotificationModel.init)
                }else{
                    self.SendNotifiSource = [JSONDeserializer<SendNotificationModel>.deserializeFrom(json:data.rawString())!]
                }
            }
           
            self.tableView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    
    func BackAudit(tzgguuid:String,tzggztDm:String,chrDm:String){ //撤回
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.CH", "s":"<TzggchRequestForm><tzgguuid>\(tzgguuid)</tzgguuid><tzggztDm>\(tzggztDm)</tzggztDm><chrDm>\(chrDm)</chrDm></TzggchRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            if json["result"]["returnBz"].stringValue == "1"{
                ProgressHUD.toast(message: "撤销成功")
                self.getData(swryDm: "25100000000")
            }else{
                ProgressHUD.toast(message: "撤销失败")
            }
            self.tableView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}

extension SendNotificationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.SendNotifiSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("auditCell", owner: self, options: nil)?.last as! auditCell
        cell.title.text = self.SendNotifiSource[indexPath.section].tzggbt
        cell.content.text = self.SendNotifiSource[indexPath.section].tzggnr
        cell.auditStatue.text = self.SendNotifiSource[indexPath.section].tzggztmc
        let timeStr = self.SendNotifiSource[indexPath.section].lrrq
        let timeStr1 = (timeStr as NSString).substring(to: 10)
        let timeStr2 = (timeStr as NSString).substring(from: 11)
        if timeStr1 != self.currentTime {
            cell.time.text = timeStr1
        }else{
            cell.time.text = timeStr2
        }
        cell.yiduStatue.isHidden = true
        if self.SendNotifiSource[indexPath.section].tzggztDm == "01" || self.SendNotifiSource[indexPath.section].tzggztDm == "02" || self.SendNotifiSource[indexPath.section].tzggztDm == "03"{
            cell.okBtn.setTitle("修改", for: .normal)
        }else if self.SendNotifiSource[indexPath.section].tzggztDm == "04"{
            cell.okBtn.setTitle("撤回", for: .normal)
        }else if self.SendNotifiSource[indexPath.section].tzggztDm == "06"{
            cell.okBtn.setTitle("确认情况", for: .normal)
        }else{
            cell.okBtn.isHidden = true
        }
        
        cell.ConfirmBlock = {[weak self] in
            if self?.SendNotifiSource[indexPath.section].tzggztDm == "01" || self?.SendNotifiSource[indexPath.section].tzggztDm == "02" || self?.SendNotifiSource[indexPath.section].tzggztDm == "03" {//修改
                let vc = ModifyNotificationController()
                vc.UUID = (self?.SendNotifiSource[indexPath.section].tzgguuid)!
                self?.navigationController?.pushViewController(vc, animated: true)
                
            }else if self?.SendNotifiSource[indexPath.section].tzggztDm == "04"{//撤回
                self?.BackAudit(tzgguuid: (self?.SendNotifiSource[indexPath.section].tzgguuid)!, tzggztDm: "02", chrDm: (DataCenter.ryxqModel?.jsrydm)!)
               
            }else if self?.SendNotifiSource[indexPath.section].tzggztDm == "06"{ //确认情况
                let vc = ConfirmController()
                vc.UUID = (self?.SendNotifiSource[indexPath.section].tzgguuid)!
                self?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NotificationContenController()
        vc.UUID = self.SendNotifiSource[indexPath.section].tzgguuid
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension SendNotificationController{
    func rightBtnClicked(){
        let vc = NewNotificationController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
