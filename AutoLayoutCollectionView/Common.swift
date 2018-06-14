//
//  Utils.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


extension CGRect {
    func inset(_ insets: UIEdgeInsets) -> CGRect {
        return UIEdgeInsetsInsetRect(self, insets)
    }
}

extension CGSize {

    func insetBy(dx: CGFloat, dy: CGFloat) -> CGSize {
        return CGSize(width: max(width - dx, 0), height: max(height - dy, 0))
    }

    func inset(_ insets: UIEdgeInsets) -> CGSize {
        return UIEdgeInsetsInsetRect(
            CGRect(x: 0, y: 0, width: width, height: height),
            insets).size
    }

    func withWidth(_ width: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }

    func withHeight(_ height: CGFloat) -> CGSize {
        return CGSize(width: width, height: height)
    }

    var isZero: Bool { return width == 0 || height == 0 }
}

class HeaderCell: UICollectionReusableView {

    static var prototype: HeaderCell = HeaderCell()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureLayout()
        backgroundColor = .orange
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayout() {
        pin(label, inset: 0)
    }

    lazy var label = UILabel()
}


class RedView: UIView {
    override init(frame: CGRect) { super.init(frame: frame); backgroundColor = .red }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("RedView.\(#function) is called with bounds \(bounds)!")
    }
}

class BlueView: UIView {
    override init(frame: CGRect) { super.init(frame: frame); backgroundColor = .blue }
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override func layoutSubviews() {
        super.layoutSubviews()
        print("BlueView.\(#function) is called with bounds \(bounds)!")
    }
}


extension Int {
    func rand() -> Int { return Int(arc4random_uniform(UInt32(self))) }
}

extension Array {
    func rand() -> Element { return self[self.count.rand()] }
}

extension ClosedRange where Bound == Int {
    func rand() -> Bound {
        return (upperBound - lowerBound).rand() + lowerBound
    }
}

extension CountableRange where Bound == Int {
    func rand() -> Bound {
        return (upperBound - lowerBound).rand() + lowerBound
    }
}

extension NSLayoutConstraint {
    func isActive(_ active: Bool) -> NSLayoutConstraint {
        self.isActive = active
        return self
    }
}


class EstimatedWidthCellsFlowLayout : UICollectionViewFlowLayout {

    override open func invalidationContext(
        forPreferredLayoutAttributes preferred: UICollectionViewLayoutAttributes,
        withOriginalAttributes original: UICollectionViewLayoutAttributes)
        -> UICollectionViewLayoutInvalidationContext {

            let context: UICollectionViewLayoutInvalidationContext = super.invalidationContext(
                forPreferredLayoutAttributes: preferred,
                withOriginalAttributes: original
            )

            let indexPath = preferred.indexPath
            if indexPath.item == 0 {
                context.invalidateSupplementaryElements(ofKind: UICollectionElementKindSectionHeader, at: [indexPath])
            }

            return context
    }
}
