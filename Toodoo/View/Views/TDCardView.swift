//
//  TDCardView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import SnapKit

class TDCardView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let contentView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = view.traitCollection.userInterfaceStyle == .dark ? .secondarySystemBackground : .systemBackground
        return view
    }()
    
    private func setupView() {
        addSubview(contentView)
    }
    
    private func setupConstraints() {
        contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
    }
    
    private func debugUI() {
        self.contentView.layer.borderWidth = 2
        self.contentView.layer.borderColor = UIColor.red.cgColor
    }
    
}
