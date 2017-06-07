//
//  ReceivenotificationController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class ReceivenotificationController: UIViewController {
    
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    let headerId = "SendNotificationHeaderID"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "收到通知"
        creatUI()
        getData()
    }
}

extension ReceivenotificationController{
    func creatUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.register(ReceiveNotificationHeader.self, forHeaderFooterViewReuseIdentifier: headerId)
    }
    func getData(){
        
    }
}

extension ReceivenotificationController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("SendNotificationControllerCell", owner: self, options: nil)?.last as! SendNotificationControllerCell
        cell.title.text = "关于是考虑客户方可领取的通知"
        cell.content.text = "kljfhFIUJIHW富恶化女那大家hi符合南都网一五黑我"
        cell.examinationStatus.isHidden = true
        cell.okBtn.isHidden = true
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! ReceiveNotificationHeader
        header.headerLab.text = "2017-03-22"
        return header
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = NotificationDetailController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}