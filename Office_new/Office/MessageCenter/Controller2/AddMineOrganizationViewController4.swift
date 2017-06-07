//
//  AddMineOrganizationViewController4.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON
class AddMineOrganizationViewController4: UIViewController {
    var isAll = false
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var serchTextFeild:UITextField!
    var jgname = ""
    var model2:TxlModel2 = TxlModel2()
    var dataSource1: [TxlModel1] = []
    var dataSource2: [TxlModel2] = []
    var AdddataSource: [TxlModel2] = []
    var footView:totalNumFootView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "部门"
        creatUI()
        getData()
    }
}

extension AddMineOrganizationViewController4{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        footView = Bundle.main.loadNibNamed("totalNumFootView", owner: self, options: nil)?.last as! totalNumFootView
        footView.btn.setTitle("确定", for: .normal)
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
            if json["result"]["Fenye"].count > 0{//跳转好友列表
                let data = json["result"]["TxlcxRyReturnVO"]["TxlcxRyResponseGridlb"]
                if data.count > 0{
                    if data.array != nil{
                        self.dataSource1 = data.arrayValue.map(TxlModel1.init)
                    }else{
                        self.dataSource1 = [JSONDeserializer<TxlModel1>.deserializeFrom(json:data.rawString())!]
                    }
                    let vc = AddMineOrganizationViewController5()
                    vc.dataSource = self.dataSource1
                    vc.jgName = self.jgname
                    vc.comeFrome = "AddMineOrganizationViewController3"
                    self.navigationController?.pushViewController(vc, animated: false)
                }
            }else{//机构列表
                let data = json["result"]["TxlcxJgReturnVO"]["TxlcxJgResponseGridlb"]
                if data.count > 0{
                    if data.array != nil{
                        self.dataSource2 = data.arrayValue.map(TxlModel2.init)
                    }else{
                        self.dataSource2 = [JSONDeserializer<TxlModel2>.deserializeFrom(json:data.rawString())!]
                    }
                    self.tableView.reloadData()
                }
            }
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    
}

extension AddMineOrganizationViewController4: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource2.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 70
        }
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = Bundle.main.loadNibNamed("AddOrganizationCell", owner: self, options: nil)?.last as! AddOrganizationCell
            cell.nameLab.text = "四川省地方税务局 - \(self.jgname)"
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
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
            cell.nameLab.text = self.dataSource2[indexPath.row - 1].fullname
            cell.ChioceBlock = {[weak self] isclick in
                if isclick {
                    self?.AdddataSource.append((self?.dataSource2[indexPath.row - 1])!)
                }else {
                    for (i,model) in (self?.AdddataSource.enumerated())! {
                        if self?.dataSource2[indexPath.row - 1].storeid == model.storeid{
                            self?.AdddataSource.remove(at: i)
                        }
                    }
                }
            }
            for model in self.AdddataSource {
                if self.dataSource2[indexPath.row - 1].storeid == model.storeid{
                    cell.xunzhong.isSelected = true
                }
            }
            cell.selectionStyle = .none
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            let cell = tableView.cellForRow(at: indexPath) as! AddOrganizationCell
            if !cell.xunzhong.isSelected {
                self.isAll = true
                self.AdddataSource = self.dataSource2
            }else{
                self.isAll = false
                self.AdddataSource.removeAll()
            }
            cell.xunzhong.isSelected = !cell.xunzhong.isSelected
            self.tableView.reloadData()
        }else{
            let vc = AddMineOrganizationViewController5()
            vc.jgName = "\(self.jgname) - \(self.dataSource2[indexPath.row - 1].fullname)"
            vc.model2 = self.dataSource2[indexPath.row - 1]
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
}
extension AddMineOrganizationViewController4{
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: false)
    }
    func rightBtnClicked(){
        print(self.AdddataSource.count)
        print(self.AdddataSource)

    }
}