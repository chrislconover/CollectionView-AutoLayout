//
//  CalculatedSizeCollectionController.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class CalculatedSizeCollectionViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        view.backgroundColor = .yellow
        title = "Calculated"

        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .cyan
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(SimpleCalculatedSizeCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(HeaderCell.self,
                                forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
                                withReuseIdentifier: "Header")
        body.pin(collectionView)

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        print("\(#function): \(view.bounds)")
        super.viewWillAppear(animated)
    }

    override func viewDidLayoutSubviews() {
        print("\(#function): \(view.bounds)")
        super.viewDidLayoutSubviews()
    }

    override func viewDidAppear(_ animated: Bool) {
        print("\(#function): \(view.bounds), screen is: \(UIScreen.main.bounds)")
        super.viewDidAppear(animated)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = data[section].count
        return count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCell
        header.label.text = "Section \(indexPath.section + 1)"
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cell = SimpleCalculatedSizeCell.prototype
        let contents = data[indexPath.section][indexPath.item]
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
//        print("\(#function): \(finalSize)")
        return finalSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! SimpleCalculatedSizeCell
        let contents = data[indexPath.section][indexPath.item]
        cell.label.text = contents
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(indexPath)")
        delete(indexPath)
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
}
