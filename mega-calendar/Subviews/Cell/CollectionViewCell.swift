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
    var data: [String]? {
        didSet {
            guard let data = data else { return }
            // 0 for title 1 for currentDate 2 for startDate 3 for endDate
            titleLabel.text = data[0]
            if(data[0]=="СБ"||data[0]=="ВС"){
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
        let currentDate = data?[1]
        let startDate = data?[2] ?? nil
        let endDate = data?[3] ?? nil
        
        // all the above three values are of type string date
        // if currentDate == startDate or endDate then make the current CollectionViewCell background color indigo 
        // if currentDate is between startDate and endDate then make the CollectionViewCell background color blue
         // Convert the currentDate, startDate, and endDate strings to Date objects
        if(currentDate != nil && startDate != nil || endDate != nil){
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let currentDateObj = dateFormatter.date(from: currentDate)
            let startDateObj = dateFormatter.date(from: startDate)
            let endDateObj = dateFormatter.date(from: endDate!)!
            
            // Check if the currentDate is equal to the startDate or endDate
            if currentDateObj == startDateObj || currentDateObj == endDateObj {
                self.backgroundColor = UIColor.systemIndigo
            } else if currentDateObj > startDateObj && currentDateObj < endDateObj {
                self.backgroundColor = UIColor.blue
            } else {
                self.backgroundColor = UIColor.white
            }        }
    }
}
