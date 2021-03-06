//
//  SearchResultsController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import SnapKit
import RxSwift
import RxCocoa
import RxKeyboard

final class SearchController: UIViewController, UISearchResultsUpdating {
    
    // MARK: Injected
    
    let viewModel: SearchViewModel
    
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
    
    private var numColumns: Int {
        traitCollection.horizontalSizeClass == .compact ? 1 : 2
    }
    
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        tileView.layout.numColumns = numColumns
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
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [unowned self] keyboardVisibleHeight in
                var customInsets = self.additionalSafeAreaInsets
                customInsets.bottom = keyboardVisibleHeight - (self.view.window?.safeAreaInsets.bottom ?? 0)
                self.additionalSafeAreaInsets = customInsets
            })
            .disposed(by: bag)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text else { return }
        viewModel.userDidType(search: search)
    }
}

extension SearchController: ImageTransitionController {
    var transitionImageView: UIImageView? {
        guard let selected = tileView.collectionView.indexPathsForSelectedItems?.first,
              let cell = tileView.collectionView.cellForItem(at: selected) as? ImageCell else { return nil }
        return cell.imageView
    }
}
