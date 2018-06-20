//
//  CalculatedSizeCollectionController.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit


class CalculatedSizeCollectionViewController<Cell>: BaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
 where Cell:UICollectionViewCell, Cell:TextCell {

    init(_ title: String) {
        super.init()
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .yellow

        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .cyan
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(Cell.self, forCellWithReuseIdentifier: "Cell")
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
        var cell = Cell.prototype
        let contents = data[indexPath.section][indexPath.item]
        cell.text = contents
        cell.expand = selected.contains(indexPath)

        let width = collectionView.bounds
            .inset(collectionView.contentInset)
            .inset(layout.sectionInset)
            .width
        let finalSize = cell.systemLayoutSizeFitting(
            .init(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel)
            .withWidth(width)
        print("sizeForItemAt: \(finalSize)")
        return finalSize
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! Cell
        let contents = data[indexPath.section][indexPath.item]
        cell.text = contents
        cell.onDrag = { [unowned self] in
            self.delete(indexPath)
        }
        return cell
    }

    var selected = Set<IndexPath>()

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(indexPath)")

        var cell = collectionView.cellForItem(at: indexPath) as! Cell
        cell.expand = !cell.expand
        if cell.expand { selected.insert(indexPath) }
        else { selected.remove(indexPath) }

        UIView.animate(withDuration: 0.25, animations: {
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
        })
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
