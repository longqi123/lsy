//
//  Select.swift
//  Pods
//
//  Created by roger on 2017/4/14.
//
//

import UIKit

class Select: UIView {
    
    fileprivate let Identifier = "SelectsCell"
    fileprivate let SelectHeaderIdentifier = "SelectHeaderCell"
    fileprivate let backView = UIView()
    fileprivate let contentView = UIView()
    fileprivate var block: ((IndexPath)->())?
    fileprivate var cancel: (()->())?

    fileprivate let tableView = BaseTableView()
    fileprivate let cancleBtn = UIButton()
    fileprivate var items: [String]!
    fileprivate var head: String!
    fileprivate let maxHeight = Int(screenHeight * 0.8)
    fileprivate let minHeight = Int(3 * 44 + 50 + 60)
    fileprivate static let shareInstance = Select()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        addSubview(backView)
        backView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.left).offset(45)
            make.right.equalTo(backView.snp.right).offset(-45)
            make.height.equalTo(100)
            make.center.equalTo(backView)
        }
        
        addSubview(tableView)
        addSubview(cancleBtn)
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(contentView.snp.top)
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(cancleBtn.snp.top)
        }
        tableView.estimatedRowHeight = 44
        tableView.sectionHeaderHeight = 60
        tableView.backgroundColor = UIColor.B2
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SelectsCell.self, forCellReuseIdentifier: Identifier)
        tableView.register(SelectHeaderCell.self, forHeaderFooterViewReuseIdentifier: SelectHeaderIdentifier)
        
        let view = UIView()
        view.backgroundColor = UIColor.L1
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(cancleBtn.snp.top)
            make.height.equalTo(0.5)
        }
        
        cancleBtn.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left)
            make.right.equalTo(contentView.snp.right)
            make.bottom.equalTo(contentView.snp.bottom)
            make.height.equalTo(50)
        }
        cancleBtn.setTitle("取消", for: .normal)
        cancleBtn.setTitleColor(UIColor.T7, for: .normal)
        cancleBtn.titleLabel?.font = UIFont.H2
        cancleBtn.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked() {
        
        if let block = Select.shareInstance.cancel {
            DispatchQueue.main.async(execute: {
                block()
            })
        }
    
//        UIView.animate(withDuration: 0.1, animations: {
            Select.shareInstance.alpha = 0.0
//        }) { (true) in
            Select.shareInstance.removeFromSuperview()
//        }
    }
    
    public static func show(items: [String], head: String? = "请选择", block:((IndexPath)->())?,cancel:(()->())?){
        guard let window = UIApplication.shared.keyWindow else {return}
        
        let select = Select.shareInstance
        select.items = items
        select.block = block
        select.cancel = cancel
        select.head = head
        
        window.addSubview(select)
        window.bringSubview(toFront: select)
        select.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        var contentHeight = items.count * 44 + 50 + 60
        if contentHeight >= select.maxHeight {
            contentHeight = select.maxHeight
        }else if contentHeight < select.minHeight{
            contentHeight = select.minHeight
        }
        
        select.contentView.snp.remakeConstraints { (make) in
            make.left.equalTo(select.backView.snp.left).offset(45)
            make.right.equalTo(select.backView.snp.right).offset(-45)
            make.height.equalTo(contentHeight)
            make.center.equalTo(select.backView)
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            select.alpha = 1.0
            select.tableView.reloadData()
        })
    }
    
}

extension Select: UITableViewDelegate, UITableViewDataSource{
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: SelectHeaderIdentifier) as! SelectHeaderCell
        cell.title.text = head
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Identifier, for: indexPath) as! SelectsCell
        cell.title.text = items[indexPath.row]
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let block = Select.shareInstance.block {
            DispatchQueue.main.async(execute: {
                Select.shareInstance.clicked()
                block(indexPath)
            })
        }
    }
}

class SelectsCell: BaseTableViewCell {
    
    let title = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(title)
        title.textColor = UIColor.T2
        title.font = UIFont.H3
        title.numberOfLines = 0
        title.snp.makeConstraints { (make) in
//            make.top.equalTo(contentView.snp.top).offset(5)
//            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
            make.left.equalTo(contentView.snp.left).offset(15)
            make.right.equalTo(contentView.snp.right).offset(-15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectHeaderCell: UITableViewHeaderFooterView {
    
    let title = UILabel()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        let view = UIView()
        view.backgroundColor = UIColor.L1
        contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(0.5)
        }
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(title)
        title.textColor = UIColor.T1
        title.font = UIFont.H1
        title.snp.makeConstraints { (make) in
            make.left.equalTo(contentView.snp.left).offset(15)
            make.centerY.equalTo(contentView.snp.centerY)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}


