//
//  AnnouncementController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class AnnouncementController: UIViewController {
    
    let tableView = BaseTableView(frame: .zero, style: .plain)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "通知公告"
        creatUI()
    }
}

extension AnnouncementController{
    func creatUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.tableFooterView = UIView()
   
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension AnnouncementController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AnnouncementControllerCell", owner: self, options: nil)?.last as! AnnouncementControllerCell
        if indexPath.row == 0 {
            cell.photoImg.image = #imageLiteral(resourceName: "shou_dao_tong_zhi")
            cell.content.text = "收到通知"
        }else if indexPath.row == 1{
            cell.photoImg.image = #imageLiteral(resourceName: "fa_song_tong_zhi")
            cell.content.text = "发送通知"
        }
        cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {//收到通知
            let vc = NewReceiveNotifiViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{//发送通知
            let vc = SendNotificationController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
