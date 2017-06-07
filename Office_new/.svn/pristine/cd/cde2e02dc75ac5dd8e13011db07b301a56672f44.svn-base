//
//  PeopleDetailViewController.swift
//  Office
//
//  Created by roger on 2017/4/10.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class PeopleDetailViewController: UIViewController {

    fileprivate let PhotoIdentifier = "PhotoCell"
    fileprivate let PeopleDetailIdentifier = "PeopleDetailCell"
    fileprivate let AddressTitleIdentifier = "AddressTitleCell"
    fileprivate let PeopleDetailBottomIdentifier = "PeopleDetailBottomCell"

    let dataSource: AddressListModel!
    let tableView = BaseTableView(frame: .zero, style: .plain)
    
    init(model: AddressListModel) {
        self.dataSource = model
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension PeopleDetailViewController {
    func creatUI() {
        title = "个人详情"
        
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PhotoCell", bundle: nil), forCellReuseIdentifier: PhotoIdentifier)
        tableView.register(UINib(nibName: "PeopleDetailCell", bundle: nil), forCellReuseIdentifier: PeopleDetailIdentifier)
        tableView.register(UINib(nibName: "AddressTitleCell", bundle: nil), forCellReuseIdentifier: AddressTitleIdentifier)
        tableView.register(UINib(nibName: "PeopleDetailBottomCell", bundle: nil), forCellReuseIdentifier: PeopleDetailBottomIdentifier)

        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension PeopleDetailViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0  {
            let cell = tableView.dequeueReusableCell(withIdentifier: PhotoIdentifier, for: indexPath) as! PhotoCell
            cell.name.text = dataSource.name!
            return cell
        }else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: AddressTitleIdentifier, for: indexPath) as! AddressTitleCell
            return cell
        }else if indexPath.row == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleDetailIdentifier, for: indexPath) as! PeopleDetailCell
            cell.titleLabel.text = "姓名"
            cell.detailLabel.text = dataSource.name!
            return cell
        }else if indexPath.row == 3{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleDetailIdentifier, for: indexPath) as! PeopleDetailCell
            cell.delegate = self
            cell.titleLabel.text = "电话"
            cell.detailLabel.text = dataSource.phone!
            cell.button.setImage(UIImage(named:"tianjia"), for: .normal)
            return cell
        }else if indexPath.row == 4{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleDetailIdentifier, for: indexPath) as! PeopleDetailCell
            cell.delegate = self
            cell.titleLabel.text = "email"
            cell.detailLabel.text = "lj@scdsj.com.cn"
            cell.button.setImage(UIImage(named:"youjian"), for: .normal)
            return cell
        }else if indexPath.row == 5{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleDetailIdentifier, for: indexPath) as! PeopleDetailCell
            cell.titleLabel.text = "部门"
            cell.detailLabel.text = "地方税务局第一税务所"
            return cell
        }else if indexPath.row == 6{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleDetailIdentifier, for: indexPath) as! PeopleDetailCell
            cell.titleLabel.text = "职务级别"
            cell.detailLabel.text = "税务服务厅工作人员"
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: PeopleDetailBottomIdentifier, for: indexPath) as! PeopleDetailBottomCell
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.navigationController?.pushViewController(PeopleDetailViewController(), animated: true)
    }
    
}

extension PeopleDetailViewController: PeopleDetailDelegate{
    func buttonClicked() {
        
    }
}
