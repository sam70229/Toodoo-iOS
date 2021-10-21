//
//  TDHelperView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import SnapKit

class TDHelperView: UIView {
    
    lazy var background = TDCardView()
    
    lazy var stackView = TDStackView.horizontal()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setup() {
        addSubviews()
        setupConstraints()
    }
    
    private func addSubviews() {
        addSubview(background)
        background.contentView.addSubview(stackView)
        stackView.addArrangedSubview(button)
    }
    
    private func setupConstraints() {
        background.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
}
