//  CollectionViewCell.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//

import UIKit
import SnapKit

final class CollectionViewCell: UICollectionViewCell {
    override var reuseIdentifier: Array? {
        return "CollectionViewCell"
    }
    
    private let titleLabel = UILabel()
    var data: Array? {
        didSet {
            guard let data = data else { return }
            // 0 for title 1 for currentDate 2 for startDate 3 for endDate
            titleLabel.text = data[0]
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
