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
        
        //init collectionView setting
        mCollectionView.dataSource = self
        mCollectionView.delegate = self
        //        mCollectionView.dragInteractionEnabled = true // To enable intra-app drags on iPhone
        
        mCollectionView.canCancelContentTouches = false
        mCollectionView.delaysContentTouches = false
        //        self.collectionView!.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: "handleLongGesture:"))
        //        let gesture = UITapGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        //UITapGestureRecognizer
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(onTapGesture(_:)))
        mCollectionView.addGestureRecognizer(gesture)
        
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

//extension ViewController: UICollectionViewDragDelegate {
//    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
//        <#code#>
//    }
//    
//    
//}
