//
//  PersonalDetailController.swift
//  Office
//
//  Created by 梁仕友 on 2017/5/16.
//  Copyright © 2017年 roger. All rights reserved.
//

import UIKit
import CoreFramework
import Messages
import MessageUI

class PersonalDetailController: UIViewController,MFMailComposeViewControllerDelegate {
    
    let tableView = BaseTableView(frame: .zero, style: .grouped)
    var footView:PersonaldetailView!
    var jsrydm = ""
    var model = PersonalDetailModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人详情"
        CreatUI()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getHeData()
    }
}
extension PersonalDetailController {
    func CreatUI(){
        footView = Bundle.main.loadNibNamed("PersonaldetailView", owner: self, options: nil)?.first as? PersonaldetailView
        view.addSubview(footView)
        footView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(view)
            make.height.equalTo(50)
        }

        view.addSubview(tableView)
        tableView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 51)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.bottom.equalTo(footView.snp.top)
        }
        
    }
    func getHeData(){
        self.showloading()
        let para: [String: Any]
        para = paraMaker(data: ["tranId":"SCDS.HLWGZPT.MH.RYXQ","s":"<RyxqRequestForm><rydm></rydm><jsrydm>\(jsrydm)</jsrydm></RyxqRequestForm>"], sid: "D6666", extra: [:])
        Network.post(parameter: para, success: { (json) in
            self.hideloading()
            let result = json["result"]["RyxqReturnVO"]["RyxqResponseGridlb"]
            self.model = PersonalDetailModel(json: result)
            self.tableView.reloadData()
        }) { (error) in
            self.hideloading()
            ProgressHUD.toast(message: error)
        }
    }
}

extension PersonalDetailController: UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 85
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        if indexPath.section == 0 {
            let cell = Bundle.main.loadNibNamed("Personaldetailcell", owner: self, options: nil)?.first as? Personaldetailcell
            cell?.nameLab.text = model.ryxm
            cell?.rightBtn.isHidden = true
            if model.ryxm.characters.count > 2 {
                cell?.photoLab.text = (model.ryxm as NSString).substring(with: NSMakeRange(model.ryxm.characters.count - 2, 2))
            }else{
                cell?.photoLab.text = model.ryxm
            }
            let colorNum = (jsrydm as NSString).substring(with:NSMakeRange(jsrydm.characters.count - 1, 1))
            let colorNumber = Int(colorNum)
            if colorNumber == 0 || colorNumber == 5 {
                cell?.photoLab.backgroundColor = UIColor.C5
            }else if colorNumber == 1 || colorNumber == 6{
                cell?.photoLab.backgroundColor = UIColor.C1
            }else if colorNumber == 2 || colorNumber == 7{
                cell?.photoLab.backgroundColor = UIColor.C2
            }else if colorNumber == 3 || colorNumber == 8{
                cell?.photoLab.backgroundColor = UIColor.C3
            }else if colorNumber == 4 || colorNumber == 9{
                cell?.photoLab.backgroundColor = UIColor.C4
            }
            cell?.selectionStyle = .none
            return cell!
        }else{
            let cell = Bundle.main.loadNibNamed("Personaldetailcell2", owner: self, options: nil)?.first as? Personaldetailcell2
            if indexPath.row == 0 {
                cell?.nameLab.text = "姓名"
                cell?.contentLab.text = model.ryxm
                cell?.leftBtn.isHidden = true
                cell?.rightBtn.setImage(#imageLiteral(resourceName: "xia_zai_bao_cun_ben_di"), for: .normal)
                cell?.rightBtn.isUserInteractionEnabled = false
                cell?.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
            }else if indexPath.row == 1 {
                cell?.nameLab.text = "电话"
                cell?.contentLab.text = model.sj
                cell?.leftBtn.setImage(#imageLiteral(resourceName: "dian_hua"), for: .normal)
                cell?.rightBtn.setImage(#imageLiteral(resourceName: "xin_xi"), for: .normal)
                cell?.doneBlock = { btntag in
                    if btntag == 100 {//打电话
                        let urlString = "tel://\(self.model.sj)"
                        if let url = URL(string: urlString) {
                            //根据iOS系统版本，分别处理
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],
                                                          completionHandler: {
                                                            (success) in
                                })
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }

                    }else{//发短信
                        let urlString = "sms://\(self.model.sj)"
                        if let url = URL(string: urlString) {
                            //根据iOS系统版本，分别处理
                            if #available(iOS 10, *) {
                                UIApplication.shared.open(url, options: [:],
                                                          completionHandler: {
                                                            (success) in
                                })
                            } else {
                                UIApplication.shared.openURL(url)
                            }
                        }
                    }
                }
            }else if indexPath.row == 2 {
                cell?.nameLab.text = "座机"
                cell?.contentLab.text = model.jtdh
                cell?.leftBtn.isHidden = true
                cell?.rightBtn.setImage(#imageLiteral(resourceName: "dian_hua"), for: .normal)
                cell?.rightBtn.isUserInteractionEnabled = false
                
            }else if indexPath.row == 3 {
                cell?.nameLab.text = "邮箱"
                cell?.contentLab.text = model.dzyj
                cell?.leftBtn.isHidden = true
                cell?.rightBtn.setImage(#imageLiteral(resourceName: "you_jian"), for: .normal)
                cell?.rightBtn.isUserInteractionEnabled = false
                
            }else if indexPath.row == 4 {
                let cell2 = Bundle.main.loadNibNamed("EditpersonalinformationCell", owner: self, options: nil)?.first as? EditpersonalinformationCell
                cell2?.title.text = "部门"
                cell2?.content.text = model.csmc
                cell2?.content.isUserInteractionEnabled = false
                cell2?.accessoryType = .disclosureIndicator
                cell?.selectionStyle = .none
                return cell2!
                
            }else if indexPath.row == 5 {
                cell?.nameLab.text = "职务"
                cell?.contentLab.text = model.levelname
                cell?.leftBtn.isHidden = true
                cell?.rightBtn.isHidden = true
                
            }else if indexPath.row == 6 {
                cell?.nameLab.text = "QQ"
                cell?.contentLab.text = model.qqzh
                cell?.leftBtn.isHidden = true
                cell?.rightBtn.isHidden = true
                
            }else if indexPath.row == 7 {
                cell?.nameLab.text = "微信"
                cell?.contentLab.text = model.wxzh
                cell?.leftBtn.isHidden = true
                cell?.rightBtn.isHidden = true
            }
            cell?.selectionStyle = .none
            return cell!
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10
        }
        return 0.001
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
         
        }else if indexPath.section == 1 {
            if indexPath.row == 0 {
                
            }else if indexPath.row == 1{
            
            }else if indexPath.row == 2{//打电话座机
                let urlString = "tel://13980840276"
                if let url = URL(string: urlString) {
                    //根据iOS系统版本，分别处理
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url, options: [:],
                                                  completionHandler: {
                                                    (success) in
                        })
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }else if indexPath.row == 3{//发邮件
                // 判断能否发送邮件
                guard MFMailComposeViewController.canSendMail() else {
                    print("不能发送邮件")
                    return
                }
                let mailVC = MFMailComposeViewController()
                mailVC.mailComposeDelegate = self // 代理
                mailVC.setSubject("阳君") // 主题
                mailVC.setToRecipients(["937447974@qq.com"]) // 收件人
                mailVC.setCcRecipients(["CcRecipients@qq.com"]) // 抄送
                mailVC.setBccRecipients(["bccRecipients@qq.com"]) // 密送
                mailVC.setMessageBody("相关内容", isHTML: false) // 内容，允许使用html内容
                if let image = UIImage(named: "qq") {
                    if let data = UIImagePNGRepresentation(image) {
                        // 添加文件
                        mailVC.addAttachmentData(data, mimeType: "image/png", fileName: "qq")
                    }
                }
                self.present(mailVC, animated: true, completion: nil)
            }else if indexPath.row == 4{//部门
                
            }
        }
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if result == .cancelled {
            print("邮件取消")
        }else if result == .failed {
            print("邮件发送失败")
        }else if result == .sent {
            print("邮件发送成功")
        }else if result == .saved {
            print("邮件存为草稿")
        }
        self.dismiss(animated: true, completion: nil)
    }
}