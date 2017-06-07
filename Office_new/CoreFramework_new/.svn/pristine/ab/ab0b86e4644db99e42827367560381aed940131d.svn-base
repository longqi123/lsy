//
//  DatePicker.swift
//  GXTax
//
//  Created by J HD on 2016/12/19.
//  Copyright © 2016年 J HD. All rights reserved.
//

import DatePickerDialog

public class DatePicker {
	
	private init(){ }
	
	/// 显示datepicker
	///
	/// - Parameter dateClosure: datepick时间回调
	public static func show(dateClosure: @escaping (_ date: Date?) -> Void) {
		let dialog = DatePickerDialog()
		dialog.datePicker.locale = Locale(identifier: "zh_Hans_CN")
		dialog.show(title: "", doneButtonTitle: "确定", cancelButtonTitle: "取消", defaultDate: Date(), minimumDate: nil, maximumDate: nil, datePickerMode: .date, callback: dateClosure)
	}
	
	/// 近显示年月或年
	///
	/// - Parameters:
	///   - mode: 模式
	///   - dateClosure: datepick时间回调
	public static func show(mode: TwoRowDatePicker.Mode, dateClosure: @escaping (_ date: Date?) -> Void) {
		TwoRowDatePicker.show(mode: mode, callBack: dateClosure)
	}
	
}

public class TwoRowDatePicker: UIView {
	
	public enum Mode {
		case year
		case yearAndMonth
	}
	
	public static func show(mode: Mode = .yearAndMonth, callBack: ((_ date: Date?)->Void)? = nil) {
		let back = UIView()
		back.backgroundColor = UIColor.black.withAlphaComponent(0.5)
		let rect = CGRect(x: (screenWidth - 300)/2, y: (screenHeight - 281)/2, width: 300, height: 281)
		let picker = TwoRowDatePicker(mode: mode, frame: rect)
		picker.successCallBack = callBack
		back.addSubview(picker)
		picker.snp.makeConstraints { (make) in
			make.width.equalTo(300)
			make.height.equalTo(281)
			make.center.equalToSuperview()
		}
		guard let window = UIApplication.shared.keyWindow else {
			return
		}
		window.addSubview(back)
		back.frame = CGRect(origin: .zero, size: CGSize(width: screenWidth, height: screenHeight))
		picker.show()
	}
	
	 var datePicker: UIPickerView!
	
	 var cancelButton: UIButton!
	
	 var doneButton: UIButton!
	
	var successCallBack: ((_ date: Date?)->Void)?
	
	let mode: Mode
	let year: [Int]
	let month: [Int]
	
	init(mode: Mode, frame: CGRect) {
		self.mode = mode
		self.year = Array(1900...2100)
		month = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
		super.init(frame: frame)
		clipsToBounds = true
		layer.cornerRadius = 7
		layer.shouldRasterize = true
		layer.rasterizationScale = UIScreen.main.scale
		layer.transform = CATransform3DMakeScale(1.3, 1.3, 1)
        
        datePicker = UIPickerView()
        datePicker.dataSource = self
        datePicker.delegate = self
		addSubview(datePicker)
		datePicker.snp.makeConstraints { (make) in
			make.top.equalToSuperview().inset(30)
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.bottom.equalToSuperview().inset(51)
		}
		
		let gradient: CAGradientLayer = CAGradientLayer(layer: self.layer)
		gradient.frame = bounds
		gradient.colors = [UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor,
		                   UIColor(red: 233/255, green: 233/255, blue: 233/255, alpha: 1).cgColor,
		                   UIColor(red: 218/255, green: 218/255, blue: 218/255, alpha: 1).cgColor]
		layer.insertSublayer(gradient, at: 0)
		
		let lineView = UIView(frame: CGRect(x: 0, y: bounds.size.height - 50 - 1, width: bounds.size.width, height: 1))
		lineView.backgroundColor = UIColor(red: 198/255, green: 198/255, blue: 198/255, alpha: 1)
		addSubview(lineView)
		lineView.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.right.equalToSuperview()
			make.height.equalTo(1)
			make.top.equalTo(datePicker.snp.bottom)
		}
		
        cancelButton = UIButton(type: .custom)
        cancelButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: .highlighted)
        cancelButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        cancelButton.setTitle("取消", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
		addSubview(cancelButton)
		cancelButton.snp.makeConstraints { (make) in
			make.left.equalToSuperview()
			make.top.equalTo(lineView.snp.bottom)
			make.bottom.equalToSuperview()
		}
		
        doneButton = UIButton(type: .custom)
        doneButton.setTitleColor(UIColor(red: 0, green: 0.5, blue: 1, alpha: 1), for: .normal)
        doneButton.setTitleColor(UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 0.5), for: .highlighted)
        doneButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        doneButton.setTitle("确定", for: .normal)
        doneButton.addTarget(self, action: #selector(done), for: .touchUpInside)
		addSubview(doneButton)
		doneButton.snp.makeConstraints { (make) in
			make.right.equalToSuperview()
			make.top.equalTo(lineView.snp.bottom)
			make.bottom.equalToSuperview()
			make.left.equalTo(cancelButton.snp.right)
			make.width.equalTo(cancelButton)
		}
		
		let calendar = Calendar.current
		let components = calendar.dateComponents([.year, .month], from: Date())
		guard let i = components.year, let yearIndex = year.index(of: i) else { return }
		datePicker.selectRow(yearIndex, inComponent: 0, animated: false)
		guard let m = components.month, let monthIndex = month.index(of: m), mode == .yearAndMonth else { return }
		datePicker.selectRow(monthIndex, inComponent: 1, animated: false)
	}
	
	required public init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func done() {
		let year = self.year[datePicker.selectedRow(inComponent: 0)]
		if mode == .year {
			let date = year.description.date5?.addOffset()
			successCallBack?(date)
			hide()
		} else {
			let month = self.month[datePicker.selectedRow(inComponent: 1)]
			let date: Date?
			if month < 10 {
				date = (year.description + "0" + month.description).date4?.addOffset()
			} else {
				date = (year.description + month.description).date4?.addOffset()
			}
			successCallBack?(date)
			hide()
		}
	}
	
	func cancel() {
		hide()
	}
	
	func show() {
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: .curveEaseInOut,
			animations: {
				self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
				self.layer.opacity = 1
				self.layer.transform = CATransform3DMakeScale(1, 1, 1)
			}
		)
	}
	
	func hide() {
		let currentTransform = layer.transform
		UIView.animate(
			withDuration: 0.2,
			delay: 0,
			options: [],
			animations: {
				self.superview?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
				self.layer.transform = CATransform3DConcat(currentTransform, CATransform3DMakeScale(0.6, 0.6, 1))
				self.layer.opacity = 0
		}) { (finished) in
			self.superview?.removeFromSuperview()
		}
	}
	
}

extension TwoRowDatePicker: UIPickerViewDataSource {
	
	public func numberOfComponents(in pickerView: UIPickerView) -> Int {
		return mode == .year ? 1 : 2
	}
	
	public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		if component == 0 {
			return year.count
		} else {
			return month.count
		}
	}
	
}

extension TwoRowDatePicker: UIPickerViewDelegate {
	
	public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		if component == 0 {
			return "\(year[row])年"
		} else {
			return "\(month[row])月"
		}
	}
	
}
