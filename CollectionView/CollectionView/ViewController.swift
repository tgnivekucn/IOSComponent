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
    
    @IBOutlet weak var mLabel: UILabel!
    @IBOutlet weak var mCollectionView: UICollectionView!
    var dataArr = [0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]
    override func viewDidLoad() {
        super.viewDidLoad()
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        mCollectionView.dragDelegate = self
        mCollectionView.dropDelegate = self
        //        mCollectionView.dragInteractionEnabled = true // To enable intra-app drags on iPhone
        
        mCollectionView.canCancelContentTouches = false
        mCollectionView.delaysContentTouches = false
        //        self.collectionView!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongGesture:"))
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        //UITapGestureRecognizer
//        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
//        mCollectionView.addGestureRecognizer(gesture)
//
        
        mLabel.isUserInteractionEnabled = true

        let dragInteraction = UIDragInteraction(delegate: self)
        mLabel.addInteraction(dragInteraction)
        let dropInteraction = UIDropInteraction(delegate: self)
        mLabel.addInteraction(dropInteraction)

        
    }
    
    @objc func onTapGesture(_ gesture:UIPanGestureRecognizer) {
        print("Tapped!!")
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
        print("UICollectionView dropSessionDidUpdate")

        return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)

    }
    
    
    //取得destinationIndexPath,並根據coordinator.proposal.operation(ex: move/copy),實作reorderItem or copyItem by UICollectionView的API
    //note:  dstIndexPath.  : coordinator.destinationIndexPath
    //       sourceIndexPath: coordinator.items.sourceIndexPath
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        print("UICollectionView performDropWith")

//        let destinationIndexPath: IndexPath
//        if let indexPath = coordinator.destinationIndexPath  {
//            destinationIndexPath = indexPath
//        } else {
//            // Get last index path of table view.
//            let section = collectionView.numberOfSections - 1
//            let row = collectionView.numberOfItems(inSection: section)
//            destinationIndexPath = IndexPath(row: row, section: section)
//        }
//
//        switch coordinator.proposal.operation {
//        case .move:
//            self.copyItems(coordinator: coordinator, destinationIndexPath: destinationIndexPath, collectionView: collectionView)
//            break
//        default:
//            return
//        }
        
    }
}












extension ViewController: UIDragInteractionDelegate {
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let item = "398"
        let itemProvider = NSItemProvider(object: item as NSString)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = item
        return [dragItem]
    }
}

extension ViewController: UIDropInteractionDelegate {
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        print("UIDropInteraction sessionDidUpdate")
        //Update UI
        let dropLocation = session.location(in: view)
//        updateLayers(forDropLocation: dropLocation)
        
        
//
//        let operation: UIDropOperation
//
//        if imageView.frame.contains(dropLocation) {
//            /*
//                 If you add in-app drag-and-drop support for the .move operation,
//                 you must write code to coordinate between the drag interaction
//                 delegate and the drop interaction delegate.
//            */
//            operation = session.localDragSession == nil ? .copy : .move
//        } else {
//            // Do not allow dropping outside of the image view.
//            operation = .cancel
//        }

        return UIDropProposal(operation: .move)
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        print("UIDropInteraction performDrop")

        // Consume drag items (in this example, of type UIImage).
//        session.loadObjects(ofClass: UIImage.self) { imageItems in
//            let images = imageItems as! [UIImage]
//
//            /*
//                 If you do not employ the loadObjects(ofClass:completion:) convenience
//                 method of the UIDropSession class, which automatically employs
//                 the main thread, explicitly dispatch UI work to the main thread.
//                 For example, you can use `DispatchQueue.main.async` method.
//            */
//            self.imageView.image = images.first
//        }

        // Perform additional UI updates as needed.
        let dropLocation = session.location(in: view)
//        updateLayers(forDropLocation: dropLocation)
    }
    
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        print("UIDropInteraction sessionDidEnd")

    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        print("UIDropInteraction sessionDidExit")

    }

}



