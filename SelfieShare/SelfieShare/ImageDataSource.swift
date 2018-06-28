//
//  ImageDataSource.swift
//  SelfieShare
//
//  Created by Vo Huy on 6/28/18.
//  Copyright © 2018 Vo Huy. All rights reserved.
//

import UIKit

class ImageDataSource: NSObject, UICollectionViewDataSource {
    var images = [UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = "ImageView"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.row]
        }
        
        return cell
    }
}
