//
//  EstimatedWidthCell.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class EstimatedWidthCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize, withHorizontalFittingPriority
        horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {

        width.constant = bounds.size.width

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: targetSize.width, height: 1),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: verticalFittingPriority)

        let adjusted = CGSize(width: size.width, height: max(size.height, targetSize.height))
        print("systemLayoutSizeFitting \(targetSize) -> \(size) -> \(adjusted)")
        return size
    }

    lazy var width: NSLayoutConstraint = {
        return contentView.widthAnchor
            .constraint(equalToConstant: bounds.size.width)
            .isActive(true)
    }()
}

class ParagraphContentView: UIView {}
class ParagraphTestCell: EstimatedWidthCell {

    static var prototype: ParagraphTestCell = ParagraphTestCell()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .magenta
        contentView.pin(label, inset: 10)
    }

    let label:UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()
}

