//
//  VerifyCell.swift
//  Office
//
//  Created by GA GA on 17/05/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit
import AFNetworking
import CoreFramework

fileprivate let VerifyImage = ServerURL + "authCode"

class VerifyCell: UITableViewCell {

    var textFiled: LineTextField!
    var codeImage: UIImageView!
    var errorClosure: ((String)->Void)?
    
    init() {
        super.init(style: .default, reuseIdentifier: nil)
        selectionStyle = .none
        textFiled = LineTextField(linePadding: 0)
        textFiled.placeholder = "请输入验证码"
        textFiled.font = UIFont.H4
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "login_icon_usr_")
        imageView.contentMode = .center
        textFiled.leftView = imageView
        contentView.addSubview(textFiled)
        textFiled.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(25)
            make.height.equalTo(53)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }

        codeImage = UIImageView()
        codeImage.isUserInteractionEnabled = true
        codeImage.contentMode = .scaleAspectFit
        contentView.addSubview(codeImage)
        codeImage.snp.makeConstraints { (make) in
            make.width.equalTo(77)
            make.right.equalTo(contentView).inset(17)
            make.height.equalTo(37)
            make.bottom.equalTo(textFiled)
            make.left.equalTo(textFiled.snp.right).offset(8)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapped))
        codeImage.addGestureRecognizer(tap)
        setImage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapped() {
        setImage()
    }
    
    /// 验证码获取
    func setImage() {
        guard let url = URL(string: VerifyImage) else {
            return
        }
        AFImageDownloader.defaultInstance().downloadImage(
            for: URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10),
            success: { (_, _, image) in
                self.codeImage.image = image
        }) { (_, _, error) in
            print(error.localizedDescription)
            self.errorClosure?(error.localizedDescription)
        }
    }
}
