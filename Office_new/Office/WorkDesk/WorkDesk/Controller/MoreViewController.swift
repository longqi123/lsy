//
//  MoreViewController.swift
//  Office
//
//  Created by roger on 2017/3/30.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import SwiftyJSON
import HandyJSON

private let SCREEN_WIDTH = UIScreen.main.bounds.width
private let SCREEN_HEIGHT = UIScreen.main.bounds.height

private let ChannelViewCellIdentifier = "ChannelViewCellIdentifier"

let itemW: CGFloat = (SCREEN_WIDTH - 100) * 0.25

class MoreViewController: BaseViewController {
    
    var switchoverCallback: ((_ selectedArr: [AppInfoModel]) -> ())?
    var selectedArr = [AppInfoModel]()
    var recommendArr = [WorkDeskModel]()
    
    var isEdite = true
    
    var indexPath: IndexPath?
    var targetIndexPath: IndexPath?
    
    
    init(a:[AppInfoModel], b:[WorkDeskModel]) {
        selectedArr = a
        recommendArr = b
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - 懒加载collectionView
    private lazy var collectionView: UICollectionView = {
        
        
        let clv = UICollectionView(frame: self.view.frame, collectionViewLayout: ChannelViewLayout())
        clv.backgroundColor = UIColor.B2
        clv.delegate = self
        clv.dataSource = self
        clv.register(WorkDeskCell.self, forCellWithReuseIdentifier: ChannelViewCellIdentifier)
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        clv.addGestureRecognizer(longPress)
        
        return clv
    }()
    
    private lazy var dragingItem: WorkDeskCell = {
        
        let cell = WorkDeskCell(frame: CGRect(x: 0, y: 0, width: itemW, height: itemW * 0.5))
        cell.isHidden = true
        return cell
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        let leftBtn: UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.plain, target: self, action: #selector(actionBack))
        let rightBtn: UIBarButtonItem = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editDone))
        rightBtn.tintColor = UIColor.white
        self.navigationItem.rightBarButtonItem = rightBtn
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "排序管理"
        view.addSubview(collectionView)
        collectionView.addSubview(dragingItem)
    }
    
    //MARK: - 长按动作
    func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        
        if !isEdite {
            
            isEdite = !isEdite
            collectionView.reloadData()
            return
        }
        let point = tap.location(in: collectionView)
        
        switch tap.state {
        case UIGestureRecognizerState.began:
            dragBegan(point: point)
        case UIGestureRecognizerState.changed:
            drageChanged(point: point)
        case UIGestureRecognizerState.ended:
            drageEnded(point: point)
        case UIGestureRecognizerState.cancelled:
            drageEnded(point: point)
        default: break
            
        }
        
    }
    
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! == 0 {return}
        
        let item = collectionView.cellForItem(at: indexPath!) as? WorkDeskCell
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        //        dragingItem.text = item!.text
        dragingItem.label.text = item?.label.text
        dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! == 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionView.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! == 0 || indexPath == targetIndexPath {return}
        // 更新数据
        let obj1 = recommendArr[(indexPath?.item)!]
        recommendArr.remove(at: (indexPath?.item)!)
        recommendArr.insert(obj1, at: (targetIndexPath?.item)!)
        //交换位置
        collectionView.moveItem(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        
        if indexPath == nil || (indexPath?.section)! == 0 {return}
        let endCell = collectionView.cellForItem(at: indexPath!)
        
        UIView.animate(withDuration: 0.25, animations: {
            
            self.dragingItem.transform = CGAffineTransform.identity
            self.dragingItem.center = (endCell?.center)!
            
        }, completion: {
            
            (finish) -> () in
            
            endCell?.isHidden = false
            self.dragingItem.isHidden = true
            self.indexPath = nil
            
        })
    }
    
    func editDone() {
        collectionView.reloadData()
        saveData()
    }
}

//MARK: - UICollectionViewDelegate 方法
extension MoreViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? selectedArr.count : recommendArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize{
        if indexPath?.section == 0 {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: view.frame.size.width, height: 5)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelViewCellIdentifier, for: indexPath) as! WorkDeskCell
        
        cell.label.text = indexPath.section == 0 ? (selectedArr[indexPath.item] as AppInfoModel).name! : (recommendArr[indexPath.item] as WorkDeskModel).yymc
        cell.appImage.image = indexPath.section == 0 ? (UIImage(named: (selectedArr[indexPath.item] as AppInfoModel).imageName!)) : (UIImage(named: "deng_ji_xin_xi"))
        return cell
    }
    
}


//MARK: - 自定义cell
class ChannelViewCell: UICollectionViewCell {
    
    var image: UIImageView!
    
    var edite = true {
        didSet {
            imageView.isHidden = !edite
        }
    }
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    private func setupUI() {
        
        contentView.backgroundColor = UIColor.white
        
        image = UIImageView()
        contentView.addSubview(image)
        image.image = UIImage(named: "deng_ji_xin_xi")
        image.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(-10)
            make.centerX.equalTo(contentView)
            make.width.height.equalTo(20)
        }
        
        contentView.addSubview(label)
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(contentView).offset(20)
            make.centerX.equalTo(contentView)
        }
        contentView.addSubview(imageView)
    }
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.normal(15)
        label.numberOfLines = 2
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    private lazy var imageView: UIImageView = {
        
        let image = UIImageView(frame: CGRect(x: 5, y: 5, width: 20, height: 20))
        image.image = UIImage(named: "close")
        image.isHidden = true
        return image
        
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - 自定义布局属性
class ChannelViewLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        super.prepare()
        
        let interval: CGFloat = 0
        let width = screenWidth/3
        scrollDirection = .vertical
        itemSize = CGSize(width: width - interval, height: width - interval)
        minimumInteritemSpacing = interval //纵间距
        minimumLineSpacing = interval //行间距
        sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
    }
}

extension MoreViewController {
    func saveData() {
        
        let para : [String: Any]
        
        var s = ""
        s += "<yypxbcRequestFrom>"
        s += "<yypxbcRequestGrid>"
        
        for (idx, item) in self.recommendArr.enumerated() {
            s += "<yypxbcRequestlb>"
            s += "<yygzuuid>\(item.yygzuuid)</yygzuuid>"
            s += "<yywz>\(idx)</yywz>"
            s += "</yypxbcRequestlb>"
        }
        s += "</yypxbcRequestGrid>"
        s += "</yypxbcRequestFrom>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYPXBC","s": s], sid: "D6666", extra: [:])
        showloading()
        Network.post(parameter: para, success: { (json) in
            print(json)
            let error = json["result"]["error"]
            if error["code"].stringValue == "000" {
                ProgressHUD.toast(message:error["reason"].stringValue)
            } else {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "getData"), object: nil)
                self.navigationController?.popViewController(animated: true)
                ProgressHUD.toast(message: "排序成功")
            }
            self.hideloading()
        }) { (error) in
            print(error)
            self.hideloading()
        }
        
    }
}
