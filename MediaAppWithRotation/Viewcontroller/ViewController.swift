//
//  ViewController.swift
//  MediaAppWithRotation
//
//  Created by Khusboo Suhasini Preety on 11/09/19.
//  Copyright © 2019 Khusboo Suhasini Preety. All rights reserved.
//

import UIKit
import AVKit
import QuickLook

class ViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var reusablCollectionView:ReuasbleCollection!
    typealias CompletionHandler = (_ success:Bool) -> Void
    var dataArray=[[String:String]]()
    
    lazy var previewItem = NSURL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reusablCollectionView = ReuasbleCollection(presentationController: self, delegate: self, collectionView: collectionView)
        
        dataArray.append(["Resource":"sampleVideoLocal","Type":"mp4"])
        dataArray.append(["Resource":"sampleImage","Type":"png"])
        dataArray.append(["Resource":"sampleDoc","Type":"doc"])
        dataArray.append(["Resource":"samplePDF","Type":"pdf"])
        
        addMediaDataToLocalStorage(completionHandler: {(success) -> Void in
            self.reusablCollectionView.customCollectionView.reloadData()
        })
        
    }

    func addMediaDataToLocalStorage(completionHandler:CompletionHandler){
        
        SingletoneClass.sharedSingletone.collectionArray.removeAll()
        
        for i in 0..<dataArray.count {
            
            let img = ReusableClass.sharedReusableClass.findThumbnailImage(ofResource:dataArray[i]["Resource"] ?? "", ofType: dataArray[i]["Type"] ?? "")
            
            if img.0 == nil {
                print("No image found")
            }else{
                SingletoneClass.sharedSingletone.collectionArray.append((img:img.0!, path: img.1!))
            }
            
          }
    }
}

extension ViewController:QLPreviewControllerDataSource,QLPreviewControllerDelegate{
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return self.previewItem
    }
    
    func previewControllerWillDismiss(_ controller: QLPreviewController) {
        print("The Preview Controller will be dismissed.")
    }
    
    func previewController(_ controller: QLPreviewController, shouldOpen url: URL, for item: QLPreviewItem) -> Bool {
        if item as! NSURL == self.previewItem {
            return true
        }
        else {
            print("Will not open URL \(url.absoluteString)")
        }
        
        return false
    }
}


extension ViewController:ReuasbleCollectionDelegate {
    
    func didSelectCollection(indexPath:Int) {
        
        if SingletoneClass.sharedSingletone.collectionArray[indexPath].path.contains(".mp4"){
           self.performSegue(withIdentifier: "PlaySegue", sender: SingletoneClass.sharedSingletone.collectionArray[indexPath].path)
        }else{
            self.previewItem = URL(fileURLWithPath: SingletoneClass.sharedSingletone.collectionArray[indexPath].path) as NSURL
            
            let quickLookController = QLPreviewController()
            quickLookController.dataSource = self
            quickLookController.delegate = self
            
            if QLPreviewController.canPreview(self.previewItem) {
                quickLookController.currentPreviewItemIndex = 0
                navigationController?.pushViewController(quickLookController, animated: true)
            }
        }
    }
    
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
         handleOrientationForLandscape(isLandscape: UIDevice.current.orientation.isLandscape)
    }
    
    func handleOrientationForLandscape(isLandscape: Bool)  {
        
      if isLandscape
        {
         reusablCollectionView.collectionViewFlowLayout.display = .grid
      }else
        {
        reusablCollectionView.collectionViewFlowLayout.display = .list
     }
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlaySegue", let vc = segue.destination as? PlayViewController, let variable = sender as? String {
            vc.localPath = variable
        }
    }
    
}

