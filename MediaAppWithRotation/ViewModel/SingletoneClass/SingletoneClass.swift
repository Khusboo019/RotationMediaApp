//
//  SingletoneClass.swift
//  MediaAppWithRotation
//
//  Created by Khusboo Suhasini Preety on 11/09/19.
//  Copyright © 2019 Khusboo Suhasini Preety. All rights reserved.
//

import UIKit

class SingletoneClass:NSObject {
    
    static let sharedSingletone = SingletoneClass()
    
    override init() {
        
    }
    var collectionArray:[(img: UIImage, path: String)] = []
    
}
