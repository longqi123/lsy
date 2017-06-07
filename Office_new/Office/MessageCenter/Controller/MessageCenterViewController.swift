//
//  MessageCenterViewController.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import CoreFramework
import SwiftyJSON

class MessageCenterViewController: BaseViewController {
    let tableView = BaseTableView()
    var JSModel:[MessageCenterData]?
    var OAModel:[MessageCenterData]?
    var YWModel:[MessageCenterData]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "任务通知"
        getData1()
    }
}

extension MessageCenterViewController{
    func getData1() {
        self.showloading()
        //金三
        let para1: [String: Any]
        para1 = paraMaker(data: ["tranId":"SCDS.HLWGZPT.WB.JSDBRWXXCX", "s":"<swryDm>25134330918</swryDm><Fenye><FenyeVO><dqys>1</dqys><myts>5</myts><zts></zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para1, success: { (json) in
            let data = json["result"]["JsDbrwxxReturnVO"]["JsDbrwxxResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.JSModel = data.arrayValue.map(MessageCenterData.init)
                }else{
                    self.JSModel = [JSONDeserializer<MessageCenterData>.deserializeFrom(json:data.rawString())!]
                }
            }
            self.getData2()
            
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
        
    }
        
        func getData2(){
            //OA
            let para2: [String: Any]
            para2 = paraMaker(data: ["tranId":"SCDS.HLWGZPT.WB.OADBRWXXCX", "s":"<swryDm>25100003012</swryDm><Fenye><FenyeVO><dqys>1</dqys><myts>5</myts><zts></zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
            Network.post(parameter: para2, success: { (json) in
                let data = json["result"]["OADbrwxxReturnVO"]["OADbrwxxResponseGridlb"]
                if data.count > 0{
                    if data.array != nil{
                        self.OAModel = data.arrayValue.map(MessageCenterData.init)
                    }else{
                        self.OAModel = [JSONDeserializer<MessageCenterData>.deserializeFrom(json:data.rawString())!]
                    }
                }
                self.getData3()
                
            }) { (error) in
                self.hideloading()
                ProgressHUD.toast(message: error)
            }

        }
        func getData3(){
            //运维
            let para3: [String: Any]
            para3 = paraMaker(data: ["tranId":"SCDS.HLWGZPT.WB.YWDBRWXXCX", "s":"<swryDm>tangj</swryDm><Fenye><FenyeVO><dqys>1</dqys><myts>5</myts><zts></zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
            Network.post(parameter: para3, success: { (json) in
                self.hideloading()
                let data = json["result"]["YwDbrwxxReturnVO"]["YwDbrwxxResponseGridlb"]
                if data.count > 0{
                    if data.array != nil{
                        self.YWModel = data.arrayValue.map(MessageCenterData.init)
                    }else{
                        self.YWModel = [JSONDeserializer<MessageCenterData>.deserializeFrom(json:data.rawString())!]
                    }
                }
                self.creatUI()
                self.tableView.reloadData()
                
            }) { (error) in
                self.hideloading()
                ProgressHUD.toast(message: error)
            }
 
    }
    
    func creatUI() {
        
        let item = UIBarButtonItem(image: UIImage(named: "mo_ren_tou_xiang"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension MessageCenterViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MessageCenterCell", owner: self, options: nil)?.last as! MessageCenterCell
        if indexPath.row == 0 {
            cell.title.text = "金三系统代办任务消息"
            cell.detail.text = self.JSModel?[0].rwzt1
            cell.time.text = self.JSModel?[0].rwfqsj.dateFormate1.dateFormate4
            cell.photo.text = "金三"
            if let model = self.JSModel{
                if model.count > 0 {
                    cell.weidu.text = "\(self.JSModel!.count)"
                    cell.weidu.layer.masksToBounds = true
                    cell.weidu.layer.cornerRadius = 15/2
                }else{
                    cell.weidu.isHidden = true
                }
            }
            cell.photo.backgroundColor = UIColor.C1
            
        }else if indexPath.row == 1{
            cell.title.text = "OA系统代办任务消息"
            cell.detail.text = self.OAModel?[0].rwzt1
            cell.time.text = self.OAModel?[0].rwfqsj.dateFormate1.dateFormate4
            cell.photo.text = "OA"
            if let model = self.OAModel {
                if model.count > 0 {
                    cell.weidu.text = "\(self.OAModel!.count)"
                    cell.weidu.layer.masksToBounds = true
                    cell.weidu.layer.cornerRadius = 15/2
                }else{
                    cell.weidu.isHidden = true
                }
            }
            cell.photo.backgroundColor = UIColor.C2
        
        }else if indexPath.row == 2{
            cell.title.text = "运维系统代办任务消息"
            cell.detail.text = self.YWModel?[0].rwzt1
            cell.time.text = self.YWModel?[0].rwfqsj.dateFormate1.dateFormate4
            cell.photo.text = "运维"
             if let model = self.YWModel {
                if model.count > 0 {
                    cell.weidu.text = "\(self.YWModel!.count)"
                    cell.weidu.layer.masksToBounds = true
                    cell.weidu.layer.cornerRadius = 15/2
                }else{
                    cell.weidu.isHidden = true
                }
            }
            cell.photo.backgroundColor = UIColor.C5
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MessegeContentController()
        if indexPath.row == 0 {
            vc.title = "金三"
            vc.DetailModel = self.JSModel!
        }else if indexPath.row == 1{
            vc.DetailModel = self.OAModel!
            vc.title = "OA"
        }else if indexPath.row == 2{
            vc.DetailModel = self.YWModel!
            vc.title = "运维"
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MessageCenterViewController{
    func btnClicked(){
        let mineVC = MineViewController()
        mineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mineVC, animated: true)
    }
}