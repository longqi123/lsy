//
//  PhotoAlbum.swift
//  GXTax
//
//  Created by 壹零贰肆 壹零贰肆 on 17/1/10.
//  Copyright © 2017年 J HD. All rights reserved.
//

import UIKit

public class PhotoAlbum: NSObject {
  public static let share = PhotoAlbum()
  public typealias ImageBlcok = (_ image: UIImage?) -> Void
  var callBack: ImageBlcok?
  lazy var imagePicker: UIImagePickerController = { [weak self] in
    let vc = UIImagePickerController()
    vc.delegate = self
    vc.allowsEditing = true
    vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
    return vc
  }()
  public static func show(callback:@escaping ImageBlcok) {
    UIApplication.shared.keyWindow?.rootViewController?.present(share.imagePicker, animated: true, completion: nil)
    share.callBack = callback
  }
  
  public static func screenSnapshot() -> UIImage? {
    
    guard let window = UIApplication.shared.keyWindow else { return nil }
    
    // 用下面这行而不是UIGraphicsBeginImageContext()，因为前者支持Retina
    UIGraphicsBeginImageContextWithOptions(window.bounds.size, false, 0.0)
    
    window.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    UIImageWriteToSavedPhotosAlbum(image!, self, nil, nil)
    
    return image
  }
}

extension PhotoAlbum: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    let image = info["UIImagePickerControllerEditedImage"] as! UIImage
    callBack!(image)
    picker.dismiss(animated: true, completion: nil)
  }
  
  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
}
