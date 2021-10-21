//
//  DetailsView.swift
//  Toodoo
//
//  Created by Shi wei Yang on 2021/10/8.
//

import Foundation
import UIKit

class DetailsView: UIView {
    
    var viewModel: DetailsViewModel! {
        didSet {
            titleTextfield.text = viewModel.title
            categoryPicker.text = viewModel.category
            subTaskCountLabel.text = "\(viewModel.subtaskCount)"
            if viewModel.expiredDate != nil {
                datePickerLabel.text = viewModel.expiredDateText
                datePicker.setDate(viewModel.expiredDate!, animated: true)
            }
            
            if viewModel.remindTimeText != nil {
                reminderSwitch.setOn(true, animated: true)
                reminderPickerLabel.text = viewModel.remindTimeText
            }
            priorityButton.setTitle(viewModel.priorityText, for: .normal)
            detailDesc.text = viewModel.detailDescription ?? ("NewTodoView_detaildesc_no_description".localized)
        }
    }
        
    override init(frame: CGRect) {
        super.init(frame: frame)

        addBlurViews()
        setupNewTodoView()
        setupConstraints()
        setupTapGesture()
        debugUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var cellHeight = 50
    
    //MARK: - Base View
    
    let stackView: TDStackView = {
        let stackView = TDStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    /// Scroll view contains stack view
    let scrollView = UIScrollView()
    
    let contentView = UIView()
    
    //MARK: - Blur effect
    
    let blurEffect = UIBlurEffect(style: .regular)
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.autoresizingMask = [.flexibleHeight]
        return blurEffectView
    }()
    
    
    //MARK: - Title
    
    let titleTextfield: UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "title"
        textfield.borderStyle = .roundedRect
        textfield.autocapitalizationType = .none
        textfield.backgroundColor = .secondarySystemBackground
        return textfield
    }()
    
    //MARK: - Category Picker
    
    let categoryTitle: UILabel = {
       let label = UILabel()
        label.text = "NewTodoView_category_title".localized + ":"
        return label
    }()
    
    let categoryPickerBackground = TDCardView()
    
    let categoryPicker: UILabel = {
        let picker = UILabel()
        picker.textAlignment = .right
        picker.isUserInteractionEnabled = true
        return picker
    }()
    
    let categoryArrow: UIImageView = {
        let arrow = UIImageView(image: UIImage(named: "icons8-forward-48"))
        return arrow
    }()
    
    let categoryTap = UITapGestureRecognizer()
    
    //MARK: - DatePicker
    
    let dateContentStackView = TDStackView.vertical()
    
    let datePickerBackground = TDCardView()
    
