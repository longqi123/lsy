//
//  Alert.swift
//  Pods
//
//  Created by roger on 2017/4/13.
//
//

import UIKit

public enum AlertType {
    ///失败
    case failure

}

class Alert: UIView {
    
    fileprivate let backView = UIView()
    fileprivate let contentView = UIView()
    fileprivate let imageView = UIImageView()
    fileprivate let title = UILabel()
    fileprivate let detail = UILabel()
    fileprivate let button = UIButton()
    fileprivate var block: (()->())?
    fileprivate var type: AlertType = .failure

    private static let shareInstance = Alert()

    override init(frame: CGRect) {
        super.init(frame: frame)
    
        addSubview(backView)
        backView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addSubview(contentView)
        contentView.backgroundColor = UIColor.white
        contentView.layer.cornerRadius = 5.0
        contentView.snp.makeConstraints { (make) in
            make.left.equalTo(backView.snp.left).offset(45)
            make.right.equalTo(backView.snp.right).offset(-45)
            make.height.lessThanOrEqualTo(300)
            make.center.equalToSuperview()
        }
        
        addSubview(imageView)
        imageView.image = UIImage(named: "jiao_kuan_shi_bai")
        imageView.sizeToFit()
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(contentView.snp.top).offset(25)
        }
    
        addSubview(title)
        title.textColor = UIColor.T1
        title.font = UIFont.H3
        title.textAlignment = .center
        title.numberOfLines = 1
        title.adjustsFontSizeToFitWidth = true
        title.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).inset(-15)
            make.left.equalTo(contentView.snp.left).inset(25)
            make.right.equalTo(contentView.snp.right).inset(25)
        }
        
        addSubview(detail)
        addSubview(button)

        detail.textColor = UIColor.T1
        detail.font = UIFont.H3
        detail.textAlignment = .center
        detail.numberOfLines = 0
        detail.snp.makeConstraints { (make) in
            make.top.equalTo(title.snp.bottom).inset(-25)
            make.left.equalTo(contentView.snp.left).inset(25)
            make.right.equalTo(contentView.snp.right).inset(25)
            make.bottom.equalTo(button.snp.top).inset(-25)
        }
        
        let view = UIView()
        view.backgroundColor = UIColor.L1
        addSubview(view)
        view.snp.makeConstraints { (make) in
            make.left.right.equalTo(contentView)
            make.bottom.equalTo(button.snp.top)
            make.height.equalTo(0.5)
        }
        
        button.setTitleColor(UIColor.T7, for: .normal)
        button.titleLabel?.font = UIFont.H3
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(clicked), for: .touchUpInside)
        button.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(contentView)
            make.height.equalTo(50)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clicked() {
        if let block = Alert.shareInstance.block {
            DispatchQueue.main.async(execute: {
                block()
            })
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            Alert.shareInstance.alpha = 0.0
        }) { (true) in
            Alert.shareInstance.removeFromSuperview()
        }
    }
    
    public static func failure(title: String, detail: String, failure: (()->())?){
        Alert.shareInstance.block = failure
        Alert.show(title: title, detail: detail)
    }
    
    public static func failure(title: String, detail: String){
        Alert.show(title: title, detail: detail)
    }
    
    fileprivate static func show(title: String, detail: String) {
        guard let window = UIApplication.shared.keyWindow else {return}
        
        let alertView = Alert.shareInstance
        alertView.title.text = title
        alertView.detail.text = detail
        
        window.addSubview(alertView)
        window.bringSubview(toFront: alertView)
        alertView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        UIView.animate(withDuration: 0.1, animations: {
            alertView.alpha = 1.0
        })
    }
    
    
    
}
