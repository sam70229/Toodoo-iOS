//
//  TDListView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import SnapKit


class TDListView: UIView {
    let stackView: TDStackView = {
        let stackView = TDStackView()
        stackView.axis = .vertical
        return stackView
    }()
    
    /// Scroll view contains stack view
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
    }
    
    private func setupConstraints() {
        [scrollView, contentView, stackView].forEach { $0?.translatesAutoresizingMaskIntoConstraints = false }
        
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { maker in
            maker.top.equalTo(contentView.layoutMarginsGuide.snp.top)
            maker.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom)
            maker.trailing.equalTo(contentView.snp.trailing)
            maker.leading.equalTo(contentView.snp.leading)
        }
        
    }
}
