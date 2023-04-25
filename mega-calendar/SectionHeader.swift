//
//  SectionHeader.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//

import UIKit
import SnapKit

class SectionHeader: UICollectionReusableView {
     var label = UILabel()

     override init(frame: CGRect) {
         super.init(frame: frame)
         addSubview(label)
         label.snp.makeConstraints {
             $0.edges.equalToSuperview().inset(20)
         }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
