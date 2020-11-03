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
        setBindings()
        viewModel.viewDidLoad()
    }
    
    // MARK: Private
    
    private func setBindings() {
        viewModel.cards
            .debug("cards")
            .subscribe()
            .disposed(by: bag)
    }
}
