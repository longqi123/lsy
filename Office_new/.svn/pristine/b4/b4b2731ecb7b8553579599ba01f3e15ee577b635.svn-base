//
//  AppDetailsController.swift
//  Office
//
//  Created by GA GA on 22/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SwiftyJSON

class AppDetailsController: UIViewController {
    
    let cellId1 = "cellId1"
    let cellId2 = "cellId2"
    let cellId3 = "cellId3"
    var yyid = ""
    var sfgz = ""
    
    var scrollView:UIScrollView?
    var lastImageView:UIImageView?
    var originalFrame:CGRect!
    var isDoubleTap:ObjCBool!
    
    
    var tableView = UITableView(frame: .zero, style: .plain)
    var dataSource:AppsDetaisModel?
    var imageData = [Data]()
    
    init(yyid: String, sfgz: String) {
        super.init(nibName: nil, bundle: nil)
        self.yyid = yyid
        self.sfgz = sfgz
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        getData()

        title = "应用详情"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
    }
    
    func makeUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 44
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
        }
        tableView.register(AppListCell.self, forCellReuseIdentifier: cellId1)
        tableView.register(AppIntroductionCell.self, forCellReuseIdentifier: cellId2)
        //        tableView.register(AppInformationCell.self, forCellReuseIdentifier: cellId3)
    }
    
}

extension AppDetailsController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId1, for: indexPath) as! AppListCell
            if let data = self.dataSource {
                cell.set(json: data)
                cell.isFollowedClosure = { [weak self] in
                    
                    self?.follow(index: indexPath.row)
                }
            }
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellId2, for: indexPath) as! AppIntroductionCell
            if let data = self.dataSource {
                cell.set(json: data)
                cell.setPic(images: imageData)
//                cell.tapClosure = { [weak self] a in
//                    print(a)
//                }
            }
            return cell
        } else {
            //            let cell = tableView.dequeueReusableCell(withIdentifier: cellId3, for: indexPath) as! AppInformationCell
            let cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellId3)
            cell.selectionStyle = .none
            //            tableView.rowHeight = 30
            let names = ["信息", "        建设方：", "        大小：", "        版本：", "        更新日期：", "        类别：", "        兼容性：", "        开发商："]
            let images = ["xin_xi", "", "", "", "", "", "", ""]
            let detail = [self.dataSource?.jsfdwDm, self.dataSource?.dx, self.dataSource?.bbh, self.dataSource?.gxrq, self.dataSource?.gllsuuid, self.dataSource?.jrx, self.dataSource?.jsfdwDm]
            cell.imageView?.image = UIImage.init(named: images[indexPath.row - 2])
            if indexPath.row > 2 {
                cell.detailTextLabel?.text = detail[indexPath.row - 3]
            }
            cell.textLabel?.text = names[indexPath.row - 2]
            if indexPath.row == 2 {
                cell.textLabel?.font = UIFont.H3
                cell.textLabel?.textColor = UIColor.T2
            } else {
                cell.textLabel?.font = UIFont.H5
                cell.textLabel?.textColor = UIColor.T3
            }
            
            //            cell.detailTextLabel?.text = "详情"
            return cell
        }
        
    }
}

extension AppDetailsController {
    func addBigImage() {
        
    }
    
}


extension AppDetailsController {
    func getData() {
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm else {
            return
        }
        var s = ""
        let para : [String: Any]
        
        s += "<yyxqfwRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "<yyid>\(self.yyid)</yyid>"
        s += "<jczxDm>0101</jczxDm>"
        s += "</yyxqfwRequestFrom>"
        
        showloading()
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYXQ","s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            let result = json["result"]["yyxqResponseForm"]
            self.dataSource = AppsDetaisModel(json: result)
            let pics = self.dataSource?.yyjt.map{$0["yyjtdz"]}
            
            self.makeUI()
            var picArray = [String]()
            for data in pics! {
                picArray.append(data.rawString()!)
            }
            for imageData in picArray {
                if let decodedData = Data(base64Encoded: imageData, options: .ignoreUnknownCharacters) {
                    self.imageData.append(decodedData)
                }

            }
            self.tableView.reloadData()
            self.hideloading()
        }) { (error) in
            ProgressHUD.toast(message: error)
            self.hideloading()
        }
    }
    
    /// 关注或取消
    ///
    /// - Parameter index:
    func follow(index: Int) {
        
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm,let sfgz  = self.dataSource?.sfgz, let yyid = self.dataSource?.yyid else {
            return
        }
        
        if sfgz == "" || yyid == "" {
            return
        }
        
        let para : [String: Any]

        var s = ""
        
        s += "<yygzfwRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "<yyid>\(yyid)</yyid>"
        s += "<sfgz>\(sfgz)</sfgz>"
        s += "</yygzfwRequestFrom>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYGZ","s": s], sid: "D6666", extra: [:])
        showloading()
        Network.post(parameter: para, success: { (json) in
            print(json)
            let sfgz = json["result"]["yygzResponseForm"]["sfgz"].stringValue
           
                self.dataSource?.sfgz = sfgz
                if sfgz == "01" {
                    ProgressHUD.toast(message: "关注成功")
                } else {
                    ProgressHUD.toast(message: "关注取消成功")
                }
            self.tableView.reloadData()
            self.hideloading()
            
        }) { (error) in
            ProgressHUD.toast(message: error)
            self.hideloading()
        }
        
        
    }
}

