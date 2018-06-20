//
//  ExpandingCollectionView.swift
//  AutoLayoutCollectionView
//
//  Created by Chris Conover on 6/13/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class ExpandingCollectionViewControllerTestThreshold: UIViewController {

    override func viewDidLoad() {

        super.viewDidLoad()
        view.backgroundColor = .yellow
        title = "Threshold"

        
        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .cyan
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SimpleCalculatedSizeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: "Header")
        view.pin(collectionView)
    }

    // MARK: rotation

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        layout.invalidateLayout()
        super.traitCollectionDidChange(previousTraitCollection)
    }

    // MARK: layout - set estimated width to collection view width (minus content inset etc)
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let width = view.bounds.size.width
        layout.headerReferenceSize = .init(width: view.bounds.size.width, height: 30)
        layout.scrollDirection = .vertical
        return layout
    }()

    var selected: IndexPath! = nil
    let data = ["Apple", "Banana", "Orange", "Grapefruit"]
    var collectionView: UICollectionView!
}


extension ExpandingCollectionViewControllerTestThreshold: UICollectionViewDelegateFlowLayout {



    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = SimpleCalculatedSizeCell.prototype
        let contents = data[indexPath.item]
        cell.label.text = contents
        let width = collectionView.bounds
            .inset(collectionView.contentInset)
            .inset(layout.sectionInset)
            .width
        let finalSize = cell.systemLayoutSizeFitting(
            .init(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
            .withWidth(width)

        if let selected = selected, selected == indexPath {
            print("\(#function): \(finalSize)")
            return finalSize.withHeight(150)
        }

        print("\(#function): \(finalSize)")
        return finalSize.withHeight(CGFloat(73 + indexPath.item))
    }

    func collectionView2(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = SimpleCalculatedSizeCell.prototype
        let contents = data[indexPath.item]
        cell.label.text = contents
        let width = collectionView.contentBounds.size.width
        let fittedSize = cell.systemLayoutSizeFitting(
            .init(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
            .withWidth(width)

        if indexPath == self.selected {
            return fittedSize.withHeight(fittedSize.height + 100)
        }

        return fittedSize
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selected = selected == indexPath ? nil : indexPath

        UIView.animate(withDuration: 0.25, animations: {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
        })
    }
}


extension ExpandingCollectionViewControllerTestThreshold: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = data.count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCell
        header.label.text = "Section \(indexPath.section + 1)"
        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! SimpleCalculatedSizeCell
        let contents = data[indexPath.item]
        cell.label.text = "\(indexPath.item + 73 >= 75 ? "Smooth" : "Fades") (\(indexPath.item + 73)) \(contents)"
        return cell
    }
}


