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
    var title: String? { get set }
    var text: String? { get set }
    var onDrag: (()->())? { get set }
    var expand: Bool { get set }
    var pan: UIPanGestureRecognizer { get }
 }

final class SimpleCalculatedSizeCell: UICollectionViewCell, TextCell {

    static var prototype: SimpleCalculatedSizeCell = SimpleCalculatedSizeCell()
    var title: String? {
        get { return nil }
        set {} }

    var text: String? {
        get { return label.text }
        set { label.text = newValue }
    }
    var onDrag: (()->())?
    var expand: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        return contentSize.withWidth(targetSize.width)
    }

    let label:UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()

    lazy var pan: UIPanGestureRecognizer = {
        let gesture =  UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
        return gesture }()
    var panStart: CGPoint = .init()


    @objc func onPanGesture(pan: UIPanGestureRecognizer) {
        if case .ended = pan.state {
            onDrag?()
        }
    }
}

