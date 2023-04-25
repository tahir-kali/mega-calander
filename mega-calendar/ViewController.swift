//
//  ViewController.swift
//  MegaCalendar
//
//  Created by Mohammad Tahir on 21.04.23.
//
import Foundation
import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private lazy var topView = UIView()
    private lazy var titleLabel = UILabel()
    private lazy var startDateLabel = UILabel()
    private lazy var endDateLabel = UILabel()
    private lazy var sizeForItem = CGSize()
    private lazy var contentView = UIView()
    private lazy var weekDaysCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var startDate: Date?
    private var endDate: Date?
    private var selectedStartDate: Date = Date()
    private var selectedEndDate: Date = Date()
    private var numberOfMonts: Int?
    private var numberOfDays: Int?
    private var currentDate: Date?
    private var allDates = [Date]()
    private var datesCounter = 0
    
    private let weekdays = ["ПН", "ВТ", "СР", "ЧТ", "ПТ", "СБ", "ВС"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setCollectionView()
        setupViews()
        setConstraints()
        setupActions()
        startDate = Date()
        endDate = Calendar.current.date(byAdding: .month, value: 2, to: startDate!)
        countDays()
    }
 
    func setCollectionView() {
        weekDaysCollectionView.dataSource = self
        weekDaysCollectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        weekDaysCollectionView.backgroundColor = .clear
        weekDaysCollectionView.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
    }
    
    func setupViews() {
        self.view.addSubview(topView)
        self.view.addSubview(collectionView)
        topView.addSubview(weekDaysCollectionView)
        topView.addSubview(titleLabel)
        topView.addSubview(startDateLabel)
        topView.addSubview(endDateLabel)
        titleLabel.textAlignment = .center
        titleLabel.text = "Даты поездки"
        startDateLabel.text = selectedStartDate.toString()
        endDateLabel.text = selectedEndDate.toString()
        formatTopLabels()
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        topView.backgroundColor = .gray.withAlphaComponent(0.3)
        let width = (UIScreen.main.bounds.width - 110) / 7
        sizeForItem = CGSize(width: width, height: width)
    }
    func formatTopLabels(){
        startDateLabel.layer.cornerRadius = 5
        startDateLabel.layer.shadowColor = UIColor.black.cgColor
        startDateLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        startDateLabel.layer.shadowOpacity = 0.5
        startDateLabel.layer.shadowRadius = 3
        startDateLabel.layer.masksToBounds = false
        startDateLabel.backgroundColor = UIColor.white
        startDateLabel.textColor = UIColor.black
        
        endDateLabel.layer.cornerRadius = 5
        endDateLabel.layer.shadowColor = UIColor.black.cgColor
        endDateLabel.layer.shadowOffset = CGSize(width: 0, height: 2)
        endDateLabel.layer.shadowOpacity = 0.5
        endDateLabel.layer.shadowRadius = 3
        endDateLabel.layer.masksToBounds = false
        endDateLabel.backgroundColor = UIColor.white
        endDateLabel.textColor = UIColor.black
       
          }
    func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        weekDaysCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(sizeForItem.height)
            $0.top.equalTo(endDateLabel.snp.bottom).offset(12)
        }
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
        }
        startDateLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
        }
        endDateLabel.snp.makeConstraints {
            $0.leading.equalTo(startDateLabel.snp.trailing).offset(16)
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.width.equalTo(startDateLabel.snp.width)
            $0.trailing.equalToSuperview().inset(16)
        }
        collectionView.snp.makeConstraints {
            $0.top.equalTo(topView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func setupActions() {
        // startDateLabel.didSelect = { [weak self] in
        //     guard let self = self else { return }
        //     _ = PopUpDatePickerView.createAndShow(minDate: self.startDate, maxDate: self.endDate, viewController: self, title: "select date") { [weak self] date in
        //         guard let date = date else { return }
        //         self?.fromDatePickerView.title = "\(date.toString())"
        //         self?.startDate = date
        //         self?.countDays()
        //     }
        // }
        // endDateLabel.didSelect = { [weak self] in
        //     guard let self = self else { return }
        //     _ = PopUpDatePickerView.createAndShow(minDate: self.startDate, maxDate: self.endDate, viewController: self, title: "select date") { [weak self] date in
        //         guard let date = date else { return }
        //         self?.endDateLabel.title = "\(date.toString())"
        //         self?.endDate = date
        //         self?.countDays()
        //     }
        // }
    }
    
    private func countDays() {
        guard let startDate = startDate,
              let endDate = endDate
        else { return }
        numberOfMonts = abs(endDate.get(.month) - startDate.get(.month))
        numberOfDays = 35 * (numberOfMonts ?? 0)
        allDates = Date.dates(from: startDate.startOfMonth(), to: endDate.endOfMonth())
        datesCounter = 0
        currentDate = startDate
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if collectionView == weekDaysCollectionView {
            return 1
        }
        guard let numberOfMonts = numberOfMonts else { return 1 }
        return numberOfMonts > 0 ? numberOfMonts : 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == weekDaysCollectionView {
            return weekdays.count
        }
        guard !allDates.isEmpty else { return 0 }
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return sizeForItem
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == weekDaysCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
            cell.data = [weekdays[indexPath.row],"","",""]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        let allDatesLength = allDates.count
        if(allDatesLength > datesCounter){
            if (allDates[datesCounter].dayNumberOfWeek() ?? 1) - 1 == (indexPath.row + 1) % 7 {
                
                cell.data  = ["\(allDates[datesCounter].get(.day))",allDates[datesCounter].toString(),selectedStartDate.toString(),selectedEndDate.toString()]
                if currentDate!.endOfMonth() == allDates[datesCounter] {
                    currentDate = Calendar.current.date(byAdding: .day, value: 1, to: allDates[datesCounter])
                }
                datesCounter += 1
              
            } else {
                cell.data = ["","","",""]
            }
            
        }else{
            cell.data = ["","","",""]
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            sectionHeader.label.text = self.currentDate?.toString(with: "MMMM, YYYY")
            sectionHeader.label.font = UIFont.boldSystemFont(ofSize: 17.0)
            return sectionHeader
        } else {
            return UICollectionReusableView()
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if collectionView == weekDaysCollectionView {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.frame.width, height: 60)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
        guard let cellDate = cell.data?[0] else {return}
        // Get the current date from the cell
        let currentDate = cell.data?[1] ?? ""
        
        // Convert the currentDate string to a Date object
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        guard let currentDateObj = dateFormatter.date(from: currentDate) else {
            print("exited code")
            return
        }
        
        // Check if the currentDate is less than startDate
        if returnIntDate(currentDateObj) < returnIntDate(selectedStartDate) {
            selectedStartDate = currentDateObj
            print("set1")
        } else if returnIntDate(currentDateObj) > returnIntDate(selectedStartDate) && returnIntDate(currentDateObj) < returnIntDate(selectedEndDate) {
            selectedEndDate = currentDateObj
            print("set2")
        } else if returnIntDate(currentDateObj) > returnIntDate(selectedStartDate) && returnIntDate(currentDateObj) > returnIntDate(selectedEndDate) {
            selectedEndDate = currentDateObj
            print("set3")
        }
        startDateLabel.text = selectedStartDate.toString()
        endDateLabel.text = selectedEndDate.toString()
        cell.data = [cellDate, currentDateObj.toString(),selectedStartDate.toString(),selectedEndDate.toString()]
        
    }
    func returnIntDate(date:Date)-> Int{
        return Int(date.description)!
    }


}

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        let fromDate = startOfDay(for: from) // <1>
        let toDate = startOfDay(for: to) // <2>
        let numberOfDays = dateComponents([.day], from: fromDate, to: toDate) // <3>
        return numberOfDays.day!
    }
}
extension Date {
    func toString(with regex: String = "dd MMMM") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = regex
        let datenew = dateFormatter.string(from: self)
        return datenew
    }
    
    static func dates(from fromDate: Date, to toDate: Date) -> [Date] {
        var dates: [Date] = []
        var date = fromDate
        
        while date <= toDate {
            dates.append(date)
            guard let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) else { break }
            date = newDate
        }
        return dates
    }
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
}
