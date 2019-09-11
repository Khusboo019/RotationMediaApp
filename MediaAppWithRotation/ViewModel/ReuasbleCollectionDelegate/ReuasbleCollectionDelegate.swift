//
//  ReuasbleCollectionDelegate.swift
//  MediaAppWithRotation
//
//  Created by Khusboo Suhasini Preety on 11/09/19.
//  Copyright © 2019 Khusboo Suhasini Preety. All rights reserved.
//

import Foundation
import UIKit

public protocol ReuasbleCollectionDelegate:class {
    func didSelectCollection(indexPath:Int)
}

open class ReuasbleCollection:NSObject {
    private weak var presentationController:UIViewController?
    private weak var delegateReusableCollection:ReuasbleCollectionDelegate?
    var customCollectionView:UICollectionView!
    
    lazy var collectionViewFlowLayout : CustomCollectionViewFlowLayout = {
        if UIDevice.current.orientation.isLandscape == true {
            let layout = CustomCollectionViewFlowLayout(display: .grid)
            return layout
        }else{
            let layout = CustomCollectionViewFlowLayout(display: .list)
            return layout
        }
        
    }()
    
    
    public init(presentationController:UIViewController,delegate:ReuasbleCollectionDelegate,collectionView:UICollectionView){
        super.init()
        self.presentationController = presentationController
        customCollectionView=collectionView
        self.delegateReusableCollection = delegate
        customCollectionView.dataSource = self
        customCollectionView.delegate = self
        
        customCollectionView.collectionViewLayout = self.collectionViewFlowLayout
        registerClass(collectionView:collectionView)
    }
    
    fileprivate func registerClass(collectionView:UICollectionView){
         CustomCollectionViewCell.register(for: collectionView)
    }
    
}

extension UICollectionViewCell {
    
    static func register(for collectionView: UICollectionView)  {
        let cellName = String(describing: self)
        let cellIdentifier = cellName + "CustomCell"
        let cellNib = UINib(nibName: String(describing: self), bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: cellIdentifier)
    }
}

extension ReuasbleCollection:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SingletoneClass.sharedSingletone.collectionArray.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : CustomCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCellCustomCell", for: indexPath) as! CustomCollectionViewCell
        cell.imgView.image = SingletoneClass.sharedSingletone.collectionArray[indexPath.row].img
        if SingletoneClass.sharedSingletone.collectionArray[indexPath.row].path.contains(".mp4"){
            cell.playBtn.isHidden=false
        }else{
            cell.playBtn.isHidden=true
        }
        return cell
    }
  
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegateReusableCollection?.didSelectCollection(indexPath: indexPath.row)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.orientation.isLandscape == true {
            let width = (collectionView.frame.size.width - 12 * 2) / 3
            let height = width * 1.2 //ratio
            return CGSize(width: width, height: height)
        }else{
            let width = collectionView.frame.size.width
            let height = collectionView.frame.size.height/2.5 //ratio
            return CGSize(width: width, height: height)
        }
        
    }

}
    

