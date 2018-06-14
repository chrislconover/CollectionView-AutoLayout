//
//  ConstraintWidthCell.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

extension UICollectionView {

    var contentBounds: CGRect {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
            else { return bounds.inset(contentInset) }
        return bounds.inset(contentInset).inset(flowLayout.sectionInset)
    }

    var contentWidthMaxInBounds: CGFloat { return self.bounds.size.width - horizontalInset }
    var horizontalInset: CGFloat {
        let flowInset = (collectionViewLayout as? UICollectionViewFlowLayout)
            .flatMap { $0.sectionInset.left + $0.sectionInset.right } ?? 0
        return (contentInset.left + contentInset.right) + flowInset
    }

    var contentHeightMaxInBounds: CGFloat { return self.bounds.size.height - verticalInset }
    var verticalInset: CGFloat {
        let flowInset = (collectionViewLayout as? UICollectionViewFlowLayout)
            .flatMap { $0.sectionInset.top + $0.sectionInset.bottom } ?? 0
        return (contentInset.top + contentInset.bottom) + flowInset
    }
}

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
