//
//  ConstraintHeightCell.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class ConstraintHeightCell: UICollectionViewCell {
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
        contentView.pin(red, inset: 0)
    }

    lazy var red: UIView = {
        let view = RedView()
        view.pin(blue, inset: 5)
        return view
    }()

    lazy var blue: UIView = {
        let view = BlueView()
        view.pin(label, inset: 0)
        return view
    }()

    let label = UILabel()

    override func updateConstraints() {
        height.constant = bounds.size.height
        super.updateConstraints()
    }

    lazy var height: NSLayoutConstraint = {
        return contentView.heightAnchor.constraint(equalToConstant: bounds.size.height)
            .isActive(true) }()

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize, withHorizontalFittingPriority
        horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: 1000, height: targetSize.height),
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: .required)

        let adjusted = CGSize(width: size.width, height: max(size.height, targetSize.height))
        print("\(#function) \(#line) \(targetSize) -> \(size) -> \(adjusted)")
        return size
    }
}
