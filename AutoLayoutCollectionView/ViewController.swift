//
//  ViewController.swift
//  Rotating_FullHeight_FullWidth_CollectionCells
//
//  Created by Chris Conover on 6/7/18.
//  Copyright © 2018 Test. All rights reserved.
//

import UIKit

class App {
    static let constraintHeightController = ExpandingCollectionViewController()
    static let estimatedWidthController = EstimatedWidthCollectionViewController()
    static let expandingCellController = ExpandingCollectionViewController()
    static let expandingCellControllerThresholdTest = ExpandingCollectionViewControllerTestThreshold()
    static let calcalatedSizeController = CalculatedSizeCollectionViewController()

    static func flipTo(controller: UIViewController) {
        let app = UIApplication.shared.delegate as! AppDelegate
        UIView.transition(
            with: app.window!,
            duration: 1.0,
            options: .transitionFlipFromRight,
            animations: { app.window?.rootViewController = controller },
            completion: { complete in })
    }
}


class BaseController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let safe = view.safeAreaInsets
        view.pin(header, to: .topMargin)
        view.pin(header, to: .left, .right)
        view.pin(body, to: .right, .left, .bottom)
        body.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
    }

    lazy var header: UIView = {
        let header = UIView()
        let stack = UIStackView(arrangedSubviews: [insert, remove])
        stack.spacing = 8
        stack.distribution = .fillEqually
        stack.axis = .horizontal
        header.pin(stack, inset: 8)
        return header
    }()

    lazy var insert: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Insert", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(onInsert(sender:)), for: .touchUpInside)
        return button
    }()

    lazy var remove: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.setContentHuggingPriority(.required, for: .vertical)
        button.setContentCompressionResistancePriority(.required, for: .vertical)
        button.addTarget(self, action: #selector(onDelete(sender:)), for: .touchUpInside)
        return button
    }()

    let body = UIView()

    @objc func onInsert(sender: UIButton) {
        restore()
    }

    @objc func onDelete(sender: UIButton) {
        guard let _ = data.first else { return }
        let section = (0 ..< min(data.count, 2)).rand()
        let item = (0 ..< data[section].count).rand()
        delete(IndexPath(item: item, section: section))
    }

    func restore() {
        guard let restore = deleted.last else { return }
        data[0] = [restore] + data[0]
        collectionView.performBatchUpdates(
            { [unowned self] in
                self.collectionView.insertItems(at: [IndexPath(item: 0, section: 0)])
            },
            completion: { completed in print("Done") })
    }

    func delete(_ path: IndexPath) {
        print("removing item at \(path)")
        let sectionCount = data[path.section].count

        deleted.append(data[path.section][path.item])

        let leading = data[0..<path.section]
        let stripFrom = data[path.section]
        let stripped = stripFrom[0..<path.item] + stripFrom[path.item + 1 ..< stripFrom.count]
        let trailing = data[path.section + 1 ..< data.count]
        let after = (Array(leading) + [Array(stripped)] + Array(trailing)).filter { $0.count > 0 }
        data = after

        collectionView.performBatchUpdates({ [unowned self] in
            if sectionCount == 1 {
                self.collectionView.deleteSections([path.section])
            }
            else {
                self.collectionView.deleteItems(at: [path])
            }
            }, completion: { completed in
                print("Done")
        })
    }


    var deleted: [String] = []
    var collectionView: UICollectionView!
    lazy var data:[[String]] = source
    lazy var source:[[String]] = (0..<3).map{ _ in
        (0..<2).map({ _ in
            let from = (Data.ipsumSentences.count - 3).rand()
            let str: String = Data.ipsumSentences[from ..< from + 3].joined(separator: ". ")
            return str
        })}
    var deletions: [IndexPath] = []
}


class ViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

//        view.pin(RedView(), to: .left, .topMargin, .right, .bottom)

        App.calcalatedSizeController.tabBarItem = UITabBarItem(title: "Calculated", image: nil, tag: 1)
        App.estimatedWidthController.tabBarItem = UITabBarItem(title: "Estimated", image: nil, tag: 2)
        App.expandingCellController.tabBarItem = UITabBarItem(title: "Expanding", image: nil, tag: 3)
        App.expandingCellControllerThresholdTest.tabBarItem = UITabBarItem(title: "Threshold", image: nil, tag: 4)
        App.constraintHeightController.tabBarItem = UITabBarItem(title: "Height", image: nil, tag: 5)

        self.viewControllers = [
            App.estimatedWidthController,
            App.calcalatedSizeController,
            App.expandingCellController,
            App.expandingCellControllerThresholdTest,
            App.constraintHeightController
        ]
    }
}
