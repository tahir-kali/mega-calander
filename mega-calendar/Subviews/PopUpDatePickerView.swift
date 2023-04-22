//
//  PopUpDatePickerView.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//

import UIKit
import SnapKit

class PopUpDatePickerView: UIView {
    
    private var frameView: UIView!
    private var titleLabel: UILabel!
    private var datePicker: UIDatePicker!
    private var okButton: UIButton!
    private var cancelButton: UIButton!
    
    var delegate: (_ date: Date?) -> Void = { _ in }
    
    var title: String {
        get {
            titleLabel.text ?? ""
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    init(frame: CGRect, minDate: Date?, maxDate: Date?) {
        super.init(frame: frame)
        
        commonInit(minDate: minDate, maxDate: maxDate)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit(minDate: nil, maxDate: nil)
    }
    
    func commonInit(minDate: Date?, maxDate: Date?) {
        // Dark shade
        backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        
        // Frame view
        frameView = UIView()
        frameView.layer.cornerRadius = 10
        frameView.layer.masksToBounds = true
        frameView.backgroundColor = .white
        addSubview(frameView)
        frameView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        
        // Title label
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        frameView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(40)
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-40)
        }

        // Date picker
        datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.minimumDate = Date()
        frameView.addSubview(datePicker)
        datePicker.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }

        // Buttons
        cancelButton = UIButton()
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor(red: 0.0, green: 0.478431, blue: 1.0, alpha: 1.0), for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        okButton = UIButton()
        okButton.setTitle("OK", for: .normal)
        okButton.setTitleColor(UIColor(red: 0.0, green: 0.478431, blue: 1.0, alpha: 1.0), for: .normal)
        okButton.addTarget(self, action: #selector(okPressed), for: .touchUpInside)
        frameView.addSubview(cancelButton)
        frameView.addSubview(okButton)
        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(datePicker.snp.bottom)
            make.left.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview().offset(-40)
        }
        okButton.snp.makeConstraints { (make) in
            make.top.equalTo(datePicker.snp.bottom)
            make.left.equalTo(cancelButton.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(cancelButton.snp.width)
        }
    }
    
    @objc func cancelPressed() {
        disappearAndReturn(date: nil)
    }
    
    @objc func okPressed() {
        disappearAndReturn(date: datePicker.date)
    }
    
    private func disappearAndReturn(date: Date?) {
        UIView.animate(withDuration: 0.3) {
            self.alpha = 0.0
        } completion: { (_) in
            self.removeFromSuperview()
            self.delegate(date)
        }
    }
    
    static func createAndShow(minDate: Date?, maxDate: Date?, viewController: UIViewController, title: String, delegate: @escaping (_ date: Date?) -> Void) -> PopUpDatePickerView {
        let popup = PopUpDatePickerView(frame: viewController.view.bounds, minDate: minDate, maxDate: maxDate)
        popup.title = title
        popup.delegate = delegate
        popup.alpha = 0.0
        viewController.view.addSubview(popup)
        
        UIView.animate(withDuration: 0.3) {
            popup.alpha = 1.0
        }
        
        return popup
    }
}
