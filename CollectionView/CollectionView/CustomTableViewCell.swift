//
//  CustomTableViewCell.swift
//  CollectionView
//
//  Created by Kuangyu Nien on 2019/12/9.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import UIKit
protocol ComminicationBetweenCellAndTableView: class {
    func reorderItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
    func moveItem(item: Int, sourceIndexPath: IndexPath, destinationIndexPath: IndexPath)
}
class EmbeddedCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var mLabel: UILabel!
}
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var dataArr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    weak var delegate: ComminicationBetweenCellAndTableView? = nil
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
    
    func setup(delegate: ComminicationBetweenCellAndTableView) {
        self.delegate = delegate
    }
    
    
    
    //實作reorder items
    //1)取出sourceIndexPath和傳入的參數destinationIndexPath
    //2)對資料結構進行 -> remove sourceIndexPath.row
    //               -> insert item.dragItem.localObject at dIndexPath.row
    //3)對collectionView -> deleteItems at [sourceIndexPath]
    //             -> insertItems at [dIndexPath]
    //4)顯示dragItem從目的cell上方到取代該目的cell的動畫 by coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
    //    (p.s 不太確定這行的意義,猜測是for drop掉dIndexPath上的preview UI)
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)  {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0) {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                delegate?.reorderItem(item: item.dragItem.localObject as! Int, sourceIndexPath: sourceIndexPath, destinationIndexPath: dIndexPath)
//                #if DEBUG
//                self.dataArr.remove(at: sourceIndexPath.row)
//                self.dataArr.insert(item.dragItem.localObject as! Int, at: dIndexPath.row)
//                #endif
                
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
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
        collectionView.performBatchUpdates({
            var indexPaths = [IndexPath]()
            for (index, item) in coordinator.items.enumerated()
            {
                let indexPath = IndexPath(row: destinationIndexPath.row + index, section: destinationIndexPath.section)
                
                if let sourceIndexPath = item.sourceIndexPath {
                    delegate?.moveItem(item: item.dragItem.localObject as! Int, sourceIndexPath: sourceIndexPath, destinationIndexPath: destinationIndexPath)
                }
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
                
                indexPaths.append(indexPath)
            }
            collectionView.insertItems(at: indexPaths)
        })
    }
    
    
    
}


extension CustomTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell1", for: indexPath)
        if let cell = cell as? EmbeddedCollectionViewCell {
            if indexPath.row < dataArr.count {
                cell.mLabel.text = "\(dataArr[indexPath.row])"
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
        let temp = dataArr.remove(at: sourceIndexPath.item)
        dataArr.insert(temp, at: destinationIndexPath.item)
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
        let item = dataArr[indexPath.row]
        let itemProvider = NSItemProvider(object: String(item) as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
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
//        public enum UIDropOperation : UInt {
//           case cancel
//            case forbidden
//            case copy
//            case move
//        }

        print("dropSessionDidUpdate hasActiveDrag: \(collectionView.hasActiveDrag) // hasActiveDrop: \(collectionView.hasActiveDrop)")
        //判斷 collectionView是否正在drag或drop,且是否dragItem目前的位置是否在同一個collectionView,來決定要回傳哪種operation
        // 1) 同個row或不同row -> move
        // 2) 在兩列之間 -> move
        // 3) 超出tableView範圍 -> forbidden or cancel
        if collectionView.hasActiveDrag {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }
    
    
    //取得destinationIndexPath,並根據coordinator.proposal.operation(ex: move/copy),實作reorderItem or copyItem by UICollectionView的API
    //note:  dstIndexPath.  : coordinator.destinationIndexPath
    //       sourceIndexPath: coordinator.items.sourceIndexPath
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print(" performDropWith ")
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
            print("performDropWith current action is: (1) move")
            self.reorderItems(coordinator: coordinator, destinationIndexPath:destinationIndexPath, collectionView: collectionView)
            break
        case .copy:
            print("performDropWith current action is: (2) copy")
            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
    }
}

