//
//  HaveAcceptController2.swift
//  Office
//
//  Created by 梁仕友 on 2017/6/7.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class HaveAcceptController2: UIViewController {
    var tableView = BaseTableView(frame: .zero, style: .grouped)
    var PersonSource: [TZGGDetailPersonModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "接收人"
        creatUI()
    }
}

extension HaveAcceptController2{
    func creatUI() {
        
        let item = UIBarButtonItem(image: UIImage(named: "icon_back_left"), style: .plain, target: self, action: #selector(leftBtnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension HaveAcceptController2: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PersonSource.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 45
        }else{
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            if indexPath.row == 0 {
                let cell = Bundle.main.loadNibNamed("AddOrganizationCell", owner: self, options: nil)?.last as! AddOrganizationCell
                cell.nameLab.text = "已选择的接收人"
                cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
                cell.xunzhong.isUserInteractionEnabled = false
                cell.xunzhong.isSelected = true
                return cell
                
            }else{
                let cell = Bundle.main.loadNibNamed("AdressContactCell", owner: self, options: nil)?.last as! AdressContactCell
                
                cell.nameLab.text = self.PersonSource[indexPath.row - 1].jsswrymc
                    if self.PersonSource[indexPath.row - 1].jsswrymc.characters.count > 2 {
                        cell.photolab.text = (self.PersonSource[indexPath.row - 1].jsswrymc as NSString).substring(with: NSMakeRange(self.PersonSource[indexPath.row - 1].jsswrymc.characters.count - 2, 2))
                    }else{
                        cell.photolab.text = self.PersonSource[indexPath.row - 1].jsswrymc
                    }
                    cell.photolab.backgroundColor = setNameBackColor(name: self.PersonSource[indexPath.row - 1].jsswryDm, dm:self.PersonSource[indexPath.row - 1].jsswryDm)
                    cell.xuanZhongImg.isSelected = true
                    cell.isUserInteractionEnabled = false
                
                cell.selectionStyle = .none
                return cell
            }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
extension HaveAcceptController2{
    func leftBtnClicked(){
        self.navigationController?.popViewController(animated: true)
    }
}
