//
//  ReviewController.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/2.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SwiftyJSON
import HandyJSON

class ReviewController: UIViewController {
    var titleStr = ""
    var contentStr = ""
    var reviewStr = ""
    var segementResults = ""
    var UUID = ""
    var currentTime = ""
    var tzggztDm = "06"
    var DetailSource: [TZGGDetailModel] = []
    var PersonSource: [TZGGDetailPersonModel] = []
    var switchON = false
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    let footBtn = UIButton()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "审批"
        Network.getSystemDate(success: {(time, timeString) in
            self.currentTime = timeString.dateFormate4.dateFormate1
        })
        self.getData()
    }
}

extension ReviewController{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        footBtn.setTitle("发布", for: .normal)
        footBtn.setTitleColor(UIColor.white, for: .normal)
        footBtn.titleLabel?.font = .H2
        footBtn.setTitleColor(.T6, for: .normal)
        footBtn.backgroundColor = .B1
        footBtn.addTarget(self, action: #selector(publicClick), for: .touchUpInside)
        view.addSubview(footBtn)
        footBtn.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(49)
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(footBtn.snp.top)
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

extension ReviewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else if section == 1{
            return 1
        }else{
            return 3
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
            if indexPath.row == 0 || indexPath.row == 1  {
                return 45
            }else {
                return 80
            }
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("NewNotificationCell1", owner: self, options: nil)?.last as! NewNotificationCell1
            cell.isUserInteractionEnabled = false
            cell.titleText.text = self.DetailSource[0].tzggbt
            cell.contentText.text = self.DetailSource[0].tzggnr
            cell.placehoderLab.isHidden = true
            cell.CintentBlock = {[weak self] content,title in
                self?.titleStr = title
                self?.contentStr = content
            }
            cell.selectionStyle = .none
            return cell
            
        }else if indexPath.section == 1{
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("NotificationDetailCell2", owner: self, options: nil)?.last as! NotificationDetailCell2
                cell.title.text = "通知人员"
                cell.content.text = "\(self.PersonSource.count)人"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.accessoryType = .disclosureIndicator
                cell.selectionStyle = .none
                return cell
            }            
        }else if indexPath.section == 2{
            if indexPath.row == 0 {
                let cell  = Bundle.main.loadNibNamed("ReviewResultsCell", owner: self, options: nil)?.last as! ReviewResultsCell
                cell.title.text = "审批结果"
                cell.segementBlock = {[weak self] result in
                    self?.segementResults = result
                    if self?.segementResults == "通过" {
                        self?.tzggztDm = "06"
                        self?.footBtn.setTitle("发布", for: .normal)
                    }else{
                        self?.tzggztDm = "03"
                        self?.footBtn.setTitle("退回", for: .normal)
                    }
                }
                cell.selectionStyle = .none
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                return cell
            }else if indexPath.row == 1{
                let cell = Bundle.main.loadNibNamed("OrganizationCell", owner: self, options: nil)?.last as! OrganizationCell
                cell.title.text = "审批意见"
                cell.isUserInteractionEnabled = false
                return cell
            }else if indexPath.row == 2{
                let celll = Bundle.main.loadNibNamed("AuditOpinionCell", owner: self, options: nil)?.last as! AuditOpinionCell
                celll.reviewBlock = {[weak self] content in
                    self?.reviewStr = content
                }
                celll.selectionStyle = .none
                return celll
            }
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
                let vc = HaveAcceptController2()
                vc.PersonSource = self.PersonSource
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
}
extension ReviewController{
    func leftBtnClicked(){//取消
        self.navigationController?.popViewController(animated: true)
    }
    func publicClick(){//发布
        ////tzggztDm  06通过  03不通过
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.TZGG.TZGGSPBC", "s":"<TzggspbcRequestForm><tzgguuid>\(self.UUID)</tzgguuid><tzggztDm>\(self.tzggztDm)</tzggztDm><sprDm>\(self.DetailSource[0].sprDm)</sprDm><spyj>\(self.reviewStr)</spyj><sprq>\(self.currentTime)</sprq><fbrDm>\(self.DetailSource[0].fbrDm)</fbrDm></TzggspbcRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            if json["result"]["returnBz"].stringValue == "1"{
                ProgressHUD.toast(message: "审批成功")
                self.navigationController?.popViewController(animated: true)
            }else{
                ProgressHUD.toast(message: "审批失败")
            }

        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}
