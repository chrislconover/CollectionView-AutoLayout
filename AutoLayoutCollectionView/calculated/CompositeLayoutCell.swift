//
//  CompositeLayoutCell.swift
//  AutoLayoutCollectionView
//
//  Created by Chris Conover on 6/20/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


final class CompositeLayoutCell: UICollectionViewCell, TextCell {

    static var prototype: CompositeLayoutCell = CompositeLayoutCell()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contentView.backgroundColor = .white
        contentView.pin(contents)
    }

    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return super.systemLayoutSizeFitting(targetSize)
    }

    var text: String? {
        get { return contents.title.text }
        set { contents.title.text = newValue }
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

    var contents: CompositeLayoutCellContents = CompositeLayoutCellContents()
}

class Header: UIView {}
class Body: UIView {}
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
        pin(body, to: .right, .bottom, .left,  inset: 10)
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

    lazy var body: UIView = {
        let view = Body()
        view.backgroundColor = .blue
        view.pin(contents, inset: 9)
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }()

    lazy var contents: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.numberOfLines = 0
        label.text = "Body with height constraint of \(height)"
        return label
    }()

    lazy var height:CGFloat = 60
}





