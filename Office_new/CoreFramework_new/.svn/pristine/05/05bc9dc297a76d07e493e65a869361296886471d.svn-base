//
//  Toast.swift
//  Pods
//
//  Created by roger on 2017/4/14.
//
//

import Foundation
import UIKit

public class Toast: UILabel{
    
    public var timeLeft = 0
    var timer: Timer?
    
    public static let shareInstance = Toast()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.systemFont(ofSize: 15)
        self.numberOfLines = 0
        self.layer.cornerRadius = 3
        self.clipsToBounds = true
        self.textAlignment = .center
        self.textColor = .white
        self.backgroundColor = UIColor(white: 0, alpha: 0.66)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(hide))
        self.addGestureRecognizer(tap)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func show(_ message:String) {
        
        if Toast.shareInstance.timeLeft != 0 {
            Toast.shareInstance.timeLeft = 3
            Toast.shareInstance.text = message
            Toast.shareInstance.alpha = 1
            return
        } else {
            guard let window = UIApplication.shared.keyWindow else {return}
            Toast.shareInstance.timeLeft = 3
            Toast.shareInstance.text = message
            Toast.shareInstance.alpha = 1
            
            window.addSubview(Toast.shareInstance)
            window.bringSubview(toFront: Toast.shareInstance)
            Toast.shareInstance.snp.makeConstraints { (make) in
                make.centerY.equalTo(window.center.y - 80)
                make.centerX.equalTo(window)
                make.width.lessThanOrEqualTo(window).inset(16)
            }
        }
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: .curveEaseIn,
            animations: {
                Toast.shareInstance.center.y -= 40
        },
            completion: nil)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        timer?.fire()
    }
    
    func countDown() {
        if timeLeft == 0{
            hide()
        } else {
            timeLeft -= 1
        }
    }
    
    func hide() {
        guard let _ = timer else { return }
        timer?.invalidate()
        timer = nil
        UIView.animate(
            withDuration: 0.15,
            animations: {
                self.alpha = 0.01
        }) { (b) in
            if b {
                self.removeFromSuperview()
            }
        }
    }
}
