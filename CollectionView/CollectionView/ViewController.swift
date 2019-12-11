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
    var dataArr = [0,1,2,3,4,5,6,7,8,9]
    var dataArr1 = [10,11,12,13,14,15,16,17,18,19]
    var dataArr2 = [100,101,102,103,104,105,106,107,108,109]
    var dataArr3 = [1000,1001,1002,1003,1004,1005,1006,1007,1008,100]

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
        if let cell = cell as? CustomTableViewCell {
           cell.setup(delegate: self)
        }

        return cell
    }
    
    
}
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(100)
    }

}

extension ViewController: ComminicationBetweenCellAndTableView {
    func getItem(rowNum: Int, index: Int) -> Int {
        switch rowNum {
         case 0:
             return dataArr[index]
         case 1:
             return dataArr1[index]
         case 2:
             return dataArr2[index]
         case 3:
             return dataArr3[index]
         default:
             return 0
         }
    }
    
    func getDataArrCount(rowNum: Int) -> Int {
        switch rowNum {
        case 0:
            return dataArr.count
        case 1:
            return dataArr1.count
        case 2:
            return dataArr2.count
        case 3:
            return dataArr3.count
        default:
            return 0
        }
    }
    
    
    //moveItem內須實作 getRowNumByCollectionViewTagOrObject(),來區分是否cell有移動到別的列
    func moveItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, srcRowNum: Int, dstCollectionView: UICollectionView) {
        var dstRow: Int = 0
        let p = dstCollectionView.convert(dstCollectionView.center, to: self.mTableView)
        if let indexPath = mTableView.indexPathForRow(at: p) {
            dstRow = indexPath.row
        }
        print("ViewController  moveItem: srcRowNum: \(srcRowNum), dstRowNum: \(dstRow)")

        if dstRow == srcRowNum { //same row //do reorder
            print("同個row reorder, item is: \(item)  from 第\(sourceIndexPath.row)個 to 第\(destinationIndexPath.row)個")
            switch srcRowNum {
            case 0:
                dataArr.remove(at: sourceIndexPath.row)
                dataArr.insert(item, at: destinationIndexPath.row)
                break
            case 1:
                dataArr1.remove(at: sourceIndexPath.row)
                dataArr1.insert(item, at: destinationIndexPath.row)
                break
            case 2:
                dataArr2.remove(at: sourceIndexPath.row)
                dataArr2.insert(item, at: destinationIndexPath.row)
                break
            case 3:
                dataArr3.remove(at: sourceIndexPath.row)
                dataArr3.insert(item, at: destinationIndexPath.row)
                break
            default:
                break
            }
            print(dataArr)
        } else {
            print("不同個row reorder: 刪除tableVIew第\(srcRowNum)列的第\(sourceIndexPath.row)個")
            print("不同個row reorder: 新增tableVIew第\(dstRow)列的第\(destinationIndexPath.row)個")

            switch srcRowNum {
                case 0:
                    dataArr.remove(at: sourceIndexPath.row)
                    print("不同個row reorder: 刪除後,dataArr.count is: \(dataArr.count)")
                    break
                case 1:
                    dataArr1.remove(at: sourceIndexPath.row)
                    print("不同個row reorder: 刪除後,dataArr1.count is: \(dataArr1.count)")
                    break
                case 2:
                    dataArr2.remove(at: sourceIndexPath.row)
                    print("不同個row reorder: 刪除後,dataArr2.count is: \(dataArr2.count)")
                    break
                case 3:
                    dataArr3.remove(at: sourceIndexPath.row)
                    print("不同個row reorder: 刪除後,dataArr3.count is: \(dataArr3.count)")
                    break
                default:
                    break
                }
            switch dstRow {
                case 0:
                    dataArr.insert(item, at: destinationIndexPath.row)
                    print("不同個row reorder: 新增後,dataArr.count is: \(dataArr.count)")
                    break
                case 1:
                    dataArr1.insert(item, at: destinationIndexPath.row)
                    print("不同個row reorder: 新增後,dataArr1.count is: \(dataArr1.count)")
                    break
                case 2:
                    dataArr2.insert(item, at: destinationIndexPath.row)
                    print("不同個row reorder: 新增後,dataArr2.count is: \(dataArr2.count)")
                    break
                case 3:
                    dataArr3.insert(item, at: destinationIndexPath.row)
                    print("不同個row reorder: 新增後,dataArr3.count is: \(dataArr3.count)")
                    break
                default:
                    break
                }
        }
    }
    
    
    func reorderItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, rowNum: Int) {
        print("reorderItem: item is: \(item) , src row is: \(sourceIndexPath.row), dst row is: \(destinationIndexPath.row)")
        switch rowNum {
                 case 0:
                     dataArr.remove(at: sourceIndexPath.row)
                     dataArr.insert(item, at: destinationIndexPath.row)
                     break
                 case 1:
                     dataArr1.remove(at: sourceIndexPath.row)
                     dataArr1.insert(item, at: destinationIndexPath.row)
                     break
                 case 2:
                     dataArr2.remove(at: sourceIndexPath.row)
                     dataArr2.insert(item, at: destinationIndexPath.row)
                     break
                 case 3:
                     dataArr3.remove(at: sourceIndexPath.row)
                     dataArr3.insert(item, at: destinationIndexPath.row)
                     break
                 default:
                     break
                 }
    }
    //暫時不使用
    func isInTableView(v: UICollectionView, session: UIDropSession, dstIndexPath: IndexPath?) -> Bool {
        return true //TODO
    }
    
    
    func getCollectionViewByTableViewRow(rowNum: Int) -> UICollectionView? {
        let indexPath = IndexPath(row: rowNum, section: 0)
        if let cell = mTableView.cellForRow(at: indexPath), let customCell = cell as? CustomTableViewCell {
            return customCell.mCollectionView
        }
        return nil
    }
    
    func getCollectionViewName(v: UICollectionView) -> String {
        let p = v.convert(v.center, to: self.mTableView)

        if let indexPath = mTableView.indexPathForRow(at: p) {
            return "CollectionView\(indexPath.row)"
        }
        return "CollectionView_NULL"
    }
    
    func getTableViewRow(v: UICollectionView) -> Int {
        var dstRow: Int = 0
        let p = v.convert(v.center, to: self.mTableView)
        if let indexPath = mTableView.indexPathForRow(at: p) {
            dstRow = indexPath.row
        }
        return dstRow
    }
}


