//
//  EditinformationController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/19.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class  EditinformationController: UIViewController {
    let tableView = BaseTableView(frame: .zero, style: .plain)
    var footView:PersonaldetailView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人详情"
        self.CreatUI()
    }
}
extension  EditinformationController {
    func CreatUI(){
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(view).offset(50)
        }
    }
}

extension EditinformationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
   
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{

        let cell = Bundle.main.loadNibNamed("EditpersonalinformationCell", owner: self, options: nil)?.first as? EditpersonalinformationCell
        if indexPath.row == 0 {
            cell?.title.text = "姓名"
            cell?.content.text = DataCenter.ryxqModel?.ryxm
            cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }else if indexPath.row == 1 {
            cell?.title.text = "电话"
            cell?.content.text = DataCenter.ryxqModel?.sj
               
        }else if indexPath.row == 2 {
            cell?.title.text = "座机"
            cell?.content.text = DataCenter.ryxqModel?.jtdh
                
        }else if indexPath.row == 3 {
            cell?.title.text = "邮箱"
            cell?.content.text = DataCenter.ryxqModel?.dzyj
                
        }else if indexPath.row == 4 {
            cell?.title.text = "部门"
            cell?.content.text = DataCenter.ryxqModel?.swjgmc
            cell?.content.isUserInteractionEnabled = false
            cell?.accessoryType = .disclosureIndicator
                
        }else if indexPath.row == 5 {
            cell?.title.text = "职务"
            cell?.content.text = DataCenter.ryxqModel?.dutyname
                
        }else if indexPath.row == 6 {
            cell?.title.text = "QQ"
            cell?.content.text = DataCenter.ryxqModel?.qqzh
                
        }else if indexPath.row == 7 {
            cell?.title.text = "微信"
            cell?.content.text = DataCenter.ryxqModel?.wxzh

        }
        cell?.selectionStyle = .none
        return cell!
    }
}

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }


