//
//  SimpleCalculatedSizeCell.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

protocol TextCell {
    static var prototype: Self { get }
    var text: String? { get set }
}

final class SimpleCalculatedSizeCell: UICollectionViewCell, TextCell {

    static var prototype: SimpleCalculatedSizeCell = SimpleCalculatedSizeCell()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }

    private func configure() {
        contentView.backgroundColor = .white
        contentView.pin(label, inset: 10)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return super.systemLayoutSizeFitting(targetSize)
    }


    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {

        let contentSize = contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority)

        return contentSize
    }

    let label:UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()
}

