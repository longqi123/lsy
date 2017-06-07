//
//  MyAcountDetailsViewController.swift
//  Office
//
//  Created by GA GA on 18/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework

class MyAcountDetailsViewController: UIViewController {

    let cellId = "cellId"
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:  #selector(setMyAccount))
        navigationItem.rightBarButtonItem = rightButton

        title = "映射账号信息"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        tableView.register(MyAccountDetailsCell.self, forCellReuseIdentifier: cellId)
    }

}


extension MyAcountDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyAccountDetailsCell
        
        
        cell.selectionStyle = .none
        return cell
    }

}

extension MyAcountDetailsViewController {
    func setMyAccount() {
        guard let rydm = DataCenter.ryxqModel?.rydm  else {
            return
        }
//        let zslddm = dataSource.rydm
//        let zsldmc = dataSource.ryxm
        let para: [String: Any]
        var s = ""
        
        s += "<RykzxxbjRequestForm>"
        s += "<rydm>\(rydm)</rydm>"
        s += "<qqzh></qqzh>"
        s += "<wxzh></wxzh>"
        s += "<zsldDm></zsldDm>"
        s += "<zsldmc></zsldmc>"
        s += "</RykzxxbjRequestForm>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.RYKZXXBJ", "s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            print(json)
        }) { (error) in
            print(error)
        }
    }
}