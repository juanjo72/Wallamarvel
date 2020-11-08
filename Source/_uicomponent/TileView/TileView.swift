//
//  MosaicViewController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import SnapKit
import RxSwift
import RxCocoa
import RxDataSources

protocol Identifiable: Hashable {
    var uniqueIdentifier: String { get }
}

typealias TileViewRepresantable = RxDataSources.IdentifiableType & Identifiable & CollectionViewCellDescriptable

final class TileView<Item: TileViewRepresantable>: UIView {
    
    // Interaction Callbacks
    
    var didSelectItem: ((Item) -> Void)?
    var willDisplayLastItem : ((IndexPath) -> Void)?
    
    lazy var sectionedDataSource: RxCollectionViewSectionedAnimatedDataSource<AnimatableSection<Item>> = {
        let configuration = AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .bottom)
        let source = RxCollectionViewSectionedAnimatedDataSource<AnimatableSection<Item>>(animationConfiguration: configuration, configureCell: { (dataSource, collectionView, index, item) -> UICollectionViewCell in
            collectionView.register(item.cellDescriptor.cellClass, forCellWithReuseIdentifier: item.cellDescriptor.reuseIdentifier)
            if !self.reuseIdentifiers.contains(item.cellDescriptor.reuseIdentifier) {
                collectionView.register(item.cellDescriptor.cellClass, forCellWithReuseIdentifier: item.cellDescriptor.reuseIdentifier)
                self.reuseIdentifiers.insert(item.cellDescriptor.reuseIdentifier)
            }
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: item.cellDescriptor.reuseIdentifier, for: index)
            item.cellDescriptor.configure(cell)
            return cell
        })
        return source
    }()
    
    var layout: TileViewLayout
    
    lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.layoutMargins = .zero
        view.backgroundColor = nil
        view.clipsToBounds = false
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.rx.itemSelected
            .subscribe(onNext: { [unowned self] index in
                self.didSelectItem?(self.sectionedDataSource[index])
            })
            .disposed(by: bag)
        view.rx.willDisplayCell
            .map { $0.at }
            .subscribe(onNext: { [unowned self] index in
                guard index.row == self.items.count - 1 else { return }
                self.willDisplayLastItem?(index)
            })
            .disposed(by: bag)
        return view
    }()
    
    // MARK: Public
    
    var items: [Item] {
        set {
            itemsObservable.accept(newValue)
        }
        get {
            return sectionedDataSource.sectionModels.first?.items ?? []
        }
    }
    
    // MARK: Private
    
    private var reuseIdentifiers = Set<String>()
    private let itemsObservable = PublishRelay<[Item]>()
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(numColumns: Int) {
        self.layout = TileViewLayout(numColumns: numColumns)
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIView
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: layout.collectionViewContentSize.width, height: UIView.noIntrinsicMetric)
    }
    
    override func safeAreaInsetsDidChange() {
        super.safeAreaInsetsDidChange()
    }
    
    // MARK: Private
    
    private func configure() {
        layoutMargins = .zero
        preservesSuperviewLayoutMargins = true
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        itemsObservable
            .map { AnimatableSection(items: $0) }
            .map { [$0] }
            .bind(to: collectionView.rx.items(dataSource: sectionedDataSource))
            .disposed(by: bag)
    }
}
