//
//  AppListController.swift
//  Office
//
//  Created by GA GA on 22/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework
import HandyJSON

class AppListController: UIViewController {
    let cellId = "cellId"
    
    /// 应用列表
    var dataSource = [AppSquareModel]()
    /// 已关注应用
    var appsModel = [WorkDeskModel]()
    
    var yyfl = ""
    var yymc = ""
    var gnxx = ""
    var isSearchVC = false
    var isFollowedVC = false
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    init(yyfl: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = "应用列表"
        self.yyfl = yyfl
    }
    
    init(isFollowedVC: Bool) {
        super.init(nibName: nil, bundle: nil)
        self.title = "已关注应用"
        self.isFollowedVC = isFollowedVC
    }
    
    init(yymc: String, isSearchVC: Bool, model: [AppSquareModel]) {
        super.init(nibName: nil, bundle: nil)
        self.title = yymc
        self.yymc = yymc
        self.dataSource = model
        self.isSearchVC = isSearchVC
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if isFollowedVC {
            getIsFollowedData()
        } else if isSearchVC {
            
        } else {
            getData()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let leftBtn: UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(actionBack))
        let leftBtn: UIBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(actionBack))
        self.navigationItem.leftBarButtonItem = leftBtn

        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
        }
        tableView.register(AppListCell.self, forCellReuseIdentifier: cellId)
        tableView.estimatedRowHeight = 44
    }
    
}

extension AppListController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFollowedVC {
            return appsModel.count
        } else {
            return dataSource.count
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFollowedVC {
            let yyid = appsModel[indexPath.row].yyid
            
            let detailsVC = AppDetailsController(yyid: yyid, sfgz: "01")
            navigationController?.pushViewController(detailsVC, animated: true)
        } else {
            let yyid = dataSource[indexPath.row].yyid
            let sfgz = dataSource[indexPath.row].sfgz
            let detailsVC = AppDetailsController(yyid: yyid, sfgz: sfgz)
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! AppListCell
        
        if self.isFollowedVC {
            cell.set(json: appsModel[indexPath.row])
        } else {
            cell.set(json: dataSource[indexPath.row])
        }
        cell.isFollowedClosure = { [weak self] in
            
            self?.follow(index: indexPath.row)
        }
        return cell
    }
    
}

extension AppListController {
    
    /// 应用列表
    func getData() {
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm, let swjgdm = DataCenter.dlzhxxModel?.swjgDm else {
            return
        }
        //        let dqys = 1
        //        let myts = 50
        //        let zts = ""
        //        let yymc = ""
        //        let gnxx = 1
        //        let yyfl = 1002
        //        let topts = 10
        //        let yylb = ""
        //        let jczxDm = 0202
        
        let para : [String: Any]
        
        var s = ""
        s += "<yyzsfwRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "<swjgDm>\(swjgdm)</swjgDm>"
        s += "<fengy>"
        s += "<FenyeVO>"
        s += "<dqys>1</dqys>"
        s += "<myts>50</myts>"
        s += "<zts></zts>"
        s += "</FenyeVO>"
        s += "</fengy>"
        s += "<yymc>\(yymc)</yymc>"
        s += "<gnxx>\(3)</gnxx>"
        s += "<yyfl>\(yyfl)</yyfl>"
        s += "<topts></topts>"
        s += "<jczxDm>0101</jczxDm>"
        s += "</yyzsfwRequestFrom>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYZS","s": s], sid: "D6666", extra: [:])
        showloading()
        Network.post(parameter: para, success: { (json) in
            print(json)
            
            if json["result"]["yyzsResponseForm"]["yyzsfwResponseForm"]["yyzsResponselb"]["yyzsfwResponseGrid"]["yyzsfwResponselb"].isEmpty {
            } else {
                self.dataSource = json["result"]["yyzsResponseForm"]["yyzsfwResponseForm"]["yyzsResponselb"]["yyzsfwResponseGrid"]["yyzsfwResponselb"].arrayResult.map{AppSquareModel(json:$0)}
            }
            
            self.tableView.reloadData()
            self.hideloading()
        }) { (error) in
            ProgressHUD.toast(message: error)
            self.hideloading()
        }
        
    }
    
    
    /// 已关注应用
    func getIsFollowedData() {
        let para: [String: Any]
        var s = ""
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm else {
            return
        }
        showloading()
        s += "<yyxxhqRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "</yyxxhqRequestFrom>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYXXHQ", "s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            let result = json["result"]["yyxxhqResponseForm"]["yyxxhqResponseGrid"]["yyxxhqResponselb"]
            if result.count > 0 {
                if result.array != nil {
                    self.appsModel = result.arrayValue.map(WorkDeskModel.init)
                    
                } else {
                    self.appsModel = [JSONDeserializer<WorkDeskModel>.deserializeFrom(json:result.rawString())!]
                    
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
        
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm else {
            return
        }
        
        var sfgz = ""
        var yyid = ""
        
        if isFollowedVC {
            sfgz = "01"
            yyid = appsModel[index].yyid
        } else {
            sfgz  = self.dataSource[index].sfgz
            yyid = self.dataSource[index].yyid
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
            if self.isFollowedVC {
//                self.getIsFollowedData()
                self.appsModel.remove(at: index)
                ProgressHUD.toast(message: "关注取消成功")
            } else {
                self.dataSource[index].sfgz = sfgz
                if sfgz == "01" {
                    ProgressHUD.toast(message: "关注成功")
                } else {
                    ProgressHUD.toast(message: "关注取消成功")
                }
            }
            self.tableView.reloadData()
            self.hideloading()
            
        }) { (error) in
            ProgressHUD.toast(message: error)
            self.hideloading()
        }
        
        
    }
}

extension AppListController {
    func actionBack() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getData"), object: nil)

        navigationController?.popViewController(animated: true)
    }
}
