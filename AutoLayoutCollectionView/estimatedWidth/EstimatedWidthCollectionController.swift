import UIKit

//This uses a width contstraint in the cell, configured in systemSizeFitting..., that
//usese the targetSize.width that picks up the value from the layout's estimated size
//
//This seems simple enough and seems to work, but animations do not work correctly.


class EstimatedWidthConstraintCollectionViewController: BaseController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    override init() {
        super.init()
        title = "Constraint"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .yellow

        collectionView = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        collectionView.backgroundColor = .cyan
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self

        body.pin(collectionView)
        collectionView.register(ParagraphTestCellWithWidthContraint.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(
            HeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "Header")
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(#function)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! ParagraphTestCellWithWidthContraint
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
        layout.estimatedItemSize = CGSize(width: view.bounds.size.width, height: 10)
        layout.headerReferenceSize = .init(width: view.bounds.size.width, height: 30)
        layout.invalidateLayout()
        super.traitCollectionDidChange(previousTraitCollection)
    }

    // MARK: layout - set estimated width to collection view width (minus content inset etc)
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = EstimatedWidthCellsFlowLayout()
        layout.headerReferenceSize = .init(width: view.bounds.size.width, height: 30)
        layout.scrollDirection = .vertical
        return layout
    }()
}

