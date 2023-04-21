//
//  ViewController.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//

import UIKit
import SnapKit

final class ViewController: UIViewController {

    private lazy var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setConstraints()
    }
    func setupViews() {
        view.addSubview(button)
        button.setTitle("Show Calendar", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = UIColor(red: 250, green: 250, blue: 250, alpha: 1.0)
        button.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
    }
    
    func setConstraints() {
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc
    private func showCalendar() {
        let vc = CalendarViewController()
        navigationController?.present(vc, animated: true)
    }
}
