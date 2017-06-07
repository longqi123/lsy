//
//  UIImageView+Core.swift
//  GXTax
//
//  Created by roger on 2017/3/23.
//  Copyright © 2017年 J HD. All rights reserved.
//

import Foundation

extension UIImageView{
    
    public func copyView() -> UIImageView{
        let imageView = UIImageView(frame: frame)
        imageView.image = image
        imageView.contentMode = contentMode
        return imageView
    }
}
