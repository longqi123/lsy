//
//  AddaddressViewController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

@objc class AddaddressViewController: UIViewController {
    
    fileprivate let OrganizationIdentifier = "OrganizationCell"
    public var AddFringBlock: ((_ model: [TxlModel1]) -> Void)?
    var isAll = false
    var dataSource: [TxlModel1] = []
    var AdddataSource: [TxlModel1] = []
    var tableView = BaseTableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        creatUI()
        getData()
    }
}

extension AddaddressViewController{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        let item2 = UIBarButtonItem(title: " 确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBtnClicked))
        self.navigationItem.rightBarButtonItem = item2
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(UINib(nibName: "OrganizationCell", bundle: nil), forCellReuseIdentifier: OrganizationIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
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

extension AddaddressViewController: UITableViewDelegate,UITableViewDataSource{
    
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
                let cell = Bundle.main.loadNibNamed("Personaldetailcell", owner: self, options: nil)?.last as! Personaldetailcell
                cell.nameLab.text = "四川省地方税务局"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.rightBtn.isHidden = true
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
                cell.photolab.text = self.dataSource[indexPath.row - 1].ryxm
                cell.numLab.text = self.dataSource[indexPath.row - 1].jsrydm
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
            let vc = DepartmentViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1{
            if indexPath.row == 0 {//选择整个部门
                let cell = tableView.cellForRow(at: indexPath) as! AddOrganizationCell
                if !cell.xunzhong.isSelected {
                    self.isAll = true
                    self.AdddataSource = self.dataSource
                }else{
                    self.isAll = false
                    self.AdddataSource.removeAll()
                }
                cell.xunzhong.isSelected = !cell.xunzhong.isSelected
                self.tableView.reloadData()
            }else{//选择某个
                let cell = tableView.cellForRow(at: indexPath) as! AdressContactCell
                let selectModel = self.dataSource[indexPath.row - 1]
                if !cell.xuanZhongImg.isSelected {
                    self.AdddataSource.append(selectModel)
                }else{
                    for (i,model) in self.AdddataSource.enumerated() {
                        if self.dataSource[indexPath.row - 1].jsrydm == model.jsrydm{
                            self.AdddataSource.remove(at: i)
                        }
                    }
                }
                cell.xuanZhongImg.isSelected = !cell.xuanZhongImg.isSelected
            }
        }
    }
}
extension AddaddressViewController{
    
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    func rightBtnClicked(){//把已经选择的联系人传回去
        self.AddFringBlock!(self.AdddataSource)
    }
}
