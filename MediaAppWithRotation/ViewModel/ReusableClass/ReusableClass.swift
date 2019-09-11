//
//  GenerateThumbNail.swift
//  MediaAppWithRotation
//
//  Created by Khusboo Suhasini Preety on 11/09/19.
//  Copyright © 2019 Khusboo Suhasini Preety. All rights reserved.
//

import Foundation
import AVKit
import PDFKit

class ReusableClass:NSObject {
    
    static let sharedReusableClass=ReusableClass()
    
    func findThumbnailImage(ofResource:String,ofType:String) -> (UIImage?,String?) {
        
        guard let path = Bundle.main.path(forResource: ofResource, ofType:ofType) else {
            debugPrint("file not found")
            return (nil,"")
        }
        
        if ofType == "pdf" {
            return self.getThumbnailForPDF(path)
        }else if ofType == "mp4" {
            return self.getThumbnailForVideo(path: path)
        }else if ofType == "png" {
            return self.getThumbnailForImage(path: path)
        }else{
            return self.getThumbnailForDoc(path: path)
        }
        
    }
    func generateThumbnail(for asset:AVAsset) -> UIImage? {
        let assetImgGenerate : AVAssetImageGenerator = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        let time = CMTimeMake(value: 1, timescale: 2)
        let img = try? assetImgGenerate.copyCGImage(at: time, actualTime: nil)
        if img != nil {
            let frameImg  = UIImage(cgImage: img!)
            return frameImg
        }
        return nil
    }
    
    func getThumbnailForVideo(path:String) -> (UIImage?,String?) {
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        guard let img = self.generateThumbnail(for: asset) else {
            print("Error: Thumbnail can be generated.")
            return (nil,path)
        }
       return (img,path)
    }
    
    func getThumbnailForDoc(path:String) -> (UIImage?,String?) {
         return (UIImage(named: "Word-Blue"),path)
    }
    
    func getThumbnailForImage(path:String) -> (UIImage?,String?) {
        
        if let imageData = NSData(contentsOf: URL(fileURLWithPath: path)) {
            let options = [
                kCGImageSourceCreateThumbnailWithTransform: true,
                kCGImageSourceCreateThumbnailFromImageAlways: true,
                kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary
            let source = CGImageSourceCreateWithData(imageData, nil)!
            let imageReference = CGImageSourceCreateThumbnailAtIndex(source, 0, options)!
            let thumbnail = UIImage(cgImage: imageReference)
            return (thumbnail,path)
        }
        return (nil,path)
    }
    
    
    func getThumbnailForPDF(_ path:String) -> (UIImage?,String?) {
        let pdfDocument = PDFDocument(url: URL(fileURLWithPath: path))
        let pdfDocumentPage = pdfDocument?.page(at: 0)
        return (pdfDocumentPage?.thumbnail(of: CGSize(width: 1000, height: 1000), for: PDFDisplayBox.trimBox),path)
    }
}


