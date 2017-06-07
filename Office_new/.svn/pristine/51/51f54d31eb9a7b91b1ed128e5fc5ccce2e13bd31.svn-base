//
//  MessegeContentController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/27.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON
import SwiftyJSON

class MessegeContentController: UIViewController {
    var DetailModel:[MessageCenterData] = []
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
    }
}

extension MessegeContentController{
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

extension MessegeContentController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.DetailModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("MessegeContentcell", owner: self, options: nil)?.last as! MessegeContentcell
        cell.title.text = self.DetailModel[indexPath.section].rwzt1
        cell.originator.text = "发送人：\(self.DetailModel[indexPath.section].rwfqr)"
        cell.time.text = self.DetailModel[indexPath.section].rwfqsj
        return cell
    
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
