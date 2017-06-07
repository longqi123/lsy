//
//  NewReceiveNotifiViewController.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class NewReceiveNotifiViewController: UIViewController {
    var selectBtn: UIButton!
    var myTabView = BaseTableView(frame: .zero, style: .grouped)
    var lineView:UIView!
    var status:NSInteger!
    var wspData = "5"  //未审批
    var wckData = "5"  //未查看
    var wssData = "5"  //未送审
    var currentTime = ""  //当前时间
    var ReceiveNotifiSource = [ReceiveNotificationModel]()
    var RuditNotifiSource = [AuditNotificationModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        status = 1
        self.title = "收到通知"
        self.creatUI()

        Network.getSystemDate(success: {(time, timeString) in
            self.currentTime = timeString.dateFormate4.dateFormate1
        })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getData()
    }
    func creatUI(){
        for i in 0...1 {
            self.selectBtn = UIButton()
            self.selectBtn.frame = CGRect(x:CGFloat(i)*screenWidth/2, y: 0, width: screenWidth/2, height: 44)
            self.selectBtn.backgroundColor = UIColor.white
            self.selectBtn.titleLabel?.font = .H5
            self.selectBtn.addTarget(self, action: #selector(selectBtnClick(_:)), for: .touchUpInside)
            if i == 0 {
                self.selectBtn.isSelected = true
                self.selectBtn.setTitle("查看(\(self.wckData))", for: .normal)
            }else{
                self.selectBtn.isSelected = false
                self.selectBtn.setTitle("审批(\(self.wspData))", for: .normal)
            }
            self.selectBtn.setTitleColor(.T7, for: .selected)
            self.selectBtn.setTitleColor(.T2, for: .normal)
            self.selectBtn.tag = 1000 + i
            self.view.addSubview(self.selectBtn)
        }
        self.lineView = UIView()
        lineView.backgroundColor = .T7
        lineView.frame = CGRect(x: (screenWidth/2 - 100)/2, y: 45, width: 100, height: 2)
        self.view.addSubview(self.lineView)
        
        view.addSubview(myTabView)
        myTabView.delegate = self
        myTabView.dataSource = self
        myTabView.separatorStyle = .singleLine
        myTabView.tableFooterView = UIView()
        
        myTabView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(self.lineView.snp.bottom)
        }
    }
    func getData(){  //查询未读条数
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGCX", "s":"<swryDm>25100000000</swryDm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.wckData = json["result"]["TzggcxReturnVO"]["TzggcxwcktzResponseGrid"]["wcksl"].stringValue
            self.wspData = json["result"]["TzggcxReturnVO"]["TzggcxwsptzResponseGrid"]["wspsl"].stringValue
            self.wssData = json["result"]["TzggcxReturnVO"]["TzggcxwsstzResponseGrid"]["wsssl"].stringValue
            (self.view.viewWithTag(1000) as! UIButton).setTitle("查看(\(self.wckData))", for: .normal)
            (self.view.viewWithTag(1001) as! UIButton).setTitle("审批(\(self.wspData))", for: .normal)
            self.getDataList(tzlb: "sdtz", swryDm:"25107272103") //上传参数sdtz fctz sptz
            self.getDataList(tzlb: "sptz", swryDm:"25100000004")
            
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    
    func getDataList(tzlb:String,swryDm:String){ //获取列表
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGLB", "s":"<TzgglbRequestForm><swryDm>\(swryDm)</swryDm><tzlb>\(tzlb)</tzlb></TzgglbRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>100</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let receivedata = json["result"]["TzgglbsdtzReturnVO"]["TzgglbsdtzResponseFormlb"]["TzgglbsdtzResponseGridlb"]
            let auditData = json["result"]["TzgglbsptzReturnVO"]["TzgglbsptzResponseFormlb"]["TzgglbsptzResponseGridlb"]
            if receivedata.count > 0{
                if receivedata.array != nil{
                    self.ReceiveNotifiSource = receivedata.arrayValue.map(ReceiveNotificationModel.init)
                }else{
                    self.ReceiveNotifiSource = [JSONDeserializer<ReceiveNotificationModel>.deserializeFrom(json:receivedata.rawString())!]
                }
            }
            if auditData.count > 0{
                if auditData.array != nil{
                    self.RuditNotifiSource = auditData.arrayValue.map(AuditNotificationModel.init)
                }else{
                    self.RuditNotifiSource = [JSONDeserializer<AuditNotificationModel>.deserializeFrom(json:auditData.rawString())!]
                }
            }
            self.myTabView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    func ConfirmReceipt(tzgguuid:String,jsswryDm:String){ //确认收到
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.QRSD", "s":"<TzggqrsdRequestForm><tzgguuid>\(tzgguuid)</tzgguuid><jsswryDm>\(jsswryDm)</jsswryDm></TzggqrsdRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            if json["result"]["returnBz"].stringValue == "1"{
                ProgressHUD.toast(message: "确认收到成功")
                self.getDataList(tzlb: "sdtz", swryDm:"25107272103")
            }else{
                ProgressHUD.toast(message: "确认收到失败")
            }
            
            self.myTabView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    func CancelAudit(tzgguuid:String,tzggztDm:String){ //撤销
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.CX", "s":"<TzggcxRequestForm><tzgguuid>\(tzgguuid)</tzgguuid><tzggztDm>07</tzggztDm></TzggcxRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            if json["result"]["returnBz"].stringValue == "1"{
                ProgressHUD.toast(message: "撤销成功")
                self.getDataList(tzlb: "sptz", swryDm:"25100000004")
            }else{
                ProgressHUD.toast(message: "撤销失败")
            }
            
            self.myTabView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}
extension NewReceiveNotifiViewController{
    func selectBtnClick(_ button:UIButton){
        if button.tag == 1000 {
            for i in 0...1 {
                (self.view.viewWithTag(1000 + i) as! UIButton).isSelected = false
            }
            button.isSelected = true
            UIView.animate(withDuration: 0.2, animations: {
                self.lineView.frame = CGRect(x: (screenWidth/2 - 100)/2, y: 45, width: 100, height: 2)
            })
            self.status = 1
            myTabView.reloadData()
        }else{
            for i in 0...1 {
                (self.view.viewWithTag(1000 + i) as! UIButton).isSelected = false
            }
            button.isSelected = true
            UIView.animate(withDuration: 0.2, animations: {
                self.lineView.frame = CGRect(x: screenWidth/2 + (screenWidth/2 - 100)/2, y: 45, width: 100, height: 2)
            })
            self.status = 2
            myTabView.reloadData()
        }
    }
}

extension NewReceiveNotifiViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if status == 1 {
            return self.ReceiveNotifiSource.count
        }else{
            return self.RuditNotifiSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.status == 1 {
            let cell = Bundle.main.loadNibNamed("SendNotificationControllerCell", owner: self, options: nil)?.last as! SendNotificationControllerCell
            
            cell.title.text = self.ReceiveNotifiSource[indexPath.section].tzggbt
            cell.content.text = self.ReceiveNotifiSource[indexPath.section].tzggnr
            let timeStr = self.ReceiveNotifiSource[indexPath.section].fbrq
            let timeStr1 = (timeStr as NSString).substring(to: 10)
            let timeStr2 = (timeStr as NSString).substring(from: 11)
            if timeStr1 != self.currentTime {
                cell.time.text = timeStr1
            }else{
                cell.time.text = timeStr2
            }
            cell.yiduStatule.isHidden = true
            if self.ReceiveNotifiSource[indexPath.section].yhqrbj == "Y" {
                cell.okBtn.isHidden = true
            }else{
                cell.okBtn.setTitle("确认收到", for: .normal)
            }
            cell.ConfirmBlock = {[weak self] in  //确认按钮点击
                self?.ConfirmReceipt(tzgguuid: (self?.ReceiveNotifiSource[indexPath.section].tzgguuid)!, jsswryDm: "25107272103")
            }
            return cell
        }else{
            let cell = Bundle.main.loadNibNamed("auditCell", owner: self, options: nil)?.last as! auditCell
            cell.title.text = self.RuditNotifiSource[indexPath.section].tzggbt
            cell.content.text = self.RuditNotifiSource[indexPath.section].tzggnr
            cell.auditStatue.text = self.RuditNotifiSource[indexPath.section].tzggztmc
            let timeStr = self.RuditNotifiSource[indexPath.section].ssrq
            let timeStr1 = (timeStr as NSString).substring(to: 10)
            let timeStr2 = (timeStr as NSString).substring(from: 11)
            if timeStr1 != self.currentTime {
                cell.time.text = timeStr1
            }else{
                cell.time.text = timeStr2
            }
            cell.yiduStatue.isHidden = true
            if self.RuditNotifiSource[indexPath.section].tzggztDm == "04" {
                cell.okBtn.setTitle("审批", for: .normal)
            }else if self.RuditNotifiSource[indexPath.section].tzggztDm == "06" {
                cell.okBtn.setTitle("撤销", for: .normal)
            }else{
                cell.okBtn.isHidden = true
            }
            cell.ConfirmBlock = {[weak self] in  //审批按钮点击
                if self?.RuditNotifiSource[indexPath.section].tzggztDm == "04" {
                    let vc = ReviewController()
                    vc.UUID = (self?.RuditNotifiSource[indexPath.section].tzgguuid)!
                    self?.navigationController?.pushViewController(vc, animated: true)
                }else{//撤销
                    self?.CancelAudit(tzgguuid: (self?.RuditNotifiSource[indexPath.section].tzgguuid)!, tzggztDm: (self?.RuditNotifiSource[indexPath.section].tzggztDm)!)
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.status == 1 {
            let vc = NotificationDetailController()
            vc.UUID = self.ReceiveNotifiSource[indexPath.section].tzgguuid
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ReviewContentController()
            vc.UUID = self.RuditNotifiSource[indexPath.section].tzgguuid
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}