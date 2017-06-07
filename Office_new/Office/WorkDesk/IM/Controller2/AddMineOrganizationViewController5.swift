//
//  AddMineOrganizationViewController5.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class AddMineOrganizationViewController5: UIViewController {
    var isAll = false
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var comeFrome = ""
    var serchTextFeild:UITextField!
    var dataSource: [TxlModel1] = []
    var model2:TxlModel2 = TxlModel2()
    var jgName = ""
    var AdddataSource: [TxlModel1] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "部门人员"
        creatUI()
        if dataSource.count == 0 {
            getData()
        }
    }
}

extension AddMineOrganizationViewController5{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        let item2 = UIBarButtonItem(title: " 确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBtnClicked))
        self.navigationItem.rightBarButtonItem = item2
        
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

extension AddMineOrganizationViewController5: UITableViewDelegate,UITableViewDataSource{
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
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
        }else{
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
extension AddMineOrganizationViewController5{
    func leftBtnClicked(){
        if self.comeFrome == "DepartmentViewController" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: DepartmentViewController.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "AddMineOrganizationViewController2" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: AddMineOrganizationViewController2.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "AddMineOrganizationViewController3" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: AddMineOrganizationViewController3.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: false)
        }
    }
    func rightBtnClicked(){
        print(self.AdddataSource.count)
        print(self.AdddataSource)
    }
}
