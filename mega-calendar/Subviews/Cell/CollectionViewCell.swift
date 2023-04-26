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
    private var sentData: [String] =  ["","","",""]
    var data: [String]? {
        didSet {
            guard let data = data else { return }
            // 0 for title 1 for currentDate 2 for startDate 3 for endDate
            titleLabel.text = data[0]
            sentData = data
            if(data[0]=="СБ"||data[0]=="ВС"){
                titleLabel.textColor = UIColor.red
            }else{
                formatCells(data: data)
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
    
    func formatCells (data: [String]){
        if(data == ["","","",""]) {
            resetCellFormats()
            return
            
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
         let cD = data[1]
         let sD = data[2]
        let eD = data[3]
        guard let currentDate = dateFormatter.date(from: cD) else {
            return
            
        }
        guard let startDate = dateFormatter.date(from: sD) else {
            return
        }
        
        if(currentDate == startDate){
            print("\(currentDate) : \(startDate) start")
            formatCellPrimary()
            return
        }
        guard let endDate = dateFormatter.date(from: eD) else{
            return
        }
        if(currentDate == endDate){
            print("\(currentDate) : \(endDate) end")
            formatCellPrimary()
            return
            
        }
        if(currentDate > startDate && currentDate < endDate){
            formatCellSecondary()
            return
        }
        resetCellFormats()
        
    }
    func formatCellPrimary(){
        self.backgroundColor = .systemIndigo
        titleLabel.textColor = .white
        self.layer.cornerRadius = 20
    }
    func formatCellSecondary(){
        self.backgroundColor = UIColor(red:0.65,green:0,blue:1,alpha:0.2)
        titleLabel.textColor = .black
        self.layer.cornerRadius = 20
    }
    func resetCellFormats(){
        self.backgroundColor  = .white
        titleLabel.textColor = .black
    }
    
   func setupView() {
       
    contentView.addSubview(titleLabel)
    titleLabel.textAlignment = .center
       titleLabel.snp.makeConstraints {
           $0.edges.equalToSuperview()
       }
     
       
       
           
       
       
}
}
