//
//  LandingControllerViewModel.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import RxSwift
import RxCocoa
import WallamarvelKit

final class HeroesViewModel {
    
    // MARK: Injected
    
    let repo: HeroesRepositoryType
    
    // MARK: External Actions
    
    var didError: ((Error) -> Void)?
    var didSelect: ((Hero) -> Void)?
    
    // MARK: Observables
    
    let cards = PublishRelay<[HeroeCard]>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Private
    
    private var nextPageToFetch: Range<Int> {
        (allHeroes.value.count)..<(allHeroes.value.count + .listPageSize)
    }
    
    private let allHeroes = BehaviorRelay<Set<Hero>>(value: []) // model
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    deinit {
        if ProcessInfo.processInfo.isMemoryDeallocDebugging {
            print("😍 deinit " + String(describing: self))
        }
    }
    
    init(repo: HeroesRepositoryType) {
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
        isLoading.accept(true)
        fetchAllHeroes(page: nextPageToFetch)
            .subscribe(
                onCompleted: { [unowned self] in self.isLoading.accept(false) },
                onError: { [unowned self] _ in self.isLoading.accept(false)} )
            .disposed(by: bag)
    }
    
    private func fetchAllHeroes(page: Range<Int>) -> Completable {
        Completable.create { [unowned self] observer in
            self.repo.fetchHeroes(page: page)
                .subscribe(
                    onSuccess: { [weak self] values in
                        guard let strongSelf = self else { return }
                        strongSelf.allHeroes.accept(strongSelf.allHeroes.value.union(values))
                        observer(.completed)
                    },
                    onError: { [weak self] in
                        self?.didError?($0)
                        observer(.error($0))
                    })
        }
    }
    
    // MARK: Presentation Logic
    
    private func setPresentaionLogic() {
        allHeroes
            .skip(1)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map { $0.sorted { $0.name < $1.name }}
            .map { $0.map(HeroeCard.init) }
            .bind(to: cards)
            .disposed(by: bag)
    }
}

extension Int {
    static var listPageSize: Int {
        50
    }
}
