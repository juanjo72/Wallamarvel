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
    
    lazy var tileView: TileView<HeroesViewModel.HeroeCard> = {
        let configuration = TileViewConfiguration(numColumns: 2)
        let view = TileView<HeroesViewModel.HeroeCard>(configuration: configuration)
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
        vc.obscuresBackgroundDuringPresentation = true
        return vc
    }()
    
    lazy var resultsController: SearchController = {
        let vc = SearchController(viewModel: resultsViewModel)
        return vc
    }()
    
    // MARK: Private
    
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
    
    // MARK: Private
    
    private func configuration() {
        view.backgroundColor = UIColor.white
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        view.addSubview(tileView)
        tileView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func setBindings() {
        viewModel.cards
            .bind(to: tileView.rx.cards)
            .disposed(by: bag)
    }
}

extension Reactive where Base == TileView<HeroesViewModel.HeroeCard> {
    var cards: Binder<[HeroesViewModel.HeroeCard]> {
        Binder(base) { view, items in
            view.items = items
        }
    }
}
