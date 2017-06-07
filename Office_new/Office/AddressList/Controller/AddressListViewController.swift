//
//  AddressListViewController.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class AddressListViewController: UIViewController {

    fileprivate let OrganizationIdentifier = "OrganizationCell"
    fileprivate let ContactIdentifier = "ContactCell"
    var dataSource: [TxlModel1] = []
    var dataSource2: [TxlModel1] = []
    var tableView = BaseTableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通讯录"
        creatUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
}

extension AddressListViewController{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "mo_ren_tou_xiang"), style: .plain, target: self, action: #selector(btnClicked))
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

extension AddressListViewController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }else {
            return self.dataSource.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                return 55
            }else if indexPath.row == 1 {
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
                let cell = Bundle.main.loadNibNamed("SearchCell", owner: self, options: nil)?.last as! SearchCell
                cell.longBlock = {[weak self] searchStr in
                    self?.search(searchID: searchStr)
                }
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.selectionStyle = .none
                return cell
            }else if indexPath.row == 1 {
                let cell = Bundle.main.loadNibNamed("Personaldetailcell3", owner: self, options: nil)?.last as! Personaldetailcell3
                cell.name.text = "四川省地方税务局"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                return cell
            }else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationIdentifier, for: indexPath) as! OrganizationCell
                cell.title.text = "组织架构"
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: OrganizationIdentifier, for: indexPath) as! OrganizationCell
                cell.title.text = "我的部门：\(DataCenter.ryxqModel?.csmc ?? "")"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.isUserInteractionEnabled = false
                return cell

            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: ContactIdentifier, for: indexPath) as! ContactCell
                cell.nameLabel.text = self.dataSource[indexPath.row - 1].ryxm
                cell.notification.isHidden = true
                if self.dataSource[indexPath.row - 1].ryxm.characters.count > 2 {
                    cell.photoLabel.text = (self.dataSource[indexPath.row - 1].ryxm as NSString).substring(with: NSMakeRange(self.dataSource[indexPath.row - 1].ryxm.characters.count - 2, 2))
                }else{
                    cell.photoLabel.text = self.dataSource[indexPath.row - 1].ryxm
                }
                cell.photoLabel.backgroundColor = setNameBackColor(name: self.dataSource[indexPath.row - 1].ryxm, dm:self.dataSource[indexPath.row - 1].jsrydm)
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
        if indexPath.section == 0 && indexPath.row == 1 {
            let vc = AnnouncementController()
//            vc.isSingleSelect = false
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if indexPath.section == 0 && indexPath.row == 2{
            guard System.isLogin else {
                ProgressHUD.toast(message: "未登录")
                self.hideloading()
                return
            }
            let vc = MineOrganizationViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.section == 1{
            let vc = PersonalDetailController()
            vc.hidesBottomBarWhenPushed = true
            vc.jsrydm = self.dataSource[indexPath.row - 1].jsrydm
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
extension AddressListViewController{
    
    func btnClicked(){
        let mineVC = MineViewController()
        mineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mineVC, animated: true)
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
                    self.dataSource2 = data.arrayValue.map(TxlModel1.init)
                }else{
                    self.dataSource2 = [JSONDeserializer<TxlModel1>.deserializeFrom(json:data.rawString())!]
                }
                let vc = MineOrganizationViewController5()
                vc.dataSource = self.dataSource2
                vc.jgName = "搜索好友"
                vc.comeFrome = "AddressListViewController"
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: false)
            }
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}