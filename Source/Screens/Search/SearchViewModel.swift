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
    
    var didSelect: ((Hero) -> Void)?
    var didError: ((Error) -> Void)?
    
    // MARK: Observers
    
    let cards = PublishRelay<[HeroeCard]>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    // MARK: Private
    
    private var nextPage: Range<Int> {
        (currentResults.value.count)..<(currentResults.value.count + .searchPageSize)
    }
    
    private let currentSearch = BehaviorRelay<String?>(value: nil)
    private let currentResults = BehaviorRelay<Set<Hero>>(value: [])
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    deinit {
        if ProcessInfo.processInfo.isMemoryDeallocDebugging {
            print("😍 deinit " + String(describing: self))
        }
    }
    
    init(repo: SearchRepositoryType) {
        self.repo = repo
    }
    
    // MARK: UIViewController
    
    func viewDidLoad() {
        setBindings()

        currentSearch
            .unwrap()
            .distinctUntilChanged()
            .filter { $0.count >= .searchMinChars }
            .do(onNext: { [unowned self] _ in
                    self.isLoading.accept(true)
                    self.currentResults.accept([]) })
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .flatMapLatest { [unowned self] in
                self.search(text: $0, page: 0..<Int.searchPageSize)
            }
            .subscribe(
                onNext: { [unowned self] heroes in
                    self.isLoading.accept(false)
                    self.currentResults.accept(self.currentResults.value.union(heroes))
                },
                onError: { [unowned self] error in
                    self.isLoading.accept(false)
                    self.didError?(error)
                })
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
        search(text: text, page: nextPage)
            .subscribe(
                onSuccess: { [unowned self] heroes in
                    self.isLoading.accept(false)
                    self.currentResults.accept(self.currentResults.value.union(heroes))
                },
                onError: { [unowned self] error in
                    self.isLoading.accept(false)
                    self.didError?(error)
                })
            .disposed(by: bag)
    }
    
    private func search(text: String, page: Range<Int>) -> Single<[Hero]> {
        repo.fetchHeroes(search: text, page: page)
    }
    
    // MARK: Presentation Logic
    
    private func setBindings() {
        currentResults
            .skip(1) // initial empty results
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .background))
            .observeOn(MainScheduler.instance)
            .map { $0.sorted { $0.name < $1.name } }
            .map { $0.map(HeroeCard.init) }
            .bind(to: cards)
            .disposed(by: bag)
    }
}



extension Int {
    static var searchPageSize: Int {
        10
    }
    
    static var searchMinChars: Int {
        2
    }
}
