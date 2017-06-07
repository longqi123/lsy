//
//  AppSquareViewController.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import HandyJSON
import SwiftyJSON
import CoreFramework
import SDWebImage

class AppSquareViewController: BaseViewController {
    
    // MARK: - Property
    //public
    //private
    let tableView = BaseTableView()
    fileprivate let cellId = "cell"
    fileprivate let headerId = "header"
    fileprivate let footerId = "footer"
    fileprivate var collectionView :UICollectionView!
    var serchTextFeild:UITextField!

    let followedApp : UILabel = {
        let lab = UILabel()
        lab.textColor = UIColor.T6
        lab.font = UIFont.H8
        lab.backgroundColor = UIColor.B1
        lab.layer.cornerRadius = 27.5
        lab.textAlignment = .center
        lab.text = "已关注\n应用"
        lab.clipsToBounds = true
        lab.numberOfLines = 2
        return lab
    }()

    var model = [[AppSquareModel]]()
    /// 搜索结果
    var searchModel = [AppSquareModel]()

    var yyflModel = [String]()

    // MARK: - Private
    // MARK: - Public
    // MARK: - Action
    // MARK: - Network
    // MARK: - Delegate
    // MARK: - Override
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        getData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item = UIBarButtonItem(image: UIImage(named: "mo_ren_tou_xiang"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        getData()
        creatUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
extension AppSquareViewController: UITextFieldDelegate{
   
    func creatUI() {
        title = "应用广场"
        
        let rightButton = UIBarButtonItem(title: " 搜索", style: UIBarButtonItemStyle.plain, target: self, action: #selector(search))
        navigationItem.rightBarButtonItem = rightButton
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: view.frame.width/3, height: 91)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(ApplicationSquareCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.register(ApplicationSquareHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(ApplicationSquareFooter.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerId)

        layout.minimumInteritemSpacing = 0 //纵间距
        layout.minimumLineSpacing = 0 //行间距
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        view.addSubview(followedApp)
        followedApp.snp.makeConstraints { (make) in
            make.height.equalTo(55)
            make.width.equalTo(55)
            make.right.equalTo(view).inset(12)
            make.bottom.equalTo(view).inset(20)
        }
        
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 15))
        backView.backgroundColor = UIColor.white
        let imageView = UIImageView(image: #imageLiteral(resourceName: "sou_suo_xiao"))
        imageView.frame = CGRect(x: 5, y: 0, width: 15, height: 15)
        imageView.contentMode = .scaleAspectFill
        backView.addSubview(imageView)
        serchTextFeild = UITextField()
        serchTextFeild.tintColor = UIColor.T5
        serchTextFeild.textColor = UIColor.T5
        serchTextFeild.font = UIFont.H8
        serchTextFeild.backgroundColor = UIColor.white
        serchTextFeild.layer.masksToBounds = true
        serchTextFeild.textAlignment = .left
        serchTextFeild.layer.cornerRadius = 3
        serchTextFeild.addDoneToolBar()
        serchTextFeild.frame = CGRect(x: 0, y: 0, width: WidthRatio*510, height: WidthRatio*60)
        serchTextFeild.leftView = backView
        serchTextFeild.placeholder = "请输入应用名称"
        serchTextFeild.delegate = self
        serchTextFeild.clearButtonMode = .whileEditing
        serchTextFeild.returnKeyType = .search
        serchTextFeild.leftViewMode = .unlessEditing
        self.navigationItem.titleView = serchTextFeild
        
        followedApp.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(toFollowedApps))
        followedApp.addGestureRecognizer(tap)
    }
}

extension AppSquareViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        let yyid = model[indexPath.section][indexPath.row].yyid
        let sfgz = model[indexPath.section][indexPath.row].sfgz
        let appDetailsVC = AppDetailsController(yyid: yyid, sfgz: sfgz)
        appDetailsVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(appDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var header: ApplicationSquareHeader!
        var footer: ApplicationSquareFooter!
        if kind == UICollectionElementKindSectionHeader {
            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ApplicationSquareHeader
            header.set(name: yyflModel[indexPath.section])
            header.tapClosure = { [weak self] in
                print(indexPath.section)
                let yyfl = self?.yyflModel[indexPath.section]
                let appListVC = AppListController(yyfl: yyfl!)
                appListVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(appListVC, animated: true)
                
            }
            return header
            
//            return ApplicationSquareHeader.initReuseView(collectionView: collectionView, elementKind: kind, identifier: headerId, indexPath: indexPath)

        } else {
            footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! ApplicationSquareFooter
            return footer

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ApplicationSquareCell
        cell.set(json: model[indexPath.section][indexPath.row])
        return cell
    }
}

extension AppSquareViewController: AppSquareCellDelegate{
    func attentionBtnClicked(){
        let alertController = UIAlertController(title: "应用未安装", message: "是否前往下载应用？", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "确定", style: .default)  {
            (alertAction) -> Void in
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(URL(string:"http://www.baidu.com")!, options: ["":""]) { (true) in}
            } else {
                UIApplication.shared.openURL(URL(string:"http://www.baidu.com")!)
            }

        })
        alertController.addAction(UIAlertAction(title: "取消", style: .cancel)  {
            (alertAction) -> Void in
//            return false
        })

        self.present(alertController, animated:true, completion: nil)
    }
    
    func toFollowedApps() {
        let appListVC = AppListController(isFollowedVC: true)
        appListVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(appListVC, animated: true)
    }
    
    func btnClicked(){
        let mineVC = MineViewController()
        mineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mineVC, animated: true)
    }
    
