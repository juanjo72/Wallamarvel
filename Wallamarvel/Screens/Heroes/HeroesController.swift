//
//  LandingViewController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

final class HeroesController: UIViewController {
    
    // MARK: Injected
    
    let viewModel: HeroesViewModel
    let resultsViewModel: SearchViewModel
    
    // MARK: UI
    
    lazy var tileView: TileView<HeroeCard> = {
        let view = TileView<HeroeCard>(numColumns: numColumns)
        view.didSelectItem = { [unowned self] item in
            self.viewModel.didSelect(item: item)
        }
        view.willDisplayLastItem = { [unowned self] _ in
            self.viewModel.collectionViewDidReachEnd()
        }
        return view
    }()
    
    lazy var searchController: UISearchController = {
        let vc = UISearchController(searchResultsController: resultsController)
        vc.searchResultsUpdater = resultsController
        return vc
    }()
    
    lazy var resultsController: SearchController = {
        SearchController(viewModel: resultsViewModel)
    }()
    
    // MARK: Private
    
    private var numColumns: Int {
        traitCollection.horizontalSizeClass == .regular ? 4 : 2
    }
    
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(viewModel: HeroesViewModel, resultsViewModel: SearchViewModel) {
        self.viewModel = viewModel
        self.resultsViewModel = resultsViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        setBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tileView.collectionView.indexPathsForSelectedItems?.forEach {
            tileView.collectionView.deselectItem(at: $0, animated: true)
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tileView.layout.numColumns = numColumns
    }
    
    // MARK: Private
    
    private func configuration() {
        view.backgroundColor = UIColor.white
        navigationItem.title = "Marvel Heroes"
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        view.addSubview(tileView)
        tileView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setBindings() {
        viewModel.cards
            .bind(to: tileView.rx.cards)
            .disposed(by: bag)
        viewModel.isLoading
            .bind(to: rx.isLoading)
            .disposed(by: bag)
    }
}

extension HeroesController: ControllerWithCustomBar {
    var navigationBarStyle: NavigationBarStyle {
        .opaque
    }
}

extension Reactive where Base == TileView<HeroeCard> {
    var cards: Binder<[HeroeCard]> {
        Binder(base) { view, items in
            view.items = items
        }
    }
}

extension HeroesController: ImageTransitionController {
    var transitionImageView: UIImageView? {
        if let selected = tileView.collectionView.indexPathsForSelectedItems?.first,
           let cell = tileView.collectionView.cellForItem(at: selected) as? ImageCell {
            return cell.imageView
        } else {
            return resultsController.transitionImageView
        }
    }
}
