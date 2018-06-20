//
//  ExpandingCollectionView.swift
//  AutoLayoutCollectionView
//
//  Created by Chris Conover on 6/13/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class ExpandingCollectionViewController: CalculatedSizeCollectionViewController<SimpleCalculatedSizeCell> {

    init() {
        super.init("Expanding")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = SimpleCalculatedSizeCell.prototype
        let contents = data[indexPath.section][indexPath.item]
        cell.label.text = contents
        let width = collectionView.bounds
            .inset(collectionView.contentInset)
            .inset(layout.sectionInset)
            .width
        let finalSize = cell.systemLayoutSizeFitting(
            .init(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
            .withWidth(width)

        if selected.contains(indexPath) {
            print("\(#function): \(finalSize)")
            return finalSize.withHeight(250)
        }

        print("\(#function): \(finalSize)")
        return finalSize.withHeight(150)
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if selected.contains(indexPath) { selected.remove(indexPath) }
        else { selected.insert(indexPath) }

        UIView.animate(withDuration: 0.25, animations: {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
        })
    }
}


