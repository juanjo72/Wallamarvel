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

final class LandingViewController: UIViewController {
    
    // MARK: Injected
    
    let viewModel: LandingViewModel
    
    // MARK: UI
    
    lazy var tileView: TileView<LandingViewModel.HeroeCard> = {
        let configuration = TileViewConfiguration(numColumns: 2)
        let view = TileView<LandingViewModel.HeroeCard>(configuration: configuration)
        view.didSelectItem = { [unowned self] item in
            self.viewModel.didSelect(item: item)
        }
        view.willDisplayLastItem = { [unowned self] _ in
            self.viewModel.collectionViewDidReachEnd()
        }
        return view
    }()
    
    // MARK: Private
    
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(viewModel: LandingViewModel) {
        self.viewModel = viewModel
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

extension Reactive where Base == TileView<LandingViewModel.HeroeCard> {
    var cards: Binder<[LandingViewModel.HeroeCard]> {
        Binder(base) { view, items in
            view.items = items
        }
    }
}
