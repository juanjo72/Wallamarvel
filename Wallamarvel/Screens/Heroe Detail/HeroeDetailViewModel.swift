//
//  HeroeDetailViewModel.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import RxSwift
import RxCocoa
import WallamarvelKit

final class HeroeDetailViewModel {
    
    let repo: HeroeDetailRespositoryType
    
    var didError: ((Error) -> Void)?
    
    let card = PublishRelay<HeroeDetailCard>()
    
    private let heroe = BehaviorRelay<Heroe?>(value: nil)
    private let bag = DisposeBag()
    
    init(repo: HeroeDetailRespositoryType) {
        self.repo = repo
    }
    
    func viewDidLoad() {
        setPresentationLogic()
        fetchDetail()
            .subscribe()
            .disposed(by: bag)
    }
    
    private func fetchDetail() -> Completable {
        Completable.create { [unowned self] observer in
            self.repo.fetchDetail()
                .subscribe(
                    onSuccess: { [unowned self] heroe in
                        self.heroe.accept(heroe)
                        observer(.completed)
                    },
                    onError: { [unowned self] error in
                        self.didError?(error)
                        observer(.completed)
                    })
        }
    }
    
    private func setPresentationLogic() {
        heroe
            .unwrap()
            .map(HeroeDetailCard.init)
            .bind(to: card)
            .disposed(by: bag)
    }
}

struct HeroeDetailCard {
    let id: Int
    let name: String
    let url: URL?
    let about: String?
}

extension HeroeDetailCard {
    init(heroe: Heroe) {
        self.id = heroe.id
        self.name = heroe.name
        self.url = heroe.thumbURL
        self.about = heroe.about
    }
}
