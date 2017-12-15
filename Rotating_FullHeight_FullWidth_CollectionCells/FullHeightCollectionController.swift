import UIKit

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

extension UIView {
    func pin(_ inner:UIView, constant: CGFloat) {
        addSubview(inner)
        inner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inner.leadingAnchor.constraint(equalTo: leadingAnchor, constant: constant),
            trailingAnchor.constraint(equalTo: inner.trailingAnchor, constant: constant),
            inner.topAnchor.constraint(equalTo: topAnchor, constant: constant),
            bottomAnchor.constraint(equalTo: inner.bottomAnchor, constant: constant) ])
    }
}

class CollectionCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {

        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .white
        contentView.pin(red, constant: 0)
    }

    lazy var red: UIView = {
        let view = RedView()
        view.pin(blue, constant: 5)
        return view
    }()

    lazy var blue: UIView = {
        let view = BlueView()
        view.pin(label, constant: 0)
        return view
    }()

    let label = UILabel()

    override func updateConstraints() {
        height.constant = bounds.size.height
        super.updateConstraints()
    }

    lazy var height: NSLayoutConstraint = {
        return contentView.heightAnchor.constraint(equalToConstant: bounds.size.height)
            .isActive(true) }()

    override func systemLayoutSizeFitting(
        _ targetSize: CGSize, withHorizontalFittingPriority
        horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority) -> CGSize {

        let size = contentView.systemLayoutSizeFitting(
            CGSize(width: 1000, height: targetSize.height),
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: .required)

        let adjusted = CGSize(width: size.width, height: max(size.height, targetSize.height))
        print("\(#function) \(#line) \(targetSize) -> \(size) -> \(adjusted)")
        return size
    }
}


class FullHeightCollectionController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        view.backgroundColor = .lightGray

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.backgroundColor = .red
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            collectionView.heightAnchor.constraint(equalToConstant: 60)
            ])
        collectionView.register(CollectionCell.self, forCellWithReuseIdentifier: "Cell")
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

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            as! CollectionCell
        cell.label.text = data[indexPath.section][indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let window = (UIApplication.shared.delegate as! AppDelegate).window
        window?.rootViewController = FullWidthCollectionViewController()
    }

    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: CGRect(), collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 1, height: 60)
        layout.scrollDirection = .horizontal
        return layout
    }()

    var data:[[String]] = (0..<1).map({ _ in (0..<10).map({ _ in
        let str: String = Data.ipsumWords.rand()
        return str

    }) })
}




