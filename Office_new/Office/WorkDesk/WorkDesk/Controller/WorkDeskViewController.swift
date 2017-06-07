//
//  WorkDeskViewController.swift
//  Office
//
//  Created by roger on 2017/3/29.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import ImageSlideshow
import SDWebImage
import HandyJSON
import SwiftyJSON

class WorkDeskViewController: BaseViewController{
    
    // MARK: - Property
    //public
    fileprivate let scrollView = UIScrollView()
    fileprivate let flashView = UIView()
    fileprivate var collectionView :UICollectionView!
    //private
    fileprivate let Identifier = "cell"
    fileprivate var selectedArr = [AppInfoModel]()
    var slideshow =  ImageSlideshow()
    let titleLabel = UILabel()
    var imagesModel: WorkDeskImageModel?
    var sdWebImageSource = [SDWebImageSource]()
    var appsModel = [WorkDeskModel]()
    var indexPath: IndexPath?

    var data = Data()
    
    // MARK: - Override
    init() {
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        getImageData()
        getData()
        creatData()
        creatUI()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "getData"), object: nil, queue: nil) { (notificate) in
            self.getData()
        }
    }
}

// MARK: - Private
extension WorkDeskViewController{
    fileprivate func creatUI() {
        title = "工作"
        let item = UIBarButtonItem(image: UIImage(named: "mo_ren_tou_xiang"), style: UIBarButtonItemStyle.plain, target: self, action: #selector(btnClicked))
        self.navigationItem.leftBarButtonItem = item
        
        let rightButton = UIBarButtonItem(title: "排序管理", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editApps))
        navigationItem.rightBarButtonItem = rightButton
        
        view.addSubview(scrollView)
        scrollView.backgroundColor = UIColor.clear
        scrollView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(view)
        }
        
        view.addSubview(flashView)
        flashView.backgroundColor = UIColor.red
        flashView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view)
            make.height.equalTo(214)
        }
        
        flashView.addSubview(slideshow)
        slideshow.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(flashView)
        }
        slideshow.backgroundColor = UIColor.white
        slideshow.slideshowInterval = 2.0
        slideshow.pageControlPosition = PageControlPosition.insideScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.B1
        slideshow.pageControl.pageIndicatorTintColor = .white
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideshow.addSubview(titleLabel)
        titleLabel.textColor = UIColor.T6
        titleLabel.font = UIFont.H5
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(slideshow)
            make.height.equalTo(slideshow.pageControl)
            make.right.equalTo(slideshow.pageControl.snp.left)
            make.bottom.equalTo(slideshow)
        }
        slideshow.currentPageChanged = { page in
            self.titleLabel.text = "   " + (self.imagesModel?.titles[self.slideshow.currentPage])!
            
        }
        //        slideshow.setImageInputs(sdWebImageSource)
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(gesture:)))
        slideshow.addGestureRecognizer(recognizer)
        
        let layout = UICollectionViewFlowLayout()
        let interval: CGFloat = 0.5
        let width = screenWidth/3
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: width - interval, height: width - interval)
        layout.minimumInteritemSpacing = interval //纵间距
        layout.minimumLineSpacing = interval //行间距
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 0)
        
        collectionView = UICollectionView(frame: screenRect, collectionViewLayout: layout)
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.clear
        collectionView?.register(WorkDeskCell.self, forCellWithReuseIdentifier: Identifier)
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(flashView.snp.bottom)
        }
    }
    
    fileprivate func creatData() {
        let data = AppInfoModel()
        data.name = "视频会议"
        data.url = "test://"
        data.imageName = "shi_pin_hui_yi"
        let data2 = AppInfoModel()
        data2.name = "即时通信"
        data2.url = "test://"
        data2.imageName = "ji_shi_tong_xun"
        let data3 = AppInfoModel()
        data3.name = "群发助手"
        data3.url = "test://"
        data3.imageName = "qun_fa_zhu_shou"
        
        selectedArr.append(data)
        selectedArr.append(data2)
        selectedArr.append(data3)
        
    }
    
    
}

extension WorkDeskViewController {
    
    /// 编辑应用
    func editApps() {
        let channelVC = MoreViewController(a: selectedArr, b: appsModel)
        channelVC.hidesBottomBarWhenPushed = true
        
        navigationController?.pushViewController(channelVC, animated: true)
    }
    
    /// 我的
    func btnClicked(){
        let mineVC = MineViewController()
        mineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mineVC, animated: true)
    }
    
    /// 点击滚动栏图片
    ///
    /// - Parameter gesture:
    func didTap(gesture: UITapGestureRecognizer) {
        let url = URL(string: (imagesModel?.contentUrl[slideshow.currentPage])!)
        let web = WebViewController(url: url!, titleStr: (imagesModel?.titles[slideshow.currentPage])!)
        web.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(web, animated: true)
//        let fullScreenController = slideshow.presentFullScreenController(from: self)
        
    }
}

extension WorkDeskViewController: UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return selectedArr.count
        } else {
            return appsModel.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 5)
    }
    
