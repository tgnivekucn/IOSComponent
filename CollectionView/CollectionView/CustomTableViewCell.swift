//
//  CustomTableViewCell.swift
//  CollectionView
//
//  Created by Kuangyu Nien on 2019/12/9.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import UIKit
class EmbeddedCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var mLabel: UILabel!
}
class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var mCollectionView: UICollectionView!
    
    var dataArr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.dropDelegate = self
        //        mCollectionView.canCancelContentTouches = false
        //        mCollectionView.delaysContentTouches = false
        //        mCollectionView.alwaysBounceVertical = false
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        mCollectionView.addGestureRecognizer(gesture)
        
        //Set collectionView to one row
        let collectionViewFlowControl = UICollectionViewFlowLayout()
        collectionViewFlowControl.scrollDirection = UICollectionView.ScrollDirection.horizontal
        mCollectionView.setCollectionViewLayout(collectionViewFlowControl, animated: false)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @objc func onTapGesture(_ gesture:UIPanGestureRecognizer) {
        print("CustomTableViewCell Tapped!!")
        switch(gesture.state) {
        case UIGestureRecognizerState.began:
            guard let selectedIndexPath = self.mCollectionView!.indexPathForItem(at: gesture.location(in: self.mCollectionView)) else
            {
                break
            }
            mCollectionView!.beginInteractiveMovementForItem(at: selectedIndexPath)
        case UIGestureRecognizerState.changed:
            mCollectionView!.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case UIGestureRecognizerState.ended:
            mCollectionView!.endInteractiveMovement()
        default:
            mCollectionView!.cancelInteractiveMovement()
        }
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


//extension CustomTableViewCell: UICollectionViewDragDelegate {
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        let item = self.dataArr[indexPath.row]
//        let dragItem = UIDragItem(itemProvider: NSItemProvider())
//        dragItem.localObject = item
//        return [dragItem]
//    }
//
//
//}

extension CustomTableViewCell: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        print("UICollectionView dropSessionDidUpdate")
        guard session.localDragSession != nil else {
          return UICollectionViewDropProposal(
              operation: .copy,
              intent: .insertAtDestinationIndexPath)
        }
        guard session.items.count == 1 else {
          return UICollectionViewDropProposal(operation: .cancel)
        }
        return UICollectionViewDropProposal(
            operation: .move,    intent: .insertAtDestinationIndexPath)

    }

    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("UICollectionView performDropWith")
    }
    
    
}
