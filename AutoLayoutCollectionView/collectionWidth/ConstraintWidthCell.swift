//
//  ConstraintWidthCell.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    var collectionView: UICollectionView? {
        return superview as? UICollectionView
    }
}


class ConstraintWidthCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.pin(label, inset: 0)
    }

    override func updateConstraints() {
        let w = collectionView!.contentBounds.width
        width.constant = collectionView!.contentBounds.width
        super.updateConstraints()
    }

    lazy var width: NSLayoutConstraint = {
        return contentView.heightAnchor.constraint(equalToConstant: bounds.size.width)
            .isActive(true) }()

//    override func systemLayoutSizeFitting(
//        _ targetSize: CGSize, withHorizontalFittingPriority
//        horizontalFittingPriority: UILayoutPriority,
//        verticalFittingPriority: UILayoutPriority) -> CGSize {
//
////        let w = collectionView!.contentBounds.width
////        width.constant = collectionView!.contentBounds.width
//        return super.systemLayoutSizeFitting(
//            targetSize,
//            withHorizontalFittingPriority: horizontalFittingPriority,
//            verticalFittingPriority: verticalFittingPriority)
//    }

    let label:UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()
}
