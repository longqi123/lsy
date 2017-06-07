
//
//  SurveyViewController.swift
//  Office
//
//  Created by roger on 2017/6/7.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class SurveyViewController: UIViewController {
    
    let tableView = BaseTableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "问卷调查"
        creatUI()
    }
}

extension SurveyViewController{
    func creatUI() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

extension SurveyViewController: UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("AnnouncementControllerCell", owner: self, options: nil)?.last as! AnnouncementControllerCell
        if indexPath.row == 0 {
            cell.photoImg.image = #imageLiteral(resourceName: "shou_dao_wen_juan")
            cell.content.text = "收到问卷"
        }else if indexPath.row == 1{
            cell.photoImg.image = #imageLiteral(resourceName: "fa_chu_wen_juan")
            cell.content.text = "发出问卷"
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            //收到问卷
            let vc = NewReceiveNotifiViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else if indexPath.row == 1{
            //发出问卷
            let vc = SendNotificationController()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}
