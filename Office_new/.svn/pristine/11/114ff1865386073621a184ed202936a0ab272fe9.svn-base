//
//  LineTextField.swift
//  GXTax
//
//  Created by J HD on 2016/12/20.
//  Copyright © 2016年 J HD. All rights reserved.
//

import UIKit

class LineTextField: UITextField {
    
    let linePadding: CGFloat
    
    init(linePadding: CGFloat = 10){
        self.linePadding = linePadding
        super.init(frame: .zero)
        clearButtonMode = .whileEditing
        clearsOnBeginEditing = false
        leftViewMode = .always
        self.addDoneToolBar()
        font = .normal(14)
        addTarget(self, action: #selector(endEdit), for: .editingDidEnd)
    }
    
    init(image: UIImage, placeHolder: String, linePadding: CGFloat = 10){
        self.linePadding = linePadding
        super.init(frame: .zero)
        clearButtonMode = .whileEditing
        clearsOnBeginEditing = false
        leftViewMode = .always
        font = .normal(14)
        self.addDoneToolBar()
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        leftView = imageView
        placeholder = placeHolder
        addTarget(self, action: #selector(endEdit), for: .editingDidEnd)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func becomeFirstResponder() -> Bool {
        let ifTrue = super.becomeFirstResponder()
        setNeedsDisplay()
        return ifTrue
    }
    
    override func resignFirstResponder() -> Bool {
        let ifTrue = super.resignFirstResponder()
        setNeedsDisplay()
        return ifTrue
    }
    
    override var isHighlighted: Bool{
        didSet{
            setNeedsDisplay()
        }
    }
    
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 0, y: 0, width: 40, height: bounds.height)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: 40, y: 0, width: bounds.width - 40, height: bounds.height)
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: rect.origin.x, y: rect.height - 1 - linePadding))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - 1 - linePadding))
        if isHighlighted || isFirstResponder{
            //warning 谭宇翔删除了system颜色值
            UIColor.B1.setStroke()
        } else {
            UIColor(204, 204, 204).setStroke()
        }
        path.stroke()
    }
    
    func shake() {
        let x = layer.position.x
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = CGFloat(x + 3)
        animation.toValue = CGFloat(x - 3)
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.duration = 0.08
        layer.add(animation, forKey: nil)
        isHighlighted = true
    }
    
    func endEdit() {
        isHighlighted = false
    }
    
}
