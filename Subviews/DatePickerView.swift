//
//  DatePickerView.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//

import UIKit
import SnapKit

protocol PopUpDatePickerViewProtocol {
    var didSelect: (() -> Void)? { get set }
    var title: String? { get set }
}

final class DatePickerView: UIView, PopUpDatePickerViewProtocol {
    
    private let icon = UIImageView()
    private let dateLabel = UILabel()
    private let button = UIButton()
    
    var didSelect: (() -> Void)?
    var title: String? {
        didSet {
            self.setTitle(title)
        }
    }
    init() {
        super.init(frame: CGRect.init())
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.addSubview(icon)
        self.addSubview(dateLabel)
        self.addSubview(button)
        backgroundColor = .white
        icon.image = UIImage.init(named: "icon_calendar")
        dateLabel.textAlignment = .center
        button.addTarget(self, action: #selector(datePickerTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        icon.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(20)
        }
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(icon.snp.trailing).offset(8)
            $0.trailing.equalToSuperview().inset(8)
            $0.centerY.equalToSuperview()
        }
    }
    @objc
    private func datePickerTapped() {
        self.didSelect?()
    }
    
    private func setTitle(_ title: String?) {
        self.dateLabel.text = title
    }
}
