//
//  ConstraintWidthCollectionController.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class ConstraintWidthController: BaseController, UICollectionViewDataSource, UICollectionViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .lightGray
        title = "Constraint"

        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConstraintWidthCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(
            HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "Header")
        body.pin(collectionView)

        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return data.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data[section].count
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! HeaderCell
        header.label.text = "Section \(indexPath.section + 1)"
        return header
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! ConstraintWidthCell
        cell.label.text = data[indexPath.section][indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delete(indexPath)
    }

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = EstimatedWidthCellsFlowLayout()
        layout.headerReferenceSize = .init(width: view.bounds.size.width, height: 30)
        layout.estimatedItemSize = CGSize(width: 10, height: 10)
        layout.scrollDirection = .vertical
        return layout
    }()
}

