//
//  OrganizationPeopleViewController.swift
//  Office
//
//  Created by roger on 2017/4/10.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class OrganizationPeopleViewController: UIViewController {

    fileprivate let ContactIdentifier = "ContactCell"

    let tableView = BaseTableView(frame: .zero, style: .plain)
    var dataSource: [AddressListModel]!
    
    public init(dataSource: [AddressListModel]) {
        super.init(nibName: nil, bundle: nil)
        self.dataSource = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        creatUI()
    }
}

extension OrganizationPeopleViewController {
    func creatUI() {
        title = "部门人员"
        
        view.addSubview(tableView)
        tableView.estimatedRowHeight = 50
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ContactCell", bundle: nil), forCellReuseIdentifier: ContactIdentifier)
        
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
    }
}

extension OrganizationPeopleViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "双流区地方税务局第一税务所"
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: ContactIdentifier, for: indexPath) as! ContactCell
        cell.nameLabel.text = dataSource[indexPath.row].name
        cell.photoLabel.text = dataSource[indexPath.row].phonename
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PersonalDetailController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
