//
//  DepartmentViewController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class DepartmentViewController: BaseViewController {
    var isAll = false
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var serchTextFeild:UITextField!
    var dataSource: [TxlModel2] = []
    var AdddataSource: [TxlModel1] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "部门"
        creatUI()
        getData()
    }
}

extension DepartmentViewController{
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
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.TXLCX", "s":"<TxlcxRequestForm><swjgDm>127052995</swjgDm><yhmc></yhmc></TxlcxRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>500</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let data = json["result"]["TxlcxJgReturnVO"]["TxlcxJgResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.dataSource = data.arrayValue.map(TxlModel2.init)
                }else{
                    self.dataSource = [JSONDeserializer<TxlModel2>.deserializeFrom(json:data.rawString())!]
                }
                self.tableView.reloadData()
            }
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}

extension DepartmentViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 50
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("AddOrganizationCell", owner: self, options: nil)?.last as! AddOrganizationCell
            cell.nameLab.text = "四川省地方税务局"
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.isUserInteractionEnabled = false
            cell.xunzhong.isSelected = false
            cell.xunzhong.isUserInteractionEnabled = false
            if isAll {
                cell.xunzhong.isSelected = true
            }
            return cell
            
        }else{
            let cell = Bundle.main.loadNibNamed("AddBureauCell", owner: self, options: nil)?.first as! AddBureauCell
            cell.accessoryType = .disclosureIndicator
            cell.separatorInset = UIEdgeInsetsMake(0, 35, 0, 0)
            cell.nameLab.text = self.dataSource[indexPath.row - 1].fullname
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! AddOrganizationCell
            if !cell.xunzhong.isSelected {
                self.isAll = true
//                self.AdddataSource = self.dataSource
            }else{
                self.isAll = false
                self.AdddataSource.removeAll()
            }
            cell.xunzhong.isSelected = !cell.xunzhong.isSelected
            self.tableView.reloadData()
        }
        
    }
}
extension DepartmentViewController{
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    func rightBtnClicked(){
       
    }
}
