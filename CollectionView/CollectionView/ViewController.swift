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
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    var dataArr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    override func viewDidLoad() {
        super.viewDidLoad()
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.dragDelegate = self
        mCollectionView.dropDelegate = self
        //        mCollectionView.dragInteractionEnabled = true // To enable intra-app drags on iPhone
        
        //   mCollectionView.delaysContentTouches = false
        //     mCollectionView.canCancelContentTouches = false
        
        
        //Set collectionView to one row
        let collectionViewFlowControl = UICollectionViewFlowLayout()
        collectionViewFlowControl.scrollDirection = UICollectionView.ScrollDirection.horizontal
        mCollectionView.setCollectionViewLayout(collectionViewFlowControl, animated: false)
        
    }
    
    private func reorderItems(coordinator: UICollectionViewDropCoordinator, destinationIndexPath: IndexPath, collectionView: UICollectionView)
    {
        let items = coordinator.items
        if items.count == 1, let item = items.first, let sourceIndexPath = item.sourceIndexPath
        {
            var dIndexPath = destinationIndexPath
            if dIndexPath.row >= collectionView.numberOfItems(inSection: 0)
            {
                dIndexPath.row = collectionView.numberOfItems(inSection: 0) - 1
            }
            collectionView.performBatchUpdates({
                if collectionView === self.mCollectionView
                {
                    self.dataArr.remove(at: sourceIndexPath.row)
                    self.dataArr.insert(item.dragItem.localObject as! Int, at: dIndexPath.row)
                }
                collectionView.deleteItems(at: [sourceIndexPath])
                collectionView.insertItems(at: [dIndexPath])
            })
            coordinator.drop(items.first!.dragItem, toItemAt: dIndexPath)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell1", for: indexPath)
        if let cell = cell as? CustomCollectionViewCell {
            if indexPath.row < dataArr.count {
                cell.test.text = "\(dataArr[indexPath.row])"
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let temp = dataArr.remove(at: sourceIndexPath.item)
        dataArr.insert(temp, at: destinationIndexPath.item)
    }
    
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt row: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselectItemAt row: \(indexPath.row)")
    }
}

extension ViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let item = dataArr[indexPath.row]
        let itemProvider = NSItemProvider(object: String(item) as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UICollectionViewDropDelegate {
    
    //允許drop session操作
    // note: TODO 不了解session.canLoadObjects這行code
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
            self.reorderItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
            break
        default:
            return
        }
        
    }
}
