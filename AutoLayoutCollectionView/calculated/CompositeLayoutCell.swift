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
    var title: String? {
        get { return contents.title.text }
        set {
            contents.title.text = newValue
        }
    }

    var text: String? {
        get { return contents.subTitle.text }
        set { contents.subTitle.text = newValue }
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

    var expand: Bool {
        get { return contents.expand }
        set { contents.expand = newValue }
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        return contentView.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority)
            .withWidth(targetSize.width)
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

    var expand: Bool {
        get { return expandedConstraint.isActive }
        set {
            guard newValue != expand else { return }
            expandedConstraint.isActive = newValue
            setNeedsUpdateConstraints()
        }
    }

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
        panel.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
    }

    lazy var header: UIView = {
        let view = Header()
        view.pin(title, to: .left, .top, .right, inset: 10)
        view.pin(subTitle, to: .right, .bottom, .left, inset: 10)
        subTitle.topAnchor.constraintEqualToSystemSpacingBelow(title.bottomAnchor, multiplier: 1)
            .isActive = true
        view.backgroundColor = .red
        return view
    }()

    let title: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()

    let subTitle: UILabel = {
        let label = UILabel()
        label.backgroundColor = .green
        label.numberOfLines = 0
        return label
    }()

    lazy var panel: UIView = {
        let panel = Panel()
        panel.backgroundColor = .magenta
        panel.clipsToBounds = true

        panel.pin(body, to: .left, .top, .right)
        let collapsed = panel.heightAnchor.constraint(equalToConstant: 0)
        collapsed.priority = .defaultLow
        collapsed.isActive = true
        expandedConstraint = panel.bottomAnchor.constraint(equalTo: body.bottomAnchor)
        expandedConstraint.priority = .required
        expandedConstraint.isActive = false
        return panel
    }()

    var expandedConstraint: NSLayoutConstraint!
    lazy var height:CGFloat = 60

    lazy var body: UIView = {
        let view = Body()
        view.layer.borderColor = UIColor.blue.cgColor
        view.layer.borderWidth = 2
        view.pin(nestedCollection, inset: 9)
        return view
    }()

    lazy var contents: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.text = "Body with height constraint of \(height)"
        return label
    }()

    lazy var nestedCollection: UICollectionView = {
        let collectionView = NestedCollectionView(frame: .init(), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SimpleCalculatedSizeCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        return layout
    }()

    var data: [[String]] = [[
        "Apple",
        "Orange",
        "Banana",
        "Grapefruit"
    ]]
    let prototype: SimpleCalculatedSizeCell = SimpleCalculatedSizeCell()
}


extension CompositeLayoutCellContents: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath:    IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:
            "Cell", for: indexPath) as! SimpleCalculatedSizeCell
        cell.label.text = data[indexPath.section][indexPath.item]
        return cell
    }
}

extension CompositeLayoutCellContents: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let contents = data[indexPath.section][indexPath.item]
        prototype.text = contents

        let width = collectionView.bounds
            .inset(collectionView.contentInset)
            .inset(layout.sectionInset)
            .width
        return prototype.systemLayoutSizeFitting(
            .init(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
    }
}


class NestedCollectionView: UICollectionView {

    override func layoutSubviews() {

        let expectedWidth = adjustedContentSize.width
        if bounds.size.width > 0,
            let layout = collectionViewLayout as? UICollectionViewFlowLayout,
            layout.estimatedItemSize.width != expectedWidth {
            layout.estimatedItemSize = layout.estimatedItemSize.withWidth(expectedWidth)
        }

        let layoutSize = collectionViewLayout.collectionViewContentSize
        let totalHeight = layoutSize.height // layout.height + verticalInset
        let needToUpdateSize = layoutSize.height > 0
            ? bounds.size.height != totalHeight
            : bounds.size.height != 0
        if needToUpdateSize {
            invalidateIntrinsicContentSize()
        }

        super.layoutSubviews()
    }

    override var intrinsicContentSize: CGSize {
        let defaultSize = super.intrinsicContentSize
        let layoutSize = collectionViewLayout.collectionViewContentSize
        let totalHeight = layoutSize.height + verticalInset
        let finalSize = CGSize(width: defaultSize.width,
                      height: layoutSize.height > 0 ? totalHeight : defaultSize.height)
        return finalSize
    }

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize, withHorizontalFittingPriority
        horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {
        let defaultSize = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority)
        let adjustedToContent = defaultSize.withHeight(contentHeight)
        return adjustedToContent
    }
}
