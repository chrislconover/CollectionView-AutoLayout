//
//  Layout.swift
//  AutoLayoutCollectionView
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

extension UIView {
    @discardableResult
    func pin(_ view: UIView, to attribute: NSLayoutAttribute, inset: CGFloat = 0.0) -> NSLayoutConstraint {

        let constraint: NSLayoutConstraint
        if view.superview == nil {
            addSubview(view)
        }
        view.translatesAutoresizingMaskIntoConstraints = false

        switch attribute {

        // left / leading
        case .left:
            constraint = view.leftAnchor.constraint(equalTo: self.leftAnchor, constant: inset)
        case .leftMargin:
            constraint = view.leftAnchor.constraint(
                equalTo: self.layoutMarginsGuide.leftAnchor, constant: inset)

        case .leading:
            constraint = view.leadingAnchor.constraint(
                equalTo: self.leadingAnchor, constant: inset)
        case .leadingMargin:
            constraint = view.leadingAnchor.constraint(
                equalTo: self.layoutMarginsGuide.leadingAnchor, constant: inset)

        // right / trailing
        case .right:
            constraint = self.rightAnchor.constraint(equalTo: view.rightAnchor, constant: inset)
        case .rightMargin:
            constraint = self.rightAnchor.constraint(
                equalTo: view.layoutMarginsGuide.rightAnchor, constant: inset)

        case .trailing:
            constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: inset)
        case .trailingMargin:
            constraint = self.trailingAnchor.constraint(
                equalTo: view.layoutMarginsGuide.trailingAnchor, constant: inset)

        // top
        case .top:
            constraint = view.topAnchor.constraint(equalTo: self.topAnchor, constant: inset)
        case .topMargin:
            constraint = view.topAnchor.constraint(
                equalTo: self.layoutMarginsGuide.topAnchor, constant: inset)

        // bottom
        case .bottom:
            constraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: inset)
        case .bottomMargin:
            constraint = self.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor, constant: inset)

        // center x
        case .centerX:
            constraint = view.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: inset)
        case .centerXWithinMargins:
            constraint = view.layoutMarginsGuide.centerXAnchor.constraint(
                equalTo: self.layoutMarginsGuide.centerXAnchor, constant: inset)

        // center y
        case .centerY:
            constraint = view.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: inset)
        case .centerYWithinMargins:
            constraint = view.layoutMarginsGuide.centerYAnchor.constraint(
                equalTo: self.layoutMarginsGuide.centerYAnchor, constant: inset)

        // alignment
        case .firstBaseline:
            constraint = self.firstBaselineAnchor.constraint(
                equalTo: view.firstBaselineAnchor, constant: inset)
        case .lastBaseline:
            constraint = self.lastBaselineAnchor.constraint(
                equalTo: view.lastBaselineAnchor, constant: inset)

        // dimensional
        case .width:
            constraint = view.widthAnchor.constraint(
                equalTo: self.widthAnchor, multiplier: 1.0, constant: inset)
        case .height:
            constraint = view.heightAnchor.constraint(
                equalTo: self.heightAnchor, multiplier: 1.0, constant: inset)

        case .notAnAttribute:
            assert(false)
            fatalError("Cannot pin to 'notAnAttribute'")
        }

        constraint.isActive = true
        return constraint
    }


    @discardableResult
    public func pin(_ view: UIView, to constraints: NSLayoutAttribute..., inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return pin(view, to: constraints, inset: inset)
    }

    @discardableResult
    public func pin<T>(_ view: UIView, to constraints: T, inset: CGFloat = 0) -> [NSLayoutConstraint]
        where T: Collection, T.Element == NSLayoutAttribute {
            return constraints.map { pin(view, to: $0, inset: inset) }
    }

    @discardableResult
    public func pin(_ view: UIView, inset: CGFloat = 0) -> [NSLayoutConstraint] {
        return pin(view, to: .left, .right, .top, .bottom, inset: inset)
    }

    @discardableResult
    public func pinToMargins(_ view: UIView) -> [NSLayoutConstraint] {
        return pin(view, to: .leftMargin, .rightMargin, .topMargin, .bottomMargin)
    }
}



extension UICollectionView {

    var contentBounds: CGRect {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
            else { return bounds.inset(contentInset) }
        return bounds
            .inset(contentInset)
            .inset(flowLayout.sectionInset)
    }

//    var adjustedContentSize: CGSize {
//        let sectionInset = (collectionViewLayout as? UICollectionViewFlowLayout)
//            .flatMap { $0.sectionInset } ?? UIEdgeInsets()
//        return self.bounds.size
//            .inset(self.contentInset)
//            .inset(sectionInset)
//    }

    var contentWidth: CGFloat {
        let flowInset = (collectionViewLayout as? UICollectionViewFlowLayout)
            .flatMap { $0.sectionInset.left + $0.sectionInset.right } ?? 0
        return self.bounds.size.width
            - (contentInset.left + contentInset.right)
            - flowInset
    }

    var contentHeight: CGFloat {
        let flowInset = (collectionViewLayout as? UICollectionViewFlowLayout)
            .flatMap { $0.sectionInset.top + $0.sectionInset.bottom } ?? 0
        return self.bounds.size.height
            - (contentInset.top + contentInset.bottom)
            - flowInset
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
