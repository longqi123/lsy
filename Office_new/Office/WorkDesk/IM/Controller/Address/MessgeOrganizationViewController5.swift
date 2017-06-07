//
//  MessgeOrganizationViewController5.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class MessgeOrganizationViewController5: UIViewController {
    var isAll = false
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var comeFrome = ""
    var serchTextFeild:UITextField!
    var dataSource: [TxlModel1] = []
    var model2:TxlModel2 = TxlModel2()
    var jgName = ""
    var AdddataSource: [TxlModel1] = []
    var footView:totalNumFootView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "部门人员"
        creatUI()
        self.AdddataSource = DataCenter.ChatVideoAdddataSource
        if dataSource.count == 0 {
            getData()
        }
    }
}

extension MessgeOrganizationViewController5{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        footView = Bundle.main.loadNibNamed("totalNumFootView", owner: self, options: nil)?.last as! totalNumFootView
        footView.title.text = "已选择：\(DataCenter.ChatVideoAdddataSource.count)人"
        footView.btn.setTitle("确定(\(DataCenter.ChatVideoAdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
        footView.okBtnclick = {[weak self] in
            self?.rightBtnClicked()
        }
        view.addSubview(footView)
        footView.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(footView.snp.top)
        }
        
    }
    func getData(){
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.TXLCX", "s":"<TxlcxRequestForm><swjgDm>\(model2.storeid)</swjgDm><yhmc></yhmc></TxlcxRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>500</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let data = json["result"]["TxlcxRyReturnVO"]["TxlcxRyResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.dataSource = data.arrayValue.map(TxlModel1.init)
                }else{
                    self.dataSource = [JSONDeserializer<TxlModel1>.deserializeFrom(json:data.rawString())!]
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}

extension MessgeOrganizationViewController5: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("AddOrganizationCell", owner: self, options: nil)?.last as! AddOrganizationCell
            cell.nameLab.text = "四川省地方税务局 - \(self.jgName)"
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.xunzhong.isSelected = false
            cell.xunzhong.isUserInteractionEnabled = false
            if isAll {
                cell.xunzhong.isSelected = true
            }
            return cell
            
        }else{
            let cell = Bundle.main.loadNibNamed("AdressContactCell", owner: self, options: nil)?.last as! AdressContactCell
            cell.nameLab.text = self.dataSource[indexPath.row - 1].ryxm
            if self.dataSource[indexPath.row - 1].ryxm.characters.count > 2 {
                cell.photolab.text = (self.dataSource[indexPath.row - 1].ryxm as NSString).substring(with: NSMakeRange(self.dataSource[indexPath.row - 1].ryxm.characters.count - 2, 2))
            }else{
                cell.photolab.text = self.dataSource[indexPath.row - 1].ryxm
            }
            cell.photolab.backgroundColor = setNameBackColor(name: self.dataSource[indexPath.row - 1].ryxm, dm:self.dataSource[indexPath.row - 1].jsrydm)
            
            cell.xuanZhongImg.isSelected = false
            cell.xuanZhongImg.isUserInteractionEnabled = false
            for model in self.AdddataSource {
                if self.dataSource[indexPath.row - 1].jsrydm == model.jsrydm{
                    cell.xuanZhongImg.isSelected = true

                }
            }
            cell.selectionStyle = .none

            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! AddOrganizationCell
            if !cell.xunzhong.isSelected {
                self.isAll = true
                self.AdddataSource = self.AdddataSource + self.dataSource
                guard self.AdddataSource.count < DataCenter.PersonMaxiNum! else {
                    ProgressHUD.toast(message: "选择人员不超过\(DataCenter.PersonMaxiNum!)人")
                    self.AdddataSource = (self.AdddataSource as NSArray).subarray(with: NSMakeRange(0, DataCenter.PersonMaxiNum!)) as! [TxlModel1]
                    footView.title.text = "已选择：\(self.AdddataSource.count)人"
                    footView.btn.setTitle("确定(\(self.AdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
                    self.tableView.reloadData()
                    return
                }
            }else{
                self.isAll = false
                if self.dataSource.count > 0 {
                    for model in self.dataSource{
                        for (i,model2) in self.AdddataSource.enumerated(){
                            if model2.jsrydm == model.jsrydm {
                                self.AdddataSource.remove(at: i)
                            }
                        }
                    }
                }
            }
            
            footView.title.text = "已选择：\(self.AdddataSource.count)人"
            footView.btn.setTitle("确定(\(self.AdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
            cell.xunzhong.isSelected = !cell.xunzhong.isSelected
            self.tableView.reloadData()
        }else{
            let cell = tableView.cellForRow(at: indexPath) as! AdressContactCell
            let selectModel = self.dataSource[indexPath.row - 1]
            if !cell.xuanZhongImg.isSelected {
                self.AdddataSource.append(selectModel)
                guard self.AdddataSource.count < DataCenter.PersonMaxiNum! else {
                    ProgressHUD.toast(message: "选择人员不超过\(DataCenter.PersonMaxiNum!)人")
                    self.AdddataSource = (self.AdddataSource as NSArray).subarray(with: NSMakeRange(0, DataCenter.PersonMaxiNum!)) as! [TxlModel1]
                    footView.title.text = "已选择：\(self.AdddataSource.count)人"
                    footView.btn.setTitle("确定(\(self.AdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
                    self.tableView.reloadData()
                    return
                }
            }else{
                for (i,model) in self.AdddataSource.enumerated() {
                    if self.dataSource[indexPath.row - 1].jsrydm == model.jsrydm{
                        self.AdddataSource.remove(at: i)
                    }
                }
            }
            
            footView.title.text = "已选择：\(self.AdddataSource.count)人"
            footView.btn.setTitle("确定(\(self.AdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
            cell.xuanZhongImg.isSelected = !cell.xuanZhongImg.isSelected
            self.tableView.reloadData()
        }
    }
}
extension MessgeOrganizationViewController5{
    func leftBtnClicked(){
        DataCenter.ChatVideoAdddataSource = self.AdddataSource
        if self.comeFrome == "MessgeOrganizationViewController" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: MessgeOrganizationViewController.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "MessgeOrganizationViewController2" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: MessgeOrganizationViewController2.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "MessgeOrganizationViewController3" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: MessgeOrganizationViewController3.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: false)
        }
    }
    func rightBtnClicked(){
        DataCenter.ChatVideoAdddataSource = self.AdddataSource
        for popVC in (self.navigationController?.viewControllers)! {
            if(popVC.isKind(of: MessgeAddressListViewController.self)){
                let _ = self.navigationController?.popToViewController(popVC, animated: true)
            }
        }
    }
}