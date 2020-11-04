//
//  LandingControllerViewModel.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import RxSwift
import RxCocoa
import WallamarvelKit

final class LandingViewModel {
    
    // MARK: Injected
    
    let repo: LandingControllerRepositoryType
    
    // MARK: External Actions
    
    var didError: ((Error) -> Void)?
    var didSelect: ((Heroe) -> Void)?
    
    // MARK: Observables
    
    let cards = PublishRelay<[HeroeCard]>()
    
    // MARK: Private
    
    private let allHeroes = BehaviorRelay<[Heroe]>(value: [])
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(repo: LandingControllerRepository) {
        self.repo = repo
    }
    
    // MARK: Interaction Logic
    
    func viewDidLoad() {
        setPresentaionLogic()
        fetchNextPage()
    }
    
    func collectionViewDidReachEnd() {
        fetchNextPage()
    }
    
    func didSelect(item: HeroeCard) {
        guard let selected = (allHeroes.value.first { $0.id == item.id }) else { return }
        didSelect?(selected)
    }
    
    // MARK: Business Logic
    
    private func fetchNextPage() {
        let page = (allHeroes.value.count)..<(allHeroes.value.count + 10)
        fetchAllHeroes(page: page)
            .subscribe()
            .disposed(by: bag)
    }
    
    private func fetchAllHeroes(page: Range<Int>) -> Completable {
        Completable.create { [unowned self] observer in
            self.repo.fetchHeroes(search: nil, page: page)
                .subscribe(
                    onSuccess: { [weak self] in
                        guard let strongSelf = self else { return }
                        strongSelf.allHeroes.accept(strongSelf.allHeroes.value + $0)
                    },
                    onError: { [weak self] in
                        self?.didError?($0)
                    })
        }
    }
    
    // MARK: Presentation Logic
    
    private func setPresentaionLogic() {
        allHeroes
            .map { $0.map(HeroeCard.init) }
            .bind(to: cards)
            .disposed(by: bag)
    }
}
