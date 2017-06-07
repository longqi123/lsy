//
//  MineOrganizationViewController5.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/26.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class MineOrganizationViewController5: UIViewController {
    
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var comeFrome = ""
    var serchTextFeild:UITextField!
    var dataSource: [TxlModel1] = []
    var model2:TxlModel2 = TxlModel2()
    var jgName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
        if dataSource.count == 0 {
            getData()
        }
    }
}

extension MineOrganizationViewController5:UITextFieldDelegate{
    func creatUI() {
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        let item2 = UIBarButtonItem(title: " 搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(rightBtnClicked))
        self.navigationItem.rightBarButtonItem = item2
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "OrganizationCell", bundle: nil), forCellReuseIdentifier: "OrganizationCellID")
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        backView.backgroundColor = UIColor.white
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sou_suo_xiao"))
        imageView.frame = CGRect(x: 5, y: 0, width: 15, height: 15)
        imageView.contentMode = .scaleAspectFill
        backView.addSubview(imageView)
        serchTextFeild = UITextField()
        serchTextFeild.backgroundColor = UIColor.white
        serchTextFeild.layer.masksToBounds = true
        serchTextFeild.layer.cornerRadius = 3
        serchTextFeild.frame = CGRect(x: 0, y: 0, width: WidthRatio*510, height: WidthRatio*60)
        serchTextFeild.leftView = backView
        serchTextFeild.placeholder = " 找人"
        serchTextFeild.leftViewMode = .unlessEditing
        serchTextFeild.font = UIFont.systemFont(ofSize: 14)
        serchTextFeild.delegate = self
        serchTextFeild.clearButtonMode = .whileEditing
        serchTextFeild.returnKeyType = .search
        self.navigationItem.titleView = serchTextFeild
        
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

extension MineOrganizationViewController5: UITableViewDelegate,UITableViewDataSource{
    
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCellID", for: indexPath) as! OrganizationCell
            cell.title.text = "四川省地方税务局 - \(jgName)"
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            cell.isUserInteractionEnabled = false
            return cell
            
        }else{
            let cell = Bundle.main.loadNibNamed("ContactCell", owner: self, options: nil)?.last as! ContactCell
            cell.notification.isHidden = true
            cell.nameLabel.text = self.dataSource[indexPath.row - 1].ryxm
            if self.dataSource[indexPath.row - 1].ryxm.characters.count > 2 {
                cell.photoLabel.text = (self.dataSource[indexPath.row - 1].ryxm as NSString).substring(with: NSMakeRange(self.dataSource[indexPath.row - 1].ryxm.characters.count - 2, 2))
            }else{
                cell.photoLabel.text = self.dataSource[indexPath.row - 1].ryxm
            }
            cell.photoLabel.backgroundColor = setNameBackColor(name: self.dataSource[indexPath.row - 1].ryxm, dm:self.dataSource[indexPath.row - 1].jsrydm)
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PersonalDetailController()
        vc.jsrydm = self.dataSource[indexPath.row - 1].jsrydm
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension MineOrganizationViewController5{
    func leftBtnClicked(){
        if self.comeFrome == "MineOrganizationViewController" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: MineOrganizationViewController.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "MineOrganizationViewController2" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: MineOrganizationViewController2.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "MineOrganizationViewController3" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: MineOrganizationViewController3.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else if self.comeFrome == "AddressListViewController" {
            for popVC in (self.navigationController?.viewControllers)! {
                if(popVC.isKind(of: AddressListViewController.self)){
                    let _ = self.navigationController?.popToViewController(popVC, animated: true)
                }
            }
        }else{
            self.navigationController?.popViewController(animated: false)
        }
    }
    func rightBtnClicked(){
        serchTextFeild.resignFirstResponder()
        guard serchTextFeild.text?.isEmpty == false else {
            ProgressHUD.toast(message: "请输入搜索内容")
            return
        }
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.TXLCX", "s":"<TxlcxRequestForm><swjgDm></swjgDm><yhmc>\(serchTextFeild.text!)</yhmc></TxlcxRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>500</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
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
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.rightBtnClicked()
        return true
    }
}
