//
//  DetailViewController.swift
//  GXTax
//
//  Created by roger on 2017/2/23.
//  Copyright © 2017年 J HD. All rights reserved.
//

import UIKit

public class DetailViewController: UIViewController {
    
    var dataSource: [DetailModel]?
    
    fileprivate let cellId = "cell"
    
     var contentView = UIView.panel
    
     var titleView: UILabel = {
        let label = UILabel()
        label.font = .normal(14)
        label.textColor = .white
        return label
    }()
    
     var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "icon_close_white"), for: .normal)
        button.setImage(#imageLiteral(resourceName: "icon_close_gray"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "icon_close_gray"), for: .highlighted)
        button.imageView?.contentMode = .center
        return button
    }()
    
     var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.allowsMultipleSelection = false
        table.separatorInset = .zero
        
        table.backgroundColor = UIColor.B1
        table.estimatedRowHeight = 150
        return table
    }()
    
    public var selectItem: ((String)->Void)?
    
    
    public init(title: String, data: [DetailModel]) {
        self.dataSource = data
        super.init(nibName: nil, bundle: nil)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
        titleView.text = title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.B1
        
        tableView.register(DetailCell.self, forCellReuseIdentifier: self.cellId)
        tableView.delegate = self
        tableView.dataSource = self
        
        let titleBackView = UIView()
        titleBackView.backgroundColor = UIColor.B2
        contentView.addSubview(titleBackView)
        titleBackView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.height.equalTo(40)
        }
        titleBackView.addSubview(titleView)
        titleView.snp.makeConstraints { (make) in
            make.left.equalTo(titleBackView).inset(15)
            make.top.equalTo(titleBackView)
            make.height.equalTo(titleBackView)
            make.right.equalTo(titleBackView).inset(40)
        }
        titleBackView.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.left.equalTo(titleView.snp.right)
            make.height.equalTo(titleView)
            make.top.equalTo(titleView)
            make.right.equalTo(titleBackView)
        }
        view.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
            make.left.equalTo(view).inset(30)
            make.right.equalTo(view).inset(30)
            make.height.equalTo(360)
        }
        contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.bottom.equalTo(contentView)
            make.top.equalTo(titleBackView.snp.bottom)
        }
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
    }
    
    func close() {
        dismiss(animated: true, completion: nil)
    }

}

extension DetailViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource!.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! DetailCell
        cell.set(model: (dataSource![indexPath.section]))
        return cell
    }
    
}

extension DetailViewController: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let str = dataSource?[indexPath.row]
        selectItem?((str?.nsrmc)!)
        close()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return .leastNonzeroMagnitude
    }
}
