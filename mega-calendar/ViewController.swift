
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
    private lazy var sizeForItem = CGSize()
    private lazy var startDateLabel = UILabel()
    private lazy var endDateLabel = UILabel()
    private lazy var weekDaysCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var startDate: Date?
    private var endDate: Date?
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
        endDate = Calendar.current.date(byAdding: .month, value: 3, to: startDate!)
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
        titleLabel.textAlignment = .center
        titleLabel.text = "Даты поездки"
        startDateLabel.text = "Start"
        endDateLabel.text = "End"
        topView.addSubview(startDateLabel)
        topView.addSubview(endDateLabel)
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        topView.backgroundColor = .gray.withAlphaComponent(0.3)
        let width = (UIScreen.main.bounds.width - 110) / 7
        sizeForItem = CGSize(width: width, height: width)
    }
    
    func setConstraints() {
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        weekDaysCollectionView.snp.makeConstraints {
                  $0.leading.trailing.equalToSuperview()
                  $0.bottom.equalToSuperview()
                  $0.height.equalTo(sizeForItem.height)
                  $0.top.equalTo(startDateLabel.snp.bottom).offset(12)
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
            cell.title = weekdays[indexPath.row]
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        
        if (allDates[datesCounter].dayNumberOfWeek() ?? 1) - 1 == (indexPath.row + 1) % 7 {
            cell.title = "\(allDates[datesCounter].get(.day))"
            if currentDate!.endOfMonth() == allDates[datesCounter] {
                currentDate = Calendar.current.date(byAdding: .day, value: 3, to: allDates[datesCounter])
            }
            datesCounter += 1
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
            
        } else {
            cell.title = ""
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
    @objc
    func tap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.collectionView)
        let indexPath = self.collectionView.indexPathForItem(at: location)
       
            
        let cell = self.collectionView.cellForItem(at: indexPath!)
        cell?.backgroundColor = UIColor.systemIndigo
        cell?.layer.cornerRadius = 20
        
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