//    func collectionView(_ collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout,referenceSizeForHeaderInSection section: Int) -> CGSize{
//        return CGSize(width: view.frame.size.width, height: 214)
//    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifier, for: indexPath) as! WorkDeskCell
        if indexPath.section == 0 {
            cell.label.text = selectedArr[indexPath.row].name
            cell.appImage.image = UIImage(named: selectedArr[indexPath.row].imageName!)
        } else {
            cell.label.text = appsModel[indexPath.row].yymc
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                
                let vc = CSSEnterRoomViewController()
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true)
                
/*
                //视频会议
                let appKey2 = CSSDemoConfig.shared().appKey
                let cerName2 = CSSDemoConfig.shared().cerName
                NIMSDK.shared().register(withAppID: appKey2!, cerName: cerName2)
                NIMCustomObject.registerCustomDecoder(CSSCustomAttachmentDecoder())
                CSKit.shared().provider = CSSDataManager.sharedInstance()
                CSSLogManager.shared().start()
                
                self.showloading()
        
                let data = CSSRegisterData()
                data.account = "rogertan30"
                data.nickname = DataCenter.ryxqModel?.ryxm
                data.token = "2fdb906d7a1fd9681c5f69c2206213e1"
                //注册
                
//                CSSDemoService.shared().registerUser(data, completion: {(error, errorMsg) in
//                    //注册成功
//                    if error == nil {
//                        login()
//                        self.hideloading()
//                    }
//                        //注册失败，或者已经注册用户
//                    else{
//                        if errorMsg! == "帐号已注册" {
//                            //登录会议
//                            login()
//                        }else{
//                            ProgressHUD.toast(message: errorMsg!)
//                            self.hideloading()
//                        }
//                    }
//                })
//                
//                func login(){
                    NIMSDK.shared().loginManager.login("rogertan30", token:   "2fdb906d7a1fd9681c5f69c2206213e1", completion: { (error) in
                        
                        if error == nil {
                            let sdkData = NTESLoginData()
                            sdkData.account = "rogertan30"
                            sdkData.token = "2fdb906d7a1fd9681c5f69c2206213e1"
                            CSSLoginManager.shared().currentNTESLoginData = sdkData
                            CSSServiceManager.shared().start()
                            
                            let vc = CSSEnterRoomViewController()
                            vc.hidesBottomBarWhenPushed = true;
                            self.navigationController?.pushViewController(vc, animated: true)
                        }else{
                            print(error)
                        }
                        self.hideloading()
                        
                    })
//                }
  
 */
                
            } else if indexPath.row == 1 {
                //即时通讯
                let vc = NTESSessionListViewController()
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true)
            } else if indexPath.row == 2 {
                //群发助手
                let vc = SendAssistantViewController.init(nibName: nil, bundle: nil)
                vc.hidesBottomBarWhenPushed = true;
                self.navigationController?.pushViewController(vc, animated: true)
            }  else {
                openURL(URLString: (selectedArr[indexPath.row] as AppInfoModel).url!)
            }
        }else if indexPath.section == 1{
           if indexPath.row == 0{
                let vc = AnnouncementController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
           }
           else if indexPath.row == 1{
            
                let vc = SurveyViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func openURL(URLString : String) {
        guard let url = URL(string: URLString) else {return}
        guard UIApplication.shared.canOpenURL(url) else {return}
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: ["":""]) { (true) in}
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}

extension WorkDeskViewController {
    
    /// 广告栏滚动图片
    func getImageData() {
        Network.post(parameter: ["sid": "D1068"], success: { (json) in
            let flag = json["result"]["flag"].stringValue
            if flag == "1" {
                let result = json["result"]["list"]
                self.imagesModel = WorkDeskImageModel(json: result)
//                let user = UserDefaults.standard
//                user.set(self.imagesModel, forKey: "slideImages")
//                user.synchronize()
                self.addImages()
            }
        }) { (error) in
            print(error)
            ProgressHUD.toast(message: error)
        }
        
    }
    
    func addImages() {
        for item in (imagesModel?.images)! {
            sdWebImageSource.append(SDWebImageSource(urlString:item)!)
        }
        slideshow.setImageInputs([ImageSource(image: #imageLiteral(resourceName: "login-bg"))])
        slideshow.setImageInputs(sdWebImageSource)
        self.titleLabel.text = self.imagesModel?.titles[slideshow.currentPage]
        slideshow.pageControl.backgroundColor = UIColor(white: 0, alpha: 0.5)
        titleLabel.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
    }
    
    func getData() {
        
        guard let zhxx = DataCenter.dlzhxxModel?.dlzhDm else {
            return
        }
        let para: [String: Any]
        var s = ""
        s += "<yyxxhqRequestFrom>"
        s += "<zhxx>\(zhxx)</zhxx>"
        s += "</yyxxhqRequestFrom>"
        
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.YYXXHQ", "s": s], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            let result = json["result"]["yyxxhqResponseForm"]["yyxxhqResponseGrid"]["yyxxhqResponselb"]
            if result.count > 0 {
                if result.array != nil {
                    self.appsModel = result.arrayValue.map(WorkDeskModel.init)
                    self.appsModel.sort()
                    print(self.appsModel)
                } else {
                    self.appsModel = [JSONDeserializer<WorkDeskModel>.deserializeFrom(json:result.rawString())!]
                    self.appsModel.sort()
                }
            }
            
            self.collectionView.reloadData()
            self.hideloading()
        }) { (error) in
            print(error)
            self.hideloading()
        }
    }
    
    
    
}
