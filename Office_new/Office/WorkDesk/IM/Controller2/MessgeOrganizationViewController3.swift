//
//  MessgeOrganizationViewController3.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class MessgeOrganizationViewController3: UIViewController {

    let tableView = BaseTableView(frame: .zero, style: .plain)
    var serchTextFeild:UITextField!
    var jgname = ""
    var model2:TxlModel2 = TxlModel2()
    var dataSource1: [TxlModel1] = []
    var dataSource2: [TxlModel2] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "部门"
        creatUI()
        getData()
    }
}

extension MessgeOrganizationViewController3{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
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
            if json["result"]["Fenye"].count > 0{//跳转好友列表
                let data = json["result"]["TxlcxRyReturnVO"]["TxlcxRyResponseGridlb"]
                if data.count > 0{
                    if data.array != nil{
                        self.dataSource1 = data.arrayValue.map(TxlModel1.init)
                    }else{
                        self.dataSource1 = [JSONDeserializer<TxlModel1>.deserializeFrom(json:data.rawString())!]
                    }
                    let vc = MessgeOrganizationViewController5()
                    vc.dataSource = self.dataSource1
                    vc.jgName = self.jgname
                    vc.comeFrome = "MessgeOrganizationViewController2"
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

extension MessgeOrganizationViewController3: UITableViewDelegate,UITableViewDataSource{
    
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
            let cell = Bundle.main.loadNibNamed("OrganizationCell", owner: self, options: nil)?.last as! OrganizationCell
            cell.title.text = "四川省地方税务局 - \(self.jgname)"
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.isUserInteractionEnabled = false
            return cell
            
        }else{
            let cell = Bundle.main.loadNibNamed("BureauCell", owner: self, options: nil)?.first as! BureauCell
            cell.accessoryType = .disclosureIndicator
            cell.contentLab.text = self.dataSource2[indexPath.row - 1].fullname
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = MessgeOrganizationViewController4()
        vc.jgname = "\(self.jgname) - \(self.dataSource2[indexPath.row - 1].fullname)"
        vc.model2 = self.dataSource2[indexPath.row - 1]
        self.navigationController?.pushViewController(vc, animated: false)
  
    }
}
extension MessgeOrganizationViewController3{
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: false)
    }
}
