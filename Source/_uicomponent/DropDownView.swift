//
//  DropDownView.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 03/11/2020.
//

import SnapKit
import RxSwift
import RxCocoa
import RxGesture
import CoreGraphics

final class DropdownView: UIView {
    
    // MARK: Injected
    
    let autoDismissInterval: TimeInterval?
    
    // MARK: Callbacks
    
    var didDismiss: (() -> Void)?
    
    // MARK: UI
    
    lazy var masterStack: UIStackView = {
       let stack = UIStackView()
        stack.axis = .vertical
        stack.addArrangedSubview(bodyLabel)
        return stack
    }()
    
    lazy var bodyLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return label
    }()
    
    // MARK: Private properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(autoDismissInterval: TimeInterval? = nil) {
        self.autoDismissInterval = autoDismissInterval
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private
    
    private func configureUI() {
        addSubview(masterStack)
        masterStack.snp.makeConstraints { maker in
            maker.edges.equalTo(snp.margins)
        }
        
        self.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                self.slideUp() { [unowned self] in
                    self.didDismiss?()
                }
            })
            .disposed(by: disposeBag)
        self.rx.swipeGesture(.up)
            .when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                self.slideUp() { [unowned self] in
                    self.didDismiss?()
                }
            })
            .disposed(by: disposeBag)
        
        if let autoDismiss = autoDismissInterval {
            Observable<Void>.just(())
                .delay(RxTimeInterval.milliseconds(Int(autoDismiss * 1000)), scheduler: MainScheduler.instance)
                .subscribe(onNext: { [unowned self] _ in
                    self.slideUp { [unowned self] in
                        self.didDismiss?()
                    }
                })
                .disposed(by: disposeBag)
        }
    }
}

extension UIView {
    func slideDown(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.superview?.layoutIfNeeded()
        layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -bounds.height))
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: 0))
        }, completion: { completed in
            completion?()
        })
    }
    
    func slideUp(duration: TimeInterval = 0.3, completion: (() -> Void)? = nil) {
        self.superview?.layoutIfNeeded()
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.layer.setAffineTransform(CGAffineTransform(translationX: 0, y: -self.bounds.height))
        }, completion: { completed in
            completion?()
        })
    }
}
