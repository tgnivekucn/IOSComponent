//
//  ViewController.swift
//  CollectionView
//
//  Created by Kuangyu Nien on 2019/12/6.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import UIKit
class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var test: UILabel!
}
class ViewController: UIViewController {
    @IBOutlet weak var mTableView: UITableView!
    @IBOutlet weak var mCollectionView: UICollectionView!
    var dataArr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    let tableViewTotalRow = 4
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //init tableView setting
        mTableView.dataSource = self
        mTableView.delegate = self
    }
    
 
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewTotalRow
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}

extension ViewController: ComminicationBetweenCellAndTableView {
    
    //moveItem內須實作 getRowNumByCollectionViewTagOrObject(),來區分是否cell有移動到別的列
    func moveItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, srcRowNum: Int) {
                
                /*
                #if DEBUG
                //先移除原本的source item,再判斷目前在哪個collectionView,並把資料移動到目的列
                if let sourceIndexPath = item.sourceIndexPath {
                    self.dataArr.remove(at: sourceIndexPath.row)
                }
                if collectionView === self.collectionView2  { //不同列,把資料複製到目的列
                    self.items2.insert(item.dragItem.localObject as! String, at: indexPath.row)
                } else  { //同列,把資料移到指定的位置
           
                    self.dataArr.insert(item.dragItem.localObject as! Int, at: indexPath.row)
                }
                #endif
                */
    }
    
    func isInTableView(v: UICollectionView, session: UIDropSession, dstIndexPath: IndexPath?) -> Bool {
        <#code#>
    }
    
    func isInSameCollectionView(v: UICollectionView, session: UIDropSession, dstIndexPath: IndexPath?) -> Bool {
        <#code#>
    }
    
    
}


