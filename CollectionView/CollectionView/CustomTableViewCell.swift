//
//  CustomTableViewCell.swift
//  CollectionView
//
//  Created by Kuangyu Nien on 2019/12/9.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import UIKit
protocol ComminicationBetweenCellAndTableView: class {
    //moveItem內須實作 getRowNumByCollectionViewTagOrObject(),來區分是否cell有移動到別的列
    func moveItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, srcRowNum: Int, dstCollectionView: UICollectionView)
    
    
    func reorderItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath, rowNum: Int)
    func isInTableView(v: UICollectionView, session: UIDropSession, dstIndexPath: IndexPath?) -> Bool     //暫時不使用
    func getItem(rowNum: Int, index: Int) -> Int //get item by tableView row num & index
    func getDataArrCount(rowNum: Int) -> Int
    func getCollectionViewByTableViewRow(rowNum: Int) -> UICollectionView?
    func getCollectionViewName(v: UICollectionView) -> String

}
class EmbeddedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mLabel: UILabel!
}
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    
//    var dataArr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    weak var delegate: ComminicationBetweenCellAndTableView? = nil
    var rowNum = 0 //for identifying the item is in the same collectionView or not after drag/drop
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.dragDelegate = self
        mCollectionView.dropDelegate = self
        
        
        //Set collectionView to one row
        let collectionViewFlowControl = UICollectionViewFlowLayout()
        collectionViewFlowControl.scrollDirection = UICollectionView.ScrollDirection.horizontal
        mCollectionView.setCollectionViewLayout(collectionViewFlowControl, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setup(delegate: ComminicationBetweenCellAndTableView, rowNum: Int) {
        self.delegate = delegate
        self.rowNum = rowNum
    }
    
  
    
    
    
    //實作copyItems
    //1) 取出要被複製的item from 傳入的參數coordinator
    //2) 取出destinationIndexPath (傳入的參數)
    //3) 判斷dst collectionView是否為目前的collectionView
    //   A) 是相同的collectionView:  對目前collectionView的資料結構進行insert item.dragItem.localObject at dstIndexPath.row.  (p.s 同reorder操作)
    //   B) 非相同的collectionView:  對另一個collectionView的資料結構進行insert item.dragItem.localObject at dstIndexPath.row.  (p.s 同reorder操作)
    //4) indexPaths.append(indexPath). //把所有要新增的element的indexPath存入array
    //5) collectionView.insertItems(at: indexPaths) //collection把所有新增element的indexPath藉由insertItems API來通知collectionView根據
    //    已更改後的資料結構來更新UI
    private func copyItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView) {
        //note: 參數的collectionView是dst collectionView
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated() {
//                if let sourceIndexPath = item.sourceIndexPath {
//                    print("\(delegate?.getCollectionViewName(v: collectionView) ?? "")  copyItem: sourceIndexPath.section is: \(sourceIndexPath.section), row is: \(sourceIndexPath.row)")
//                }
                
                let indexPath = IndexPath(row: destinationIndexPath.row, section: destinationIndexPath.section)

                let tmp: (data: Int,indexPath: IndexPath) = item.dragItem.localObject as! (data: Int, indexPath: IndexPath)
                let srcindexPath = IndexPath(row: tmp.indexPath.row, section: tmp.indexPath.section)

                print("\(delegate?.getCollectionViewName(v: collectionView) ?? "")!  copyItem: destinationIndexPath.section is: \(destinationIndexPath.section), row is: \(destinationIndexPath.row), index is: \(index)")
                print("\(delegate?.getCollectionViewName(v: collectionView) ?? "")  copyItem: sourceIndexPath.section is: \(srcindexPath.section), row is: \(srcindexPath.row)")
                
                delegate?.moveItem(item: tmp.data , sourceIndexPath: srcindexPath, destinationIndexPath: destinationIndexPath, srcRowNum: rowNum, dstCollectionView: collectionView)
                
                
                //TODO
                //在這裡要區分deleteItems at sourceIndexPath的collectionView是srcCollectionView或是dstCollecctionView
                //note: 理論上應該要在DragDelegate的protocol function中,讓srcCollectionView去刪除sourceIndexPath
                //      然後在dstCollectionView中去新增destinationIndexPath
                if let srcCollectionView = delegate?.getCollectionViewByTableViewRow(rowNum: rowNum) {
                    print("\(delegate?.getCollectionViewName(v: collectionView) ?? "")  copyItem:  srcCollectionView is: \(delegate?.getCollectionViewName(v: srcCollectionView) ?? "")")
                    srcCollectionView.deleteItems(at: [srcindexPath])
                }
                
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    
    
}


extension CustomTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let dataArrCount: Int = delegate?.getDataArrCount(rowNum: rowNum) ?? 0
        print("\(delegate?.getCollectionViewName(v: collectionView) ?? "")  numberOfItems is: \(dataArrCount)")
        return dataArrCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell1", for: indexPath)
        if let cell = cell as? EmbeddedCollectionViewCell {
            let dataArrCount = delegate?.getDataArrCount(rowNum: rowNum) ?? 0
            if indexPath.row < dataArrCount {
                let item: Int = delegate?.getItem(rowNum: rowNum, index: indexPath.row) ?? 0
                print("refresh cellForItemAt rowNum: \(rowNum), index: \(indexPath.row), item: \(item)")

                cell.mLabel.text = "\(item)"
                if indexPath.row % 2 == 0 {
                    cell.backgroundColor = UIColor.gray
                } else {
                    cell.backgroundColor = UIColor.green
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        delegate?.reorderItem(item: sourceIndexPath.item, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath, rowNum: rowNum)
//        let temp = dataArr.remove(at: sourceIndexPath.item)
//        dataArr.insert(temp, at: destinationIndexPath.item)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension CustomTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt row: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt row: \(indexPath.row)")
    }
}


extension CustomTableViewCell: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = delegate?.getItem(rowNum: rowNum, index: indexPath.row)//        let item = dataArr[indexPath.row]
        let itemProvider = NSItemProvider(object: String(item!) as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        let itemObj: (data: Int, indexPath: IndexPath) = (item!,indexPath)
        dragItem.localObject = itemObj
        return [dragItem]
    }
}


extension CustomTableViewCell: UICollectionViewDropDelegate {
    
    //允許drop session操作
    // note: 不了解session.canLoadObjects這行code
    func collectionView(_ collectionView: UICollectionView, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: NSString.self)
    }
    
    //在手指移動的過程中,持續update之間的UI change by UICollectionViewDropProposal
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        //TODO 待確認是否需要check isInTableView
        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)

    }
    
    
    //取得destinationIndexPath,並根據coordinator.proposal.operation(ex: move/copy),實作reorderItem or copyItem by UICollectionView的API
    //note:  dstIndexPath.  : coordinator.destinationIndexPath
    //       sourceIndexPath: coordinator.items.sourceIndexPath
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("\(delegate?.getCollectionViewName(v: collectionView) ?? "")  performDropWith")

        /*
        let destinationIndexPath: IndexPath
        if let indexPath = coordinator.destinationIndexPath  {
            destinationIndexPath = indexPath
        } else {
            // Get last index path of table view.
            let section = collectionView.numberOfSections - 1
            let row = collectionView.numberOfItems(inSection: section)
            destinationIndexPath = IndexPath(row: row, section: section)
        }
        switch coordinator.proposal.operation {
        case .move:
//            print("performDropWith current action is: (2) copy, location is: \(coordinator.session.location(in: self))")
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
        */
    }
}

