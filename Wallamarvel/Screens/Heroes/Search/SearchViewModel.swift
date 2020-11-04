//
//  SearchViewModel.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import RxSwift
import RxCocoa
import WallamarvelKit

final class SearchViewModel {
    
    // MARK: Injected
    
    let repo: SearchRepositoryType
    
    // MARK: Externak
    
    var didSelect: ((Heroe) -> Void)?
    var didError: ((Error) -> Void)?
    
    // MARK: Observers
    
    let cards = BehaviorRelay<[HeroeCard]>(value: [])
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Private
    
    private var nextPage: Range<Int> {
        (currentResults.value.count)..<(currentResults.value.count + .pageSize)
    }
    
    private let currentSearch = BehaviorRelay<String?>(value: nil)
    private let currentResults = BehaviorRelay<Set<Heroe>>(value: [])
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(repo: SearchRepositoryType) {
        self.repo = repo
    }
    
    // MARK: UIViewController
    
    func viewDidLoad() {
        setBindings()

        currentSearch
            .unwrap()
            .do(onNext: { [unowned self] _ in self.currentResults.accept([]) })
            .filter { $0.count > 3 }
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] in
                self.search(text: $0, page: 0..<Int.pageSize)
            }
            .do(onError: { [unowned self] _ in self.isLoading.accept(false) },
                onCompleted: { [unowned self] in self.isLoading.accept(false) })
            .asObservable()
            .subscribe()
            .disposed(by: bag)
    }
    
    func userDidType(search: String) {
        currentSearch.accept(search)
    }
    
    func collectionViewDidReachEnd() {
        fetchNextPage()
    }
    
    func didSelect(item: HeroeCard) {
        guard let selected = (currentResults.value.first { $0.id == item.id }) else { return }
        didSelect?(selected)
    }
    
    // MARK: Business Logic
    
    private func fetchNextPage() {
        guard let text = self.currentSearch.value else { return }
        isLoading.accept(true)
        search(text: text, page: nextPage)
            .subscribe(
                onCompleted: { [unowned self] in self.isLoading.accept(false) },
                onError: { [unowned self] _ in self.isLoading.accept(false)} )
            .disposed(by: bag)
    }
    
    private func search(text: String, page: Range<Int>) -> Completable {
        return Completable.create { [unowned self] observer in
            self.repo.fetchHeroes(search: text, page: page)
                .retry(1)
                .subscribe(
                    onSuccess: { [weak self] values in
                        guard let strongSelf = self else { return }
                        strongSelf.currentResults.accept(strongSelf.currentResults.value.union(values))
                        observer(.completed)
                    },
                    onError: { [weak self] in
                        self?.didError?($0)
                        observer(.error($0))
                    })
        }
    }
    
    // MARK: Presentation Logic
    
    private func setBindings() {
        currentResults
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map { $0.sorted { $0.name < $1.name } }
            .map { $0.map(HeroeCard.init) }
            .bind(to: cards)
            .disposed(by: bag)
        currentSearch
            .map { _ in true }
            .bind(to: isLoading)
            .disposed(by: bag)
    }
}



fileprivate extension Int {
    static var pageSize: Int {
        10
    }
}

extension RxSwift.ObservableType {
    func unwrap<Result>() -> Observable<Result> where Element == Result? {
         compactMap { $0 }
    }
}
