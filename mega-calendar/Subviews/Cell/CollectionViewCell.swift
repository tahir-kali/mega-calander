//
//  CollectionViewCell.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//

import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: String? {
        return "CollectionViewCell"
    }
    
    private let titleLabel = UILabel()
    var title: String? {
        didSet {
            guard let title = title else { return }
            titleLabel.text = title
            if(title=="СБ"||title=="ВС"){
                titleLabel.textColor = UIColor.red
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(titleLabel)
        titleLabel.textAlignment = .center
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
   
}
