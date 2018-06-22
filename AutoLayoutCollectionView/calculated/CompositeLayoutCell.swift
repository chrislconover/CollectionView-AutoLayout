//
//  CompositeLayoutCell.swift
//  AutoLayoutCollectionView
//
//  Created by Chris Conover on 6/20/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

final class CompositeLayoutCell: UICollectionViewCell, TextCell {

    static var prototype: CompositeLayoutCell = CompositeLayoutCell()
    var text: String? {
        get { return contents.title.text }
        set { contents.title.text = newValue }
    }
    var onDrag: (()->())?

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        onDrag = nil
    }

    private func configure() {
        contentView.backgroundColor = .white
        contentView.pin(contents)
        self.addGestureRecognizer(pan)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return super.systemLayoutSizeFitting(targetSize)
    }

    var expand: Bool {
        get { return contents.panelHeight.isActive }
        set {
            guard newValue != expand else { return }
            contents.panelHeight.isActive = newValue
            invalidateIntrinsicContentSize()
            setNeedsLayout()
            contents.setNeedsLayout()
            contents.invalidateIntrinsicContentSize()
        }
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

    lazy var pan: UIPanGestureRecognizer = {
        let gesture =  UIPanGestureRecognizer(target: self, action: #selector(onPanGesture))
        return gesture }()
    var panStart: CGPoint = .init()


    @objc func onPanGesture(pan: UIPanGestureRecognizer) {
        if case .ended = pan.state {
            onDrag?()
        }
    }

    var contents: CompositeLayoutCellContents = CompositeLayoutCellContents()
}

class Header: UIView {}
class Body: UIView {}
class Panel: UIView {}

class CompositeLayoutCellContents: UIView {

    init() {
        super.init(frame: .zero)
        configureLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        pin(header, to: .left, .top, .right,  inset: 10)
        pin(panel, to: .right, .bottom, .left,  inset: 10)
        body.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
    }

    lazy var header: UIView = {
        let view = Header()
        view.pin(title, inset: 10)
        view.backgroundColor = .red
        return view
    }()

    let title: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()

    lazy var panel: UIView = {
        let view = Panel()
        view.pin(body, to: .left, .top, .right)
        view.clipsToBounds = true
        panelHeight = view.heightAnchor.constraint(equalTo: body.heightAnchor)
        return view
    }()

    var panelHeight: NSLayoutConstraint!
    lazy var height:CGFloat = 60

    lazy var body: UIView = {
        let view = Body()
        view.backgroundColor = .blue
        view.pin(contents, inset: 9)
        let bodyHeight = view.heightAnchor.constraint(equalToConstant: height)
        bodyHeight.isActive = true
        return view
    }()

    lazy var contents: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.text = "Body with height constraint of \(height)"
        return label
    }()
}





