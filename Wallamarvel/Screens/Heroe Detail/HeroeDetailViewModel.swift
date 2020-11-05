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
    
    // MARK: Injected
    
    let repo: HeroeDetailRespositoryType
    
    // MARK: External Calls
    
    var didError: ((Error) -> Void)?
    
    // MARK: Observables

    let cover = PublishRelay<URL?>()
    let title = PublishRelay<String>()
    let about = PublishRelay<NSAttributedString?>()
    let isLoading = PublishRelay<Bool>()
    
    // MARK: Private
    
    private let heroe = BehaviorRelay<Heroe?>(value: nil)
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    deinit {
        if ProcessInfo.processInfo.isMemoryDeallocDebugging {
            print("😍 deinit " + String(describing: self))
        }
    }
    
    init(repo: HeroeDetailRespositoryType) {
        self.repo = repo
    }
    
    func viewDidLoad() {
        setPresentationLogic()
        
        isLoading.accept(true)
        fetchDetail()
            .do(onDispose: { [unowned self] in self.isLoading.accept(false) })
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
            .map { $0.thumbURL }
            .bind(to: cover)
            .disposed(by: bag)
        heroe
            .unwrap()
            .map { $0.name }
            .bind(to: title)
            .disposed(by: bag)
        heroe
            .unwrap()
            .map { $0.about?.attributedBody }
            .bind(to: about)
            .disposed(by: bag)
    }
}



fileprivate extension String {
    var attributedBody: NSAttributedString {
        let attributed = NSMutableAttributedString(string: self)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        var bodyFont = UIFont.preferredFont(forTextStyle: .body)
        bodyFont = UIFont.systemFont(ofSize: bodyFont.pointSize * 1.1, weight: .light)
        attributed.addAttribute(.font, value: bodyFont, range: NSRange(location: 0, length: description.count))
        attributed.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: description.count))
        return attributed
    }
}
