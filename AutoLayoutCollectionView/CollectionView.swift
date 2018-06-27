//
//  CollectionView.swift
//  AutoLayoutCollectionView
//
//  Created by Chris Conover on 6/26/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class RotatingCollectionView: UICollectionView {
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        collectionViewLayout.invalidateLayout()
        reloadData()
    }
}


class FullWidthCollectionView: RotatingCollectionView {
    override func layoutSubviews() {
        let expectedWidth = contentWidthMaxInBounds
        if bounds.size.width > 0,
            let layout = collectionViewLayout as? UICollectionViewFlowLayout,
            layout.estimatedItemSize.width != expectedWidth {
            layout.estimatedItemSize.width = expectedWidth
        }

        // hangs here when you try to use estimated size 
        super.layoutSubviews()
    }
}

