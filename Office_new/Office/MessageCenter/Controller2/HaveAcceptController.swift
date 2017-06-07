//
//  HaveAcceptController.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/1.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class HaveAcceptController: UIViewController {
    
    fileprivate let OrganizationIdentifier = "OrganizationCell"
    fileprivate let ContactIdentifier = "ContactCell"
    var haveSeleFringBlock: ((_ model: [TxlModel1]) -> Void)?
    var dataSource: [TxlModel1] = []
    var searchDataSource: [TxlModel1] = []
    var AdddataSource: [TxlModel1] = []
    var isAll = true
    var tableView = BaseTableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.AdddataSource = self.dataSource
        self.title = "选择接收人"
        creatUI()
    }
}

extension HaveAcceptController{
    func creatUI() {
        let item2 = UIBarButtonItem(title: " 确定", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBtnClicked))
        self.navigationItem.rightBarButtonItem = item2
        
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.register(UINib(nibName: "OrganizationCell", bundle: nil), forCellReuseIdentifier: OrganizationIdentifier)
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: ContactIdentifier)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension HaveAcceptController: UITableViewDelegate,UITableViewDataSource{
    
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
                return 55
            }else{
                return 45
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                return 45
            }else{
                return 60
            }
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("SearchCell", owner: self, options: nil)?.last as! SearchCell
                cell.longBlock = {[weak self] searchStr in
                    self?.search(searchID: searchStr)
                }
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationIdentifier, for: indexPath) as! OrganizationCell
                cell.title.text = "选择新的接收人"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("AddOrganizationCell", owner: self, options: nil)?.last as! AddOrganizationCell
                cell.nameLab.text = "已选择的接收人"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.xunzhong.isUserInteractionEnabled = false
                if isAll {
                    cell.xunzhong.isSelected = true
                }else{
                    cell.xunzhong.isSelected = false
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
                    cell.xuanZhongImg.isUserInteractionEnabled = false
                    for (model) in self.AdddataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 && indexPath.row == 1 {//选择新的联系人
            let vc = AddaddressViewController()
            vc.title = "选择接收人"
            vc.AddFringBlock = {[weak self] selectArr in
                self?.dataSource = selectArr
                self?.AdddataSource = selectArr
                self?.tableView.reloadData()
            }
            vc.AdddataSource = self.AdddataSource
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1{
            if indexPath.row == 0 {//选择整个部门
                let cell = tableView.cellForRow(at: indexPath) as! AddOrganizationCell
                if cell.xunzhong.isSelected {
                    self.isAll = false
                    self.AdddataSource.removeAll()
                }else{
                    self.isAll = true
                    self.AdddataSource = self.dataSource
                }
                cell.xunzhong.isSelected = !cell.xunzhong.isSelected
                self.tableView.reloadData()
            }else{//选择某个
                let cell = tableView.cellForRow(at: indexPath) as! AdressContactCell
                let selectModel = self.dataSource[indexPath.row - 1]
                if cell.xuanZhongImg.isSelected {
                    for (i,model) in self.AdddataSource.enumerated() {
                        if self.dataSource[indexPath.row - 1].jsrydm == model.jsrydm{
                            self.AdddataSource.remove(at: i)
                        }
                    }
                }else{
                    self.AdddataSource.append(selectModel)
                }
                cell.xuanZhongImg.isSelected = !cell.xuanZhongImg.isSelected
            }
        }
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
}
extension HaveAcceptController{
    
    func rightBtnClicked(){
        self.navigationController?.popViewController(animated: true)
        self.haveSeleFringBlock!(self.AdddataSource)
    }
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
    func search(searchID:String){ //搜索
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.TXLCX", "s":"<TxlcxRequestForm><swjgDm></swjgDm><yhmc>\(searchID)</yhmc></TxlcxRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>500</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let data = json["result"]["TxlcxRyReturnVO"]["TxlcxRyResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.searchDataSource = data.arrayValue.map(TxlModel1.init)
                }else{
                    self.searchDataSource = [JSONDeserializer<TxlModel1>.deserializeFrom(json:data.rawString())!]
                }
                let vc = MineOrganizationViewController5()
                vc.dataSource = self.searchDataSource
                vc.jgName = "搜索好友"
                vc.comeFrome = "AddressListViewController"
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}
