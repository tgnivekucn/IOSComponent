//
//  ViewController.swift
//  ScrollView
//
//  Created by Kuangyu Nien on 2019/12/12.
//  Copyright © 2019 Kuangyu Nien. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var mScrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mScrollView.delegate = self
    }


}

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) { // any offset changes
//        print("(1) scrollViewDidScroll")

    }
    
    // called on start of dragging (may require some time and or distance to move)
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("(2) scrollViewWillBeginDragging")

    }

    // called on finger up if the user dragged. velocity is in points/millisecond. targetContentOffset may be changed to adjust where the scroll view comes to rest
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        print("(3) scrollViewWillEndDragging")

    }

    // called on finger up if the user dragged. decelerate is true if it will continue moving afterwards
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        print("(4) scrollViewDidEndDragging")
    }

    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {// called on finger up as we are moving
        print("(5) scrollViewWillBeginDecelerating")

    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) { // called when scroll view grinds to a halt
        print("(6) scrollViewWillBeginDecelerating")

    }
    
}
