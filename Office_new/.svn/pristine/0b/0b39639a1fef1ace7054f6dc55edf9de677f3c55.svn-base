//
//  SystemMessageViewController.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

class SystemMessageViewController: UIViewController {
    
    // MARK: - Property
    //public
    //private
    let tableView = BaseTableView()
    fileprivate let Identifier = "cell"
    
    // MARK: - Private
    // MARK: - Public
    // MARK: - Action
    // MARK: - Network
    // MARK: - Delegate
    // MARK: - Override
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        creatData()
        creatUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SystemMessageViewController{
    func creatData() {
        
    }
    
    func creatUI() {
        title = "系统消息"
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 50
        let nib = UINib(nibName: "SystemMessageCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: Identifier)
        tableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview()
        }
        tableView.separatorStyle = .none
    }
}

extension SystemMessageViewController: UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath) as! SystemMessageCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
