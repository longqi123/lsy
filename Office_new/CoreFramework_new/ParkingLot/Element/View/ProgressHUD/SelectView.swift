//
//  SelectView.swift
//  GXTax
//
//  Created by J HD on 2016/12/27.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

public class SelectView: UIView {
	
    public class func show(title: String = "", items: [String]) -> SelectView? {
		guard let window = UIApplication.shared.keyWindow else {
			return nil
		}
		let view = SelectView(title: title, items: items)
		view.frame = CGRect(origin: .zero, size: CGSize(width: screenWidth, height: screenHeight))
		view.alpha = 0
		window.addSubview(view)
		UIView.animate(withDuration: 0.25) {
			view.alpha = 1
		}
		return view
	}
	
	fileprivate let cellId = "cell"
	
	 var tableView: UITableView = {
		let table = UITableView(frame: .zero, style: .grouped)
		table.separatorInset = .zero
		table.backgroundColor = UIColor.B1
		return table
	}()
	var back: UIView!
	
	public var selectRow: ((IndexPath) -> Void)?
	
	let items: [String]
	
	public init(title: String, items: [String]) {
		self.items = items
		super.init(frame: .zero)
		backgroundColor = UIColor.L1
        
        
        tableView.register(SelectCell.self, forCellReuseIdentifier: self.cellId)
        tableView.dataSource = self
        tableView.delegate = self
		
		if title != "" {
			let titleLabel = UILabel()
			titleLabel.text = title
			titleLabel.font = UIFont.boldSystemFont(ofSize: 13)
			titleLabel.textColor = UIColor(66, 180, 205)
			back = UIView()
			back.backgroundColor = .white
			back.layer.cornerRadius = 2
			back.clipsToBounds = true
			addSubview(back)
			if 60 + 50*CGFloat(items.count) > screenHeight - 40 {
				back.snp.makeConstraints({ (make) in
					make.edges.equalTo(self).inset(20)
				})
			} else {
				back.snp.makeConstraints({ (make) in
					make.center.equalTo(self)
					make.height.equalTo(60 + 50*CGFloat(items.count))
					make.left.equalTo(self).inset(20)
					make.right.equalTo(self).inset(20)
				})
				tableView.isScrollEnabled = false
			}
			back.addSubview(titleLabel)
			titleLabel.snp.makeConstraints({ (make) in
				make.top.equalTo(back)
				make.left.equalTo(back).inset(15)
				make.right.equalTo(back)
				make.height.equalTo(60)
			})
			back.addSubview(tableView)
			tableView.snp.makeConstraints({ (make) in
				make.left.equalTo(back)
				make.right.equalTo(back)
				make.top.equalTo(titleLabel.snp.bottom)
				make.bottom.equalTo(back)
			})
			let line = back.addLine({ (make) in
				make.height.equalTo(2)
				make.left.equalTo(back)
				make.right.equalTo(back)
				make.bottom.equalTo(titleLabel)
			})
			line.backgroundColor = UIColor(66, 180, 205)
		} else {
			back = UIView()
			back.backgroundColor = .white
			back.layer.cornerRadius = 2
			back.clipsToBounds = true
			addSubview(back)
			if 50*CGFloat(items.count) > screenHeight - 40 {
				back.snp.makeConstraints({ (make) in
					make.edges.equalTo(self).inset(20)
				})
			} else {
				back.snp.makeConstraints({ (make) in
					make.center.equalTo(self)
					make.height.equalTo(50*CGFloat(items.count))
					make.left.equalTo(self).inset(20)
					make.right.equalTo(self).inset(20)
				})
				tableView.isScrollEnabled = false
			}
			back.addSubview(tableView)
			tableView.snp.makeConstraints({ (make) in
				make.edges.equalTo(back)
			})
		}
		let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
		tap.delegate = self
		addGestureRecognizer(tap)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func hide() {
		UIView.animate(withDuration: 0.25, animations: {
			self.alpha = 0
		}) { _ in
			self.removeFromSuperview()
		}
	}
	
}

extension SelectView: UITableViewDataSource {
	
	public func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return items.count
	}
	
	public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SelectCell
		cell.textLabel?.text = items[indexPath.row]
		return cell
	}
	
}

extension SelectView: UITableViewDelegate {
	
	public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 50
	}
	
	public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
	
	public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return .leastNonzeroMagnitude
	}
	
	public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		selectRow?(indexPath)
		hide()
	}
	
}

extension SelectView: UIGestureRecognizerDelegate {
	
	public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		let loc = touch.location(in: self)
		return !back.frame.contains(loc)
	}
	
}
