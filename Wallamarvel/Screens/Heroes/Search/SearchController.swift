//
//  SearchResultsController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import SnapKit
import RxSwift
import RxCocoa

final class SearchController: UIViewController, UISearchResultsUpdating {
    
    // MARK: Injected
    
    let viewModel: SearchViewModel
    
    // MARK: UI
    
    lazy var tileView: TileView<HeroeCard> = {
        let configuration = TileViewConfiguration(numColumns: 1)
        let view = TileView<HeroeCard>(configuration: configuration)
        view.didSelectItem = { [unowned self] item in
            self.viewModel.didSelect(item: item)
        }
        view.willDisplayLastItem = { [unowned self] _ in
            self.viewModel.collectionViewDidReachEnd()
        }
        return view
    }()
    
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        setBindings()
        viewModel.viewDidLoad()
    }
    
    // MARK: Private
    
    private func configure() {
        view.backgroundColor = UIColor.white
        
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
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        viewModel.userDidType(search: search)
    }
}
