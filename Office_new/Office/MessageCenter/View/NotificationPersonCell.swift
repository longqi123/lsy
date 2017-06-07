//
//  NotificationPersonCell.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/31.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework

@objc class NotificationPersonCell: UITableViewCell,UICollectionViewDataSource,UICollectionViewDelegate {
    var personArr:[TxlModel1] = []
    var mycolectionView:UICollectionView!
    var index:IndexPath!
    typealias personClick = (_ dataArr:[TxlModel1]) -> Void
    typealias deleteClick = (_ dataArr:[TxlModel1]) -> Void

    var personClick: personClick?
    var deleteClick: deleteClick?
    var isHiddenView: Bool = false
    
    typealias personClick_oc = (_ dataArr:[TxlModel1_oc]) -> Void
    typealias deleteClick_oc = (_ dataArr:[TxlModel1_oc]) -> Void
    
    var personClick_oc: personClick_oc?
    var deleteClick_oc: deleteClick_oc?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.CreatUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setViewHidden() {
        isHiddenView = true
    }
    
    public func changeClass(array: [TxlModel1_oc]) {
        //oc类调用
        var dataSource = [TxlModel1]()
        for model in array {
            var data = TxlModel1()
            data.swjgdm = model.swjgdm;
            data.jsrydm = model.jsrydm;
            data.swjgmc = model.swjgmc;
            data.levelname = model.levelname;
            data.ryxm = model.ryxm;
            data.csmc = model.csmc;
            data.dutyname = model.dutyname;
            data.rydm = model.rydm;
            data.csdm = model.csdm;
            dataSource.append(data)
        }
        self.personArr = dataSource;
    }
    
    func CreatUI(){
        let myFlowLayout = UICollectionViewFlowLayout()
        myFlowLayout.minimumInteritemSpacing = 0
        myFlowLayout.minimumLineSpacing = 0
        myFlowLayout.scrollDirection = .vertical
        myFlowLayout.itemSize = CGSize(width: (screenWidth - 24)/6, height: 60)
        mycolectionView = UICollectionView(frame: .zero, collectionViewLayout: myFlowLayout)
        contentView.addSubview(mycolectionView)
        mycolectionView.snp.makeConstraints { (make) in
            make.left.equalTo(contentView).inset(12)
            make.right.equalTo(contentView).inset(12)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        mycolectionView.dataSource = self
        mycolectionView.delegate = self
        mycolectionView.backgroundColor = UIColor.white
        mycolectionView.register(NotificationPersonCell2.self, forCellWithReuseIdentifier: "NotificationPersonCell2ID")
        mycolectionView.register(NotificationPersonCell3.self, forCellWithReuseIdentifier: "NotificationPersonCell3ID")
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.personArr.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.personArr.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationPersonCell3ID", for: indexPath) as! NotificationPersonCell3
            if isHiddenView {
                cell.image.isHidden = true
            }
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationPersonCell2ID", for: indexPath) as! NotificationPersonCell2
            
            if isHiddenView {
                cell.image.isHidden = true
            }
            if self.personArr[indexPath.row].ryxm.characters.count > 2 {
                cell.nameLab.text = (self.personArr[indexPath.row].ryxm as NSString).substring(with: NSMakeRange(self.personArr[indexPath.row].ryxm.characters.count - 2, 2))
            }else{
                cell.nameLab.text = self.personArr[indexPath.row].ryxm
            }
            let colorNum = (self.personArr[indexPath.row].jsrydm as NSString).substring(with: NSMakeRange(self.personArr[indexPath.row].jsrydm.characters.count - 1, 1))
            let colorNumber = Int(colorNum)
            if colorNumber == 0 || colorNumber == 5 {
                cell.nameLab.backgroundColor = UIColor.C5
            }else if colorNumber == 1 || colorNumber == 6{
                cell.nameLab.backgroundColor = UIColor.C1
            }else if colorNumber == 2 || colorNumber == 7{
                cell.nameLab.backgroundColor = UIColor.C2
            }else if colorNumber == 3 || colorNumber == 8{
                cell.nameLab.backgroundColor = UIColor.C3
            }else if colorNumber == 4 || colorNumber == 9{
                cell.nameLab.backgroundColor = UIColor.C4
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == self.personArr.count {//跳转通讯录去添加
            if self.personClick != nil {
                self.personClick?(personArr)
            }
            
            if self.personClick_oc != nil {
                //oc类调用
                var array = [TxlModel1_oc]()
                for model in personArr {
                    let data = TxlModel1_oc()
                    data.swjgdm = model.swjgdm;
                    data.jsrydm = model.jsrydm;
                    data.swjgmc = model.swjgmc;
                    data.levelname = model.levelname;
                    data.ryxm = model.ryxm;
                    data.csmc = model.csmc;
                    data.dutyname = model.dutyname;
                    data.rydm = model.rydm;
                    data.csdm = model.csdm;
                    array.append(data)
                }
                self.personClick_oc?(array)
            }
            
        }else{//删除某一个
            self.personArr.remove(at: indexPath.row)
            
            if self.deleteClick != nil {
                self.deleteClick?(personArr)
            }
            
            if self.deleteClick_oc != nil {
                //oc类调用
                var array = [TxlModel1_oc]()
                for model in personArr {
                    let data = TxlModel1_oc()
                    data.swjgdm = model.swjgdm;
                    data.jsrydm = model.jsrydm;
                    data.swjgmc = model.swjgmc;
                    data.levelname = model.levelname;
                    data.ryxm = model.ryxm;
                    data.csmc = model.csmc;
                    data.dutyname = model.dutyname;
                    data.rydm = model.rydm;
                    data.csdm = model.csdm;
                    array.append(data)
                }
                self.deleteClick_oc?(array)
            }
            
            self.reload()
        }
    }
    func reload() {
        self.mycolectionView.reloadData()
        self.index = IndexPath(item: self.personArr.count, section: 0)
        self.mycolectionView.scrollToItem(at: self.index, at: .bottom, animated: true)
    }
}