    func search() {
        serchTextFeild.resignFirstResponder()
        guard serchTextFeild.text?.isEmpty == false else {
            ProgressHUD.toast(message: "请输入搜索内容")
            return
        }
        getSearchData()
    }

}

extension AppSquareViewController {
    
    func getData() {
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm, let swjgdm = DataCenter.dlzhxxModel?.swjgDm else {
            return
        }
        
//        let dqys = 1
//        let myts = 50
//        let zts = ""
//        let yymc = ""
//        let gnxx = 1
//        let yyfl = 1002
//        let topts = 10
//        let yylb = ""
//        let jczxDm = 0202
        
        showloading()

        let para : [String: Any]

        var s = ""
        s += "<yyzsfwRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "<swjgDm>\(swjgdm)</swjgDm>"
        s += "<fengy>"
        s += "<FenyeVO>"
        s += "<dqys>1</dqys>"
        s += "<myts>50</myts>"
        s += "<zts></zts>"
        s += "</FenyeVO>"
        s += "</fengy>"
        s += "<yymc></yymc>"
        s += "<gnxx>1</gnxx>"
        s += "<yyfl></yyfl>"
        s += "<topts>3</topts>"
        s += "<jczxDm>0101</jczxDm>"
        s += "</yyzsfwRequestFrom>"
        
         para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYZS","s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            
            let yyfl = json["result"]["yyzsResponseForm"]["yyzsfwResponseForm"]["yyzsResponselb"].arrayResult
            self.model.removeAll()
            self.yyflModel.removeAll()
            for (_,item) in yyfl.enumerated() {
                if item["yyzsfwResponseGrid"] != JSON.null {
                    self.yyflModel.append(item["yyfl"].stringValue)
                    self.model.append(item["yyzsfwResponseGrid"]["yyzsfwResponselb"].arrayResult.map{AppSquareModel(json:$0)})
                }
            }
            
            self.collectionView.reloadData()
            self.hideloading()
            
        }) { (error) in
            print(error)
            self.hideloading()
        }
        
    }
    
    /// 搜索应用
    func getSearchData() {
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm, let swjgdm = DataCenter.dlzhxxModel?.swjgDm else {
            return
        }
        //        let dqys = 1
        //        let myts = 50
        //        let zts = ""
        //        let yymc = ""
        //        let gnxx = 1
        //        let yyfl = 1002
        //        let topts = 10
        //        let yylb = ""
        //        let jczxDm = 0202
        showloading()

        let para : [String: Any]

        var s = ""
        s += "<yyzsfwRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "<swjgDm>\(swjgdm)</swjgDm>"
        s += "<fengy>"
        s += "<FenyeVO>"
        s += "<dqys>1</dqys>"
        s += "<myts>50</myts>"
        s += "<zts></zts>"
        s += "</FenyeVO>"
        s += "</fengy>"
        s += "<yymc>\(serchTextFeild.text!)</yymc>"
        s += "<gnxx>\(2)</gnxx>"
        s += "<yyfl></yyfl>"
        s += "<topts></topts>"
        s += "<jczxDm>0101</jczxDm>"
        s += "</yyzsfwRequestFrom>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYZS","s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            print(json)
            
            if json["result"]["yyzsResponseForm"]["yyzsfwResponseForm"]["yyzsResponselb"]["yyzsfwResponseGrid"]["yyzsfwResponselb"].isEmpty {
                self.hideloading()
                ProgressHUD.toast(message: "无匹配内容")
            } else {
                self.searchModel = json["result"]["yyzsResponseForm"]["yyzsfwResponseForm"]["yyzsResponselb"]["yyzsfwResponseGrid"]["yyzsfwResponselb"].arrayResult.map{AppSquareModel(json:$0)}
                let appListVC = AppListController(yymc: self.serchTextFeild.text!, isSearchVC: true, model: self.searchModel)
                appListVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(appListVC, animated: true)
                self.serchTextFeild.text = ""
                self.hideloading()
            }
            
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
        
    }
}