//
//  EditViewController.swift
//  Office
//
//  Created by GA GA on 01/06/2017.
//  Copyright © 2017 roger. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {

    fileprivate let cellId = "cell"
    fileprivate let headerId = "header"
    var collectionView: UICollectionView!
    
    var isEdit = false
    var indexPath: IndexPath?
    var targetIndexPath: IndexPath?

    lazy var dragingItem: WorkDeskCell = {
        let itemWidth: CGFloat = (UIScreen.main.bounds.size.width - 100) * 0.25
        let cell = WorkDeskCell(frame: CGRect(x: 0, y: 0, width: itemWidth, height: itemWidth * 0.5))
        cell.backgroundColor = .red
        cell.isHidden = true
        return cell
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        creatUI()

    }


}

extension EditViewController {
    func creatUI() {
        title = "排序管理"
        let rightButton = UIBarButtonItem(title: "完成", style: UIBarButtonItemStyle.plain, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = rightButton
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize.init(width: view.frame.width/3, height: 91)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(WorkDeskCell.self, forCellWithReuseIdentifier: cellId)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGesture(_:)))
        collectionView.addGestureRecognizer(longPress)
    }
}

extension EditViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func longPressGesture(_ tap: UILongPressGestureRecognizer) {
        if !isEdit {
            isEdit = !isEdit
            collectionView.reloadData()
            return
        }
        
        let point = tap.location(in: collectionView)
        switch tap.state {
        case .began:
            dragBegan(point: point)
        case .changed:
            drageChanged(point: point)
        case .ended:
            drageEnded(point: point)
        case .cancelled:
            drageEnded(point: point)
        default:
            break
        }
    }
    
    
    //MARK: - 长按开始
    private func dragBegan(point: CGPoint) {
        indexPath = collectionView.indexPathForItem(at: point)
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0
        {return}
        
        let item = collectionView.cellForItem(at: indexPath!) as? WorkDeskCell
        item?.isHidden = true
        dragingItem.isHidden = false
        dragingItem.frame = (item?.frame)!
        dragingItem.label.text = item?.label.text
        dragingItem.appImage.image = item?.appImage.image
        dragingItem.backgroundColor = UIColor.red
        dragingItem.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }
    //MARK: - 长按过程
    private func drageChanged(point: CGPoint) {
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
        dragingItem.center = point
        targetIndexPath = collectionView.indexPathForItem(at: point)
        if targetIndexPath == nil || (targetIndexPath?.section)! > 0 || indexPath == targetIndexPath || targetIndexPath?.item == 0 {return}
        // 更新数据
//        let obj = selectedArr[indexPath!.item]
//        selectedArr.remove(at: indexPath!.row)
//        selectedArr.insert(obj, at: targetIndexPath!.item)
        //交换位置
        collectionView.moveItem(at: indexPath!, to: targetIndexPath!)
        indexPath = targetIndexPath
    }
    
    //MARK: - 长按结束
    private func drageEnded(point: CGPoint) {
        
        if indexPath == nil || (indexPath?.section)! > 0 || indexPath?.item == 0 {return}
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

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 0.001)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize{
        return CGSize(width: view.frame.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)

    }
    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        var header: ApplicationSquareHeader!
//        var footer: ApplicationSquareFooter!
//        if kind == UICollectionElementKindSectionHeader {
//            header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! ApplicationSquareHeader
//            header.set(name: yyflModel[indexPath.section])
//            header.tapClosure = { [weak self] in
//                print(indexPath.section)
//                let yyfl = self?.yyflModel[indexPath.section]
//                let appListVC = AppListController(yyfl: yyfl!)
//                appListVC.hidesBottomBarWhenPushed = true
//                self?.navigationController?.pushViewController(appListVC, animated: true)
//                
//            }
//            return header
//            
//            //            return ApplicationSquareHeader.initReuseView(collectionView: collectionView, elementKind: kind, identifier: headerId, indexPath: indexPath)
//            
//        } else {
//            footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerId, for: indexPath) as! ApplicationSquareFooter
//            return footer
//            
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! WorkDeskCell
        cell.label.text = String(indexPath.row)
        return cell
    }
}



extension EditViewController {
    func done() {
        
    }
}
