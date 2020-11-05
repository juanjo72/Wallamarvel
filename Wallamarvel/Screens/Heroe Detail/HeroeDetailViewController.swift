//
//  HeroeDetailViewController.swift
//  Wallamarvel
//
//  Created by Juanjo García Villaescusa on 04/11/2020.
//

import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

final class HeroeDetailViewController: UIViewController {
    
    // MARK: Lifecycle
    
    let viewModel: HeroeDetailViewModel
    
    // MARK: UI
    
    lazy var masterScroll: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        scroll.addSubview(masterStack)
        masterStack.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
            maker.width.equalToSuperview()
        }
        return scroll
    }()
    
    lazy var masterStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: .doubleSpace, right: 0)
        stack.spacing = .space * 3
        stack.addArrangedSubview(imageView)
        stack.addArrangedSubview(body)
        return stack
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.layoutMargins = UIEdgeInsets(top: .doubleSpace, left: .doubleSpace, bottom: .doubleSpace, right: .doubleSpace)
        view.insetsLayoutMarginsFromSafeArea = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.snp.makeConstraints { maker in
            maker.width.equalTo(view.snp.height)
        }
        return view
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        let defaultBody = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.font = UIFont.systemFont(ofSize: defaultBody.pointSize * 2, weight: .heavy)
        label.textAlignment = .right
        label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        label.numberOfLines = 0
        label.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.lineBreakMode = .byWordWrapping
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var body: UITextView = {
        let view = UITextView()
        view.backgroundColor = UIColor.clear
        view.isScrollEnabled = false
        view.isEditable = false
        let defaultBody = UIFont.preferredFont(forTextStyle: .body)
        view.font = UIFont.systemFont(ofSize: defaultBody.pointSize * 1.3, weight: .light)
        return view
    }()
    
    // MARK: Private
    
    private let bag = DisposeBag()
    
    // MARK: Lifecycle
    
    init(viewModel: HeroeDetailViewModel) {
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
    
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
        body.textContainerInset = UIEdgeInsets(top: 0, left: view.layoutMargins.left, bottom: 0, right: view.layoutMargins.right)
    }
    
    // MARK: Private
    
    private func configure() {
        view.backgroundColor = #colorLiteral(red: 0.9729215994, green: 1, blue: 0.9079826302, alpha: 1)
        
        view.addSubview(masterScroll)
        masterScroll.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        masterStack.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(imageView.snp.leadingMargin)
            maker.trailing.equalTo(imageView.snp.trailingMargin)
            maker.bottom.equalTo(imageView.snp.bottomMargin)
        }
        
        view.layoutMargins = UIEdgeInsets(top: 0, left: .doubleSpace, bottom: 0, right: .space)
    }
    
    private func setBindings() {
        viewModel.card
            .map { $0.url }
            .subscribe(onNext: { [unowned self] url in
                self.imageView.kf.setImage(with: url)
            })
            .disposed(by: bag)
        viewModel.card
            .map { $0.name }
            .bind(to: nameLabel.rx.text)
            .disposed(by: bag)
        viewModel.card
            .map { $0.about }
            .debug()
            .bind(to: body.rx.text)
            .disposed(by: bag)
    }
}

extension CGFloat {
    static var space: CGFloat {
        12
    }
    
    static var doubleSpace: CGFloat {
        24
    }
}
