//
//  MineViewController.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SDWebImage

class MineViewController: UIViewController {
    
    let cellId = "cellId"
    let headerId = "header"
    let titles = ["我的详情", "我的领导","清除缓存","版本检测"]
    let icons = [#imageLiteral(resourceName: "zhang_hao_cha_kan"), #imageLiteral(resourceName: "wo_de_ling_dao"), #imageLiteral(resourceName: "qing_chu_huan_cun"), #imageLiteral(resourceName: "ban_ben_jian_ce")]
    
    let button = UIButton()
    
    func setButtonStyle(state: Bool) {
        if state {
            button.setTitle(" 退出", for: .normal)
            button.setImage(#imageLiteral(resourceName: "tui_chu"), for: .normal)
            button.setTitleColor(UIColor.T1, for: .normal)
            button.titleLabel?.font = UIFont.H2
            button.backgroundColor = .white
        } else {
            button.setTitle("登 录", for: .normal)
            button.setImage(nil, for: .normal)
            button.setTitleColor(.white, for: .normal)
            //warning 谭宇翔删除了system颜色值
            button.backgroundColor = UIColor.B1
            button.titleLabel?.font = UIFont.H2
            
        }
    }
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.isHidden = true
        self.setButtonStyle(state: System.isLogin)
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        title = "我的"
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        view.addSubview(button)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        button.snp.makeConstraints { (make) in
            make.bottom.equalTo(view)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.height.equalTo(59)
        }
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(button.snp.top)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.top.equalTo(view)
        }
        tableView.register(MineHeaderView.self, forHeaderFooterViewReuseIdentifier:headerId )
        tableView.register(MineCell.self, forCellReuseIdentifier: cellId)
        
        
    }
    
    
}

extension MineViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 262
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MineCell
        
        cell.titleLabel.text = titles[indexPath.row]
        cell.leftImageView.image = icons[indexPath.row]
        cell.rightImageView.image = #imageLiteral(resourceName: "jian_tou_xiang_you")
        
        if indexPath.row == 0 {
            
        } else if indexPath.row == 1 {
            cell.detail.text = DataCenter.ryxqModel?.zsldmc

        } else if indexPath.row == 2 {
            let sd = SDImageCache.shared()
            if let  size = sd?.getSize() {
                let doubleSize = Double(size)
                let my = doubleSize/(1024 * 1024)
                cell.detail.text = String(my.tdpString + " MB")
            } else {
                cell.detail.text = "0.0"
            }
            
        } else {
            let sysVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            
            cell.detail.text = sysVersion
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId)
            as! MineHeaderView
        header.set(json: DataCenter.dlzhxxModel)
        
        //点击头像跳转详情（暂时关闭）
//        header.headerBlock = { [weak self] in
//            self?.navigationController?.pushViewController(EditinformationController(), animated: true)
//        }
        
        header.backBlock = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(EditinformationController(), animated: true)
            
        } else if indexPath.row == 1 {
            self.navigationController?.pushViewController(MyLeaderViewController(), animated: true)
            
        } else if indexPath.row == 2 {
            removeCache()

        } else if indexPath.row == 3 {
            checkVersion()
        }
    }
    
}

// MARK: - 事件响应
extension MineViewController {
    func buttonTapped() {
        if System.isLogin {
            self.logout()
            
        } else {
            let loginVC = LoginViewController()
            self.present(loginVC, animated: true, completion: nil)
        }
    }
    
    /// 退出登录
    func logout() {
        System.isLogin = false
        self.setButtonStyle(state: System.isLogin)
        DataCenter.dlzhxxModel = nil
        DataCenter.ryxqModel = nil
        self.tableView.reloadData()
        ProgressHUD.toast(message: "退出成功")
        present(LoginViewController(), animated: true, completion: nil)
    }
    
}

extension MineViewController {
    
    func removeCache() {
        let vc = UIAlertController(title: "确认清除缓存？", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "取消", style: .default, handler: { [weak vc] (action) in
            vc?.dismiss(animated: true, completion: nil)
        })
        let action = UIAlertAction(title: "确定", style: .default, handler: { [weak self] (action) in
            let sd = SDImageCache.shared()
            sd?.clearDisk(onCompletion: {
                ProgressHUD.toast(message: "缓存清理成功")
                self?.tableView.reloadData()
            })
            
        })
        vc.addAction(cancel)
        vc.addAction(action)
        DispatchQueue.main.async {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func checkVersion() {
        let para: [String: Any]
        
        //versionCode：Int类型版本号
        //appCode: 1 代表iOS,0 代表安卓
        para = paraMaker(data: ["versionCode": System.versionCode, "appCode": 1], sid: "D1012", extra: [:])
        
        Network.post(parameter: para, success: { (json) in
            let result = json["result"]
            let versionCode = result["data"]["versionCode"].stringValue
            if versionCode == "" {
                ProgressHUD.toast(message: "已是最新版本")
                return
            }
            let versionName = result["data"]["versionName"].stringValue
            
            if System.versionCode < Int(versionCode)!{
                let alert = UIAlertController(title:nil, message: "发现新版本\(versionName)", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "立即更新", style: UIAlertActionStyle.default, handler: { (action) in
                    
                })
                let cancle = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                alert.addAction(action)
                alert.addAction(cancle)
                
                self.present(alert, animated: true, completion: nil)
            } else {
                ProgressHUD.toast(message: "已是最新版本")
            }
        }, failure: { (error) in
            print(error)
        })
        
    }
}