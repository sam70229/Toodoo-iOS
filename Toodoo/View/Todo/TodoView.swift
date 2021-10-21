//
//  TodoView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit
import SnapKit


/// ```
///     +---------------------------------------------------------+
///     |                                                 +-----+ |
///     | [category] | [title]                 [complete/ | cir | |
///     | [expire_date]                         total]    | cle | |
///     |                                                 +-----+ |
///     +---------------------------------------------------------+
/// ```

protocol TDTodoViewDelegate: AnyObject {
    func didTapCompleteCheckBox(_ view: TodoView, todo: TDCDTodo)
}


class TodoView: UIView {
    
    weak var delegate: TDTodoViewDelegate?
    
    var viewModel: TodoViewModel! {
        didSet {
            title.attributedText = viewModel.title
            title.textColor = viewModel.completed ? .secondaryLabel : .label
            datetime.textColor = viewModel.completed ? .secondaryLabel : .label
            completeSubTaskLabel.textColor = viewModel.completed ? .secondaryLabel : .label
            datetime.text = viewModel.expiredDate
            completedCheckBox.isSelected = viewModel.completed
            completeSubTaskLabel.text = viewModel.completeSubtaskRateText
            ringIcon.isHidden = !viewModel.showRemindComponent
            remindLabel.isHidden = !viewModel.showRemindComponent
            remindLabel.text = viewModel.remindText
        }
    }
    
    init(viewModel: TodoViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupViews()
        setupConstrains()
        setupGesture()
//        self.config(viewModel: viewModel)
//        debugUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let panGesture = UIPanGestureRecognizer()
    
    var isExpanded = false
    
    lazy var trailingView: TDHelperView = {
        let trailingView = TDHelperView()
        trailingView.isHidden = true
        trailingView.alpha = 0
        trailingView.button.setTitle("TodoView_trailing_delete_btn".localized, for: .normal)
        return trailingView
    }()
    
    lazy var leadingView: TDHelperView = {
        let leadingView = TDHelperView()
        leadingView.isHidden = true
        leadingView.alpha = 0
        leadingView.button.setTitle("TodoView_leading_edit_btn".localized, for: .normal)
        return leadingView
    }()
    
    lazy var shadowView: TDCardView = {
        let shadow = TDCardView()
        shadow.contentView.layer.shadowColor = getShadowColor(self).cgColor
        shadow.contentView.layer.shadowOpacity = 1
        shadow.contentView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadow.contentView.layer.shadowRadius = 0
        return shadow
    }()
    lazy var shadowView2: TDCardView = {
        let shadow = TDCardView()
        shadow.contentView.layer.shadowColor = getShadowColor(self).cgColor
        shadow.contentView.layer.shadowOpacity = 1
        shadow.contentView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        shadow.contentView.layer.shadowRadius = 0
        return shadow
    }()
    
    lazy var tapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer()
        return tapGesture
    }()
    
    lazy var cardBackground: TDCardView = {
        let card = TDCardView()
        card.translatesAutoresizingMaskIntoConstraints = false
        card.contentView.layer.shadowColor = getShadowColor(self).cgColor
        card.contentView.layer.shadowOpacity = 1
        card.contentView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        card.contentView.layer.shadowRadius = 0
        return card
    }()
    
    lazy var title: UILabel = {
        let textView = UILabel()
        textView.text = "Test Title"
        textView.lineBreakMode = .byTruncatingTail
        return textView
    }()
    
    lazy var expiry_icon: UIImageView = {
       let imageView = UIImageView(image: self.traitCollection.userInterfaceStyle == .dark ? UIImage(named: "calendar-remove-outline") : UIImage(named: "calendar-remove-outline-black"))
        return imageView
    }()
        
    lazy var datetime: UILabel = {
        let datetime = UILabel()
        datetime.text = "Test time"
        datetime.font = UIFont.systemFont(ofSize: 9)
        return datetime
    }()
    
    lazy var ringIcon: UIImageView = {
        let imageView = UIImageView(image: self.traitCollection.userInterfaceStyle == .dark ? UIImage(named: "bell-ring-outline") : UIImage(named: "bell-ring-outline-black"))
        imageView.isHidden = true
        return imageView
    }()
    
    lazy var remindLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 9)
        label.isHidden = true
        return label
    }()
    
    lazy var completeSubTaskLabel: UILabel = {
        let label = UILabel()
        label.text = "0/0"
        return label
    }()
    
    lazy var completedCheckBox: TDCheckmarkButton = {
        let checkbox = TDCheckmarkButton()
        checkbox.height = 20
        checkbox.width = 20
        checkbox.translatesAutoresizingMaskIntoConstraints = false
        return checkbox
    }()
}

extension TodoView {
    
    private func debugUI() {
        self.cardBackground.contentView.subviews.forEach { $0.layer.borderWidth = 2; $0.layer.borderColor = UIColor.random.cgColor }
    }
    
    private func setupViews() {
        
        addSubview(cardBackground)
        
        [leadingView, trailingView].forEach { addSubview($0); sendSubviewToBack($0) }

        cardBackground.addSubview(shadowView)
        cardBackground.addSubview(shadowView2)
        cardBackground.sendSubviewToBack(shadowView)
        cardBackground.sendSubviewToBack(shadowView2)
        
        [title, expiry_icon, datetime, completeSubTaskLabel, completedCheckBox, ringIcon, remindLabel].forEach { cardBackground.contentView.addSubview($0) }
    }
    
    private func setupGesture() {
        cardBackground.addGestureRecognizer(tapGesture)
        cardBackground.addGestureRecognizer(panGesture)
    }
    
    private func setupConstrains() {
        trailingView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(0)
            maker.trailing.equalToSuperview().inset(4)
            maker.bottom.equalToSuperview().inset(0)
            maker.width.equalTo(UIScreen.main.bounds.width / 4 - 4)
        }
        
        leadingView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(0)
            maker.leading.equalToSuperview().inset(4)
            maker.bottom.equalToSuperview().inset(0)
            maker.width.equalTo(UIScreen.main.bounds.width / 4 - 4)
        }
        
        cardBackground.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.trailing.equalToSuperview().inset(4)
            maker.leading.equalToSuperview().inset(4)
            if self.viewModel.subtasks.count >= 2 {
                maker.bottom.equalToSuperview().inset(16)
            } else if self.viewModel.subtasks.count < 2 && self.viewModel.subtasks.count > 0{
                maker.bottom.equalToSuperview().inset(8)
            }  else if self.viewModel.subtasks.count == 0{
                maker.bottom.equalToSuperview()
            }
        }
        
        title.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(8)
            maker.top.equalToSuperview().inset(8)
            maker.width.lessThanOrEqualTo(2 * (UIScreen.main.bounds.width / 3))
        }
        
        expiry_icon.snp.makeConstraints { maker in
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.bottom.equalToSuperview().inset(8)
            maker.leading.equalToSuperview().inset(8)
        }
        
        datetime.snp.makeConstraints { maker in
            maker.top.equalTo(title.snp.bottom).inset(-8)
            maker.leading.equalTo(expiry_icon.snp.trailing)
            maker.bottom.equalToSuperview().inset(8)
        }
        
        ringIcon.snp.makeConstraints { maker in
            maker.width.equalTo(12)
            maker.height.equalTo(12)
            maker.bottom.equalToSuperview().inset(8)
            maker.leading.equalTo(datetime.snp.trailing).inset(-8)
        }
        
        remindLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(ringIcon.snp.trailing).inset(-8)
            maker.bottom.equalToSuperview().inset(8)
        }

        completeSubTaskLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(completedCheckBox.snp.leading).inset(-8)
            maker.width.equalTo(40)
        }
        
        completedCheckBox.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(self.cardBackground.snp.trailing)
        }
        
        if self.viewModel.subtasks.count > 0 && self.viewModel.subtasks.count < 2 {
            shadowView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().inset(8)
                maker.trailing.equalToSuperview().inset(8)
                maker.leading.equalToSuperview().inset(8)
                maker.bottom.equalToSuperview().inset(-8)
            }
        } else if self.viewModel.subtasks.count >= 2 {
            shadowView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().inset(8)
                maker.trailing.equalToSuperview().inset(8)
                maker.leading.equalToSuperview().inset(8)
                maker.bottom.equalToSuperview().inset(-8)
            }
            shadowView2.snp.makeConstraints { maker in
                maker.top.equalTo(shadowView.snp.top).inset(8)
                maker.trailing.equalTo(shadowView.snp.trailing).inset(8)
                maker.leading.equalTo(shadowView.snp.leading).inset(8)
                maker.bottom.equalToSuperview().inset(-16)
            }
        }
    }
    
    func config(viewModel: TodoViewModel) {
        
        title.attributedText = viewModel.title
        title.textColor = viewModel.completed ? .secondaryLabel : .label
        datetime.textColor = viewModel.completed ? .secondaryLabel : .label
        completeSubTaskLabel.textColor = viewModel.completed ? .secondaryLabel : .label
        datetime.text = viewModel.expiredDate
        completedCheckBox.isSelected = viewModel.completed
        completeSubTaskLabel.text = viewModel.completeSubtaskRateText
        ringIcon.isHidden = !viewModel.showRemindComponent
        remindLabel.isHidden = !viewModel.showRemindComponent
        remindLabel.text = viewModel.remindText
        
//        completedCheckBox.rx.tap.subscribe(onNext: { [weak self] in
//            self!.delegate?.didTapComplete(self!, todo: self!.viewModel!)
//        }).disposed(by: disposeBag)
    }
    
    func toggle(isExpanded: Bool){
        self.isExpanded = isExpanded
        if isExpanded {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                
                self.shadowView.alpha = 0
                self.shadowView2.alpha = 0
                self.shadowView.isHidden = true
                self.shadowView2.isHidden = true
            }, completion: { position in
                switch position {
                case .end:
                    self.shadowView.alpha = 0
                    self.shadowView2.alpha = 0
                    self.shadowView.isHidden = true
                    self.shadowView2.isHidden = true
                default:
                    ()
                }
            }).startAnimation()
        } else {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0, options: .beginFromCurrentState, animations: {
                
                self.shadowView.alpha = 1
                self.shadowView2.alpha = 1
                self.shadowView.isHidden = false
                self.shadowView2.isHidden = false
            }, completion: { position in
                switch position {
                case .end:
                    self.cardBackground.snp.updateConstraints { maker in
                        if (self.viewModel.subtasks.count >= 2) {
                            maker.bottom.equalToSuperview().inset(16)
                        } else if (self.viewModel.subtasks.count < 2) {
                            maker.bottom.equalToSuperview().inset(8)
                        }
                    }
                    self.shadowView.alpha = 1
                    self.shadowView2.alpha = 1
                    self.shadowView.isHidden = false
                    self.shadowView2.isHidden = false
                default:
                    ()
                }
            }).startAnimation()
        }
    }
    
    
}