    let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
        return datePicker
    }()
    
    let datePickerTitle: UILabel = {
        let label = UILabel()
        label.text = "NewTodoView_end_date_title".localized + ":"
        return label
    }()
    
    let datePickerLabel: UILabel = {
        let label = UILabel()
        label.text = dateFormat("yyyy/MM/dd", from: Date())
        label.isUserInteractionEnabled = true
        label.isHidden = true
        return label
    }()
    
    let datePickerSwitch: UISwitch = {
        let uiSwitch = UISwitch()
        uiSwitch.isOn = false
        return uiSwitch
    }()
    
    let dateTap = UITapGestureRecognizer()
    
    //MARK: - Reminder
    
    let reminderContentStackView = TDStackView.vertical()
    
    let reminderBackground = TDCardView()
    
    let reminderPicker: UIDatePicker = {
        let timePicker = UIDatePicker()
        timePicker.preferredDatePickerStyle = .inline
        timePicker.datePickerMode = .time
        return timePicker
    }()
    
    let reminderPickerTitle: UILabel = {
        let label = UILabel()
        label.text = "NewTodoView_reminder_title".localized + ":"
        return label
    }()
    
    let reminderPickerLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.text = checkUsesAMPM() ? dateFormat("hh:mm a", from: Date()) : dateFormat("HH:mm", from: Date())
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let reminderSwitch: UISwitch = {
        let reminderSwitch = UISwitch()
        reminderSwitch.isOn = false
        return reminderSwitch
    }()
    
    let reminderTap = UITapGestureRecognizer()
    
    //MARK: - Priority
    
    let priorityBackground = TDCardView()
    
    let priorityLabel: UILabel = {
        let label = UILabel()
        label.text = "NewTodoView_priority_title".localized + ":"
        return label
    }()
    
    let priorityButton: UIButton = {
        let button = UIButton()
        button.showsMenuAsPrimaryAction = true
        button.setTitle("None", for: .normal)
        return button
    }()
    
    //MARK: - Subtask
    
    let subTaskBackground = TDCardView()
    
    let subTaskTitle: UILabel = {
        let label = UILabel()
        label.text = "NewTodoView_subtask_title".localized
        label.sizeToFit()
        return label
    }()
    
    let subTaskCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textAlignment = .right
        label.isUserInteractionEnabled = true
        return label
    }()
    
    let subTaskArrow: UIImageView = {
        let arrow = UIImageView(image: UIImage(named: "icons8-forward-48"))
        return arrow
    }()
    
    let subTaskTap = UITapGestureRecognizer()
    
    //MARK: - Note
    
    let detailDesc: UITextView = {
        let textView = UITextView()
        textView.text = "NewTodoView_detaildesc_placeholder".localized
        textView.backgroundColor = .secondarySystemBackground
        textView.layer.cornerRadius = 10
        textView.isScrollEnabled = false
        textView.font = UIFont(name: textView.font!.fontName, size: UITextField().font!.pointSize)
        return textView
    }()
    
    private func addBlurViews() {
        blurEffectView.effect = self.blurEffect
        scrollView.addSubview(blurEffectView)
    }
    
    private func setupNewTodoView() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        
        [categoryPicker, categoryTitle, categoryArrow].forEach { categoryPickerBackground.contentView.addSubview($0) }
        
        [datePickerTitle, datePickerLabel, datePickerSwitch].forEach { datePickerBackground.contentView.addSubview($0) }
        
        dateContentStackView.addArrangedSubview(datePickerBackground)
        
        [reminderPickerTitle, reminderPickerLabel, reminderSwitch].forEach { reminderBackground.contentView.addSubview($0) }
        
        reminderContentStackView.addArrangedSubview(reminderBackground)
        
        [priorityLabel, priorityButton].forEach { priorityBackground.contentView.addSubview($0) }
        
        [subTaskTitle, subTaskCountLabel, subTaskArrow].forEach { subTaskBackground.contentView.addSubview($0) }
        
        [titleTextfield, categoryPickerBackground, dateContentStackView, reminderContentStackView, priorityBackground, subTaskBackground, detailDesc].forEach { stackView.addArrangedSubview($0) }
        
    }
    
    private func setupTapGesture() {
        categoryPicker.addGestureRecognizer(categoryTap)
        subTaskCountLabel.addGestureRecognizer(subTaskTap)
        datePickerLabel.addGestureRecognizer(dateTap)
        reminderPickerLabel.addGestureRecognizer(reminderTap)
    }
    
    private func setupConstraints() {
        
        scrollView.snp.makeConstraints { maker in
            maker.edges.equalTo(self.safeAreaLayoutGuide)
        }
        
        blurEffectView.snp.makeConstraints { maker in
            maker.top.equalToSuperview()
            maker.leading.equalToSuperview()
            maker.trailing.equalToSuperview()
            maker.bottom.equalTo(scrollView.layoutMarginsGuide.snp.bottom)
        }
        
        contentView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.edges.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { maker in
            maker.top.equalTo(contentView.layoutMarginsGuide.snp.top)
            maker.bottom.equalTo(contentView.layoutMarginsGuide.snp.bottom)
            maker.trailing.equalTo(contentView.snp.trailing).inset(16)
            maker.leading.equalTo(contentView.snp.leading).inset(16)
        }
        
        [titleTextfield, categoryPickerBackground, datePickerBackground, reminderBackground, priorityBackground, subTaskBackground].forEach { $0.snp.makeConstraints { maker in
            maker.height.equalTo(cellHeight)
            maker.width.equalToSuperview()
        }}
        
        detailDesc.snp.makeConstraints { maker in
            maker.height.greaterThanOrEqualTo(cellHeight)
        }
        
        
        categoryTitle.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(8)
            maker.leading.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
        }
        
        categoryPicker.snp.makeConstraints { maker in
            maker.trailing.equalTo(categoryArrow.snp.leading).inset(-8)
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.leading.equalTo(categoryTitle.snp.trailing).inset(-8)
        }

        categoryArrow.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(4)
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.width.equalTo(24)
        }

        datePicker.snp.makeConstraints { maker in
            maker.height.lessThanOrEqualTo(400)
        }

        datePickerTitle.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(8)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        datePickerLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(datePickerSwitch.snp.leading).inset(-8)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        datePickerSwitch.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(8)
            maker.centerY.equalToSuperview()
        }
        
        reminderPicker.snp.makeConstraints { maker in
            maker.height.lessThanOrEqualTo(400)
        }

        reminderPickerTitle.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(8)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        reminderPickerLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(reminderSwitch.snp.leading).inset(-8)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        reminderSwitch.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(8)
            maker.centerY.equalToSuperview()
        }
        
        priorityLabel.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(8)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        priorityButton.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(8)
            maker.top.equalToSuperview()
            maker.bottom.equalToSuperview()
        }
        
        subTaskTitle.snp.makeConstraints { maker in
            maker.leading.equalToSuperview().inset(8)
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.width.lessThanOrEqualTo(UIScreen.main.bounds.width / 2)
        }

        subTaskCountLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.leading.equalTo(subTaskTitle.snp.trailing).inset(-8)
            maker.trailing.equalTo(subTaskArrow.snp.leading).inset(-8)
        }

        subTaskArrow.snp.makeConstraints { maker in
            maker.trailing.equalToSuperview().inset(4)
            maker.top.equalToSuperview().inset(8)
            maker.bottom.equalToSuperview().inset(8)
            maker.width.equalTo(24)
        }
        
    }
    
    // MARK: - DEBUG UI PURPOSE
    private func debugUI() {
        
        scrollView.layer.borderWidth = 2
        scrollView.layer.borderColor = UIColor.random.cgColor
        
        categoryPickerBackground.layer.borderWidth = 2
        categoryPickerBackground.layer.borderColor = UIColor.random.cgColor
        categoryPicker.layer.borderWidth = 2
        categoryPicker.layer.borderColor = UIColor.random.cgColor
        categoryTitle.layer.borderWidth = 2
        categoryTitle.layer.borderColor = UIColor.random.cgColor
        categoryArrow.layer.borderWidth = 2
        categoryArrow.layer.borderColor = UIColor.random.cgColor
        
        datePickerBackground.layer.borderWidth = 2
        datePickerBackground.layer.borderColor = UIColor.random.cgColor
        datePicker.layer.borderWidth = 2
        datePicker.layer.borderColor = UIColor.random.cgColor
        datePickerTitle.layer.borderWidth = 2
        datePickerTitle.layer.borderColor = UIColor.random.cgColor
        datePickerLabel.layer.borderWidth = 2
        datePickerLabel.layer.borderColor = UIColor.random.cgColor
        
        subTaskBackground.contentView.subviews.forEach { $0.layer.borderWidth = 2; $0.layer.borderColor = UIColor.random.cgColor }
        detailDesc.layer.borderWidth = 2
        detailDesc.layer.borderColor = UIColor.random.cgColor
        
        reminderSwitch.layer.borderWidth = 2
        reminderSwitch.layer.borderColor = UIColor.random.cgColor
    }


}
