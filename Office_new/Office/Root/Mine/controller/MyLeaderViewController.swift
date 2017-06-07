//
//  MyLeaderViewController.swift
//  Office
//
//  Created by GA GA on 18/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON

class MyLeaderViewController: UIViewController {
    
    let cellId = "cellId"
    var tableView = UITableView(frame: .zero, style: .grouped)
    var dataSource: [TxlModel1] = []
    var MyLeaderBlock: ((_ model: TxlModel1) -> Void)?
    var head = MyLeaderHeaderView()
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        let rightButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:  #selector(setMyLeader))
        navigationItem.rightBarButtonItem = rightButton
        
        title = "领导选择"
        getData()
        
        view.addSubview(head)
        head.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(view)
            make.right.equalTo(view)
        }
        
        
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(view)
            make.top.equalTo(head.snp.bottom)
            make.right.equalTo(view)
            make.bottom.equalTo(view)
        }
        tableView.register(MyLeaderCell.self, forCellReuseIdentifier: cellId)
    }
}
extension MyLeaderViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyLeaderCell
        cell.set(json: dataSource[indexPath.row])
        self.head.set(json: self.dataSource[0])

        if  indexPath.row == selectedIndex {
            cell.selectImage.image = #imageLiteral(resourceName: "xuan_zhong_zhuang_tai_big")
        }else{
            cell.selectImage.image = #imageLiteral(resourceName: "mei_xuan_zhong_zhuang_tai_big")
        }
        
        return cell
    }
    
}

extension MyLeaderViewController {
    
    func setMyLeader() {
        editLedaer(idx: selectedIndex)
        self.MyLeaderBlock?(self.dataSource[selectedIndex])
    }
}

extension MyLeaderViewController {
    
    func getData(){
        self.showloading()
        guard let csdm = DataCenter.ryxqModel?.csdm else {
            self.hideloading()
            return
        }
        let para: [String: Any]
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.TXLCX", "s":"<TxlcxRequestForm><swjgDm>\(csdm)</swjgDm><yhmc></yhmc></TxlcxRequestForm><Fenye><FenyeVO><dqys>1</dqys><myts>500</myts><zts>String</zts></FenyeVO></Fenye>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            let data = json["result"]["TxlcxRyReturnVO"]["TxlcxRyResponseGridlb"]
            if data.count > 0{
                if data.array != nil{
                    self.dataSource = data.arrayValue.map(TxlModel1.init)
                }else{
                    self.dataSource = [JSONDeserializer<TxlModel1>.deserializeFrom(json:data.rawString())!]
                }
                
                for (idx, item) in self.dataSource.enumerated() {
                    if item.ryxm == DataCenter.dlzhxxModel?.swryxm {
                        self.dataSource.remove(at: idx)
                    }
//                    if item.ryxm == DataCenter.ryxqModel?.zsldmc {
//                        self.selectedIndex = idx
//                    }
                    
                }
                
                for (idx, item) in self.dataSource.enumerated() {
//                    if item.ryxm == DataCenter.dlzhxxModel?.swryxm {
//                        self.dataSource.remove(at: idx)
//                    }
                    if item.ryxm == DataCenter.ryxqModel?.zsldmc {
                        self.selectedIndex = idx
                    }
                    
                }
                self.tableView.reloadData()
                self.hideloading()
            }
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
    
    func editLedaer(idx: Int) {
        
        guard let rydm = DataCenter.ryxqModel?.rydm  else {
            return
        }
        showloading()
        let zslddm = dataSource[idx].rydm
        let zsldmc = dataSource[idx].ryxm
        
        
        guard let qq = DataCenter.ryxqModel?.qqzh, let wechat = DataCenter.ryxqModel?.wxzh else {
            return
        }
        let para: [String: Any]
        var s = ""

        s += "<RykzxxbjRequestForm>"
        s += "<rydm>\(rydm)</rydm>"
        s += "<qqzh>\(qq)</qqzh>"
        s += "<wxzh>\(wechat)</wxzh>"
        s += "<zsldDm>\(zslddm)</zsldDm>"
        s += "<zsldmc>\(zsldmc)</zsldmc>"
        s += "</RykzxxbjRequestForm>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.RYKZXXBJ", "s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            
            let returnMsg = json["result"]["returnMsg"].stringValue
            let returnBz = json["result"]["returnBz"].stringValue
            if returnBz == "0" {
                ProgressHUD.toast(message: returnMsg)
            } else {
                DataCenter.ryxqModel?.zsldDm = zslddm
                DataCenter.ryxqModel?.zsldmc = zsldmc
                self.navigationController?.popViewController(animated: true)
                ProgressHUD.toast(message: "修改成功")
            }
            self.hideloading()
        }) { (error) in
            print(error)
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}