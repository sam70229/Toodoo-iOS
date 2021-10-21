//
//  CategoryView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/13.
//

import Foundation
import UIKit
import SnapKit


class CategoryView: UIView {
    
    var viewModel: CategoryViewModel! {
        didSet {
            title.text = viewModel.title
            self.trailingView.button.setTitle(viewModel.helperButtonTitle, for: .normal)
        }
    }
    
    init() {
        super.init(frame: .zero)
        setup()
        debugUI()
    }
    
    lazy var cardBackground: TDCardView = {
        let cardBackgound = TDCardView()
        return cardBackgound
    }()
    
    lazy var title: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var trailingView: TDHelperView = {
        let trailingView = TDHelperView()
        trailingView.isHidden = true
        trailingView.alpha = 0
        trailingView.button.setTitle("CategoryView_trailing_delete_title".localized, for: .normal)
        return trailingView
    }()
    
    lazy var panGesture = UIPanGestureRecognizer()
    
    lazy var tapGesture = UITapGestureRecognizer()
    
    lazy var categoryCountLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(cardBackground)
        
        [title, categoryCountLabel].forEach { cardBackground.contentView.addSubview($0) }
        
        addSubview(trailingView)
        sendSubviewToBack(trailingView)
        
        self.cardBackground.addGestureRecognizer(panGesture)
        self.cardBackground.addGestureRecognizer(tapGesture)
    }
    
    private func setupConstraints() {
        trailingView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(0)
            maker.trailing.equalToSuperview().inset(4)
            maker.bottom.equalToSuperview().inset(0)
            maker.width.equalTo(UIScreen.main.bounds.width / 4 - 8)
        }
        
        title.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().inset(16)
        }
        
        categoryCountLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().inset(16)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        cardBackground.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview().inset(4)
            maker.leading.equalToSuperview().inset(4)
            maker.bottom.equalToSuperview()
            maker.height.equalTo(UIScreen.main.bounds.height / 16)
        }
    }
    
    private func debugUI() {
        cardBackground.subviews.forEach { $0.layer.borderWidth = 2; $0.layer.borderColor = UIColor.random.cgColor }
//        cardBackground.contentView.subviews.forEach { $0.layer.borderWidth = 2; $0.layer.borderColor = UIColor.random.cgColor }
    }
    
    func config(category: String, count: Int) {
        title.text = category
        categoryCountLabel.text = "\(count)"
        if title.text == "CategoryView_system_recently_deleted".localized {
            self.trailingView.button.setTitle("CategoryView_recently_delete_trailing_title".localized, for: .normal)
        }
    }
}
