//
//  MessgeAddressListViewController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

@objc protocol MessgeAddressListDelegate {
    func addFriend(dataSource: [String])
}

@objc class MessgeAddressListViewController: UIViewController {

    fileprivate let OrganizationIdentifier = "OrganizationCell"
    var delegate: MessgeAddressListDelegate?
    var AddFringBlock: ((_ model: [TxlModel1]) -> Void)? = nil
    var AddFringBlock_oc: ((_ model: [TxlModel1_oc]) -> Void)?
    var isAll = false
    public var isSingleSelect = true
    var dataSource: [TxlModel1] = []
    var AdddataSource: [TxlModel1] = []
    var defaultDisplaySource: [TxlModel1] = []
    var footView:totalNumFootView!
    var PersonMaxiNum:Int = 24
    var tableView = BaseTableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        DataCenter.ChatVideoAdddataSource = self.defaultDisplaySource
        DataCenter.PersonMaxiNum = PersonMaxiNum
        creatUI()
        getData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        footView.title.text = "已选择：\(DataCenter.ChatVideoAdddataSource.count)人"
        footView.btn.setTitle("确定(\(DataCenter.ChatVideoAdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
    }
    
    public func changeClass(array: [TxlModel1_oc]) {
        //oc类调用
        var dataSource = [TxlModel1]()
        for model in array {
            var data = TxlModel1()
            data.swjgdm = model.swjgdm;
            data.jsrydm = model.jsrydm;
            data.swjgmc = model.swjgmc;
            data.levelname = model.levelname;
            data.ryxm = model.ryxm;
            data.csmc = model.csmc;
            data.dutyname = model.dutyname;
            data.rydm = model.rydm;
            data.csdm = model.csdm;
            dataSource.append(data)
        }
        self.AdddataSource = dataSource;
    }
}

extension MessgeAddressListViewController{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        footView = Bundle.main.loadNibNamed("totalNumFootView", owner: self, options: nil)?.last as! totalNumFootView
        footView.title.text = "已选择：0人"
        footView.btn.setTitle("确定(0/26)", for: .normal)
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
        tableView.register(UINib(nibName: "OrganizationCell", bundle: nil), forCellReuseIdentifier: OrganizationIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(footView.snp.top)
        }
    }
    func getData(){
        self.showloading()
        guard let csdm = DataCenter.ryxqModel?.csdm else {
            ProgressHUD.toast(message: "未登录")
            self.hideloading()
            return
        }
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.TXLCX", "s":"<TxlcxRequestForm><swjgDm>\(csdm)</swjgDm><yhmc></yhmc></TxlcxRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>500</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
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

extension MessgeAddressListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }else {
            return self.dataSource.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 75
            }else{
                return 50
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 50
            }else{
                return 60
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("Personaldetailcell3", owner: self, options: nil)?.last as! Personaldetailcell3
                cell.name.text = "四川省地方税务局"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
               
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationIdentifier, for: indexPath) as! OrganizationCell
                cell.title.text = "组织架构"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("AddOrganizationCell", owner: self, options: nil)?.last as! AddOrganizationCell
                cell.nameLab.text = "我的部门：\(DataCenter.ryxqModel?.csmc ?? "")"
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
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 1 {//组织机构
            let vc = MessgeOrganizationViewController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else if indexPath.section == 1{
            if indexPath.row == 0 {//选择整个部门
                if isSingleSelect == true {
                    return
                }
                
                let cell = tableView.cellForRow(at: indexPath) as! AddOrganizationCell
                if !cell.xunzhong.isSelected {
                    self.isAll = true
                    for model in self.dataSource {
                        self.AdddataSource.append(model)
                    }
                    guard self.AdddataSource.count <= DataCenter.PersonMaxiNum! else {
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
                cell.xunzhong.isSelected = !cell.xunzhong.isSelected
                DataCenter.ChatVideoAdddataSource = self.AdddataSource
                footView.title.text = "已选择：\(self.AdddataSource.count)人"
                footView.btn.setTitle("确定(\(self.AdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
                self.tableView.reloadData()
            }else{//选择某个
                
                let selectModel = self.dataSource[indexPath.row - 1]
                let cell = tableView.cellForRow(at: indexPath) as! AdressContactCell
                if !cell.xuanZhongImg.isSelected {
                    self.AdddataSource.append(selectModel)
                    guard self.AdddataSource.count <= DataCenter.PersonMaxiNum! else {
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
           
                DataCenter.ChatVideoAdddataSource = self.AdddataSource
                footView.title.text = "已选择：\(self.AdddataSource.count)人"
                footView.btn.setTitle("确定(\(self.AdddataSource.count)/\(DataCenter.PersonMaxiNum!))", for: .normal)
                cell.xuanZhongImg.isSelected = !cell.xuanZhongImg.isSelected
            }
        }
    }
}

extension MessgeAddressListViewController{
    
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func rightBtnClicked(){//把已经选择的联系人传回去
        let array = self.AdddataSource.map { $0.jsrydm}
        self.delegate?.addFriend(dataSource: array)
        self.navigationController?.popViewController(animated: true)
        
        for model in self.AdddataSource {
            DataCenter.ChatVideoAdddataSource.append(model)
        }
        
        if self.AddFringBlock != nil {
            self.AddFringBlock!(DataCenter.ChatVideoAdddataSource)
        }
        
        if self.AddFringBlock_oc != nil {
            
            //oc类调用
            var array = [TxlModel1_oc]()
            for model in DataCenter.ChatVideoAdddataSource {
                let data = TxlModel1_oc()
                data.swjgdm = model.swjgdm;
                data.jsrydm = model.jsrydm;
                data.swjgmc = model.swjgmc;
                data.levelname = model.levelname;
                data.ryxm = model.ryxm;
                data.csmc = model.csmc;
                data.dutyname = model.dutyname;
                data.rydm = model.rydm;
                data.csdm = model.csdm;
                array.append(data)
            }
            self.AddFringBlock_oc!(array)
            
        }
    }
}
