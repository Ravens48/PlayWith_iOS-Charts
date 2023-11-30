//
//  ViewController.swift
//  pocCharts
//
//  Created by Thomas TEROSIET on 29/11/2023.
//

import UIKit
import DGCharts
import TinyConstraints

class ViewController: UIViewController, ChartViewDelegate {
    
    
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    private func parse(jsonData: Data) -> Top?{
        do {
            let decodedData = try JSONDecoder().decode(Top.self,
                                                       from: jsonData)
            
            return decodedData
        } catch {
            print("decode error")
            return nil
        }
    }
    
    var info: Top?
    var filteredInflux: [Influx] = []
    var selectIndexPath: Int = 2
    
    lazy var barChartView: BarChartView = {
        let chartView = BarChartView()
        let hoursArray = ["7h","8h","9h","10h","11h","12h","13h","14h","15h", "16h", "17h", "18h", "19h", "20h","21h"]
        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: hoursArray)
        chartView.xAxis.labelPosition = .bottom
        chartView.xAxis.granularity = 1
        chartView.isUserInteractionEnabled = false
        chartView.xAxis.labelCount = hoursArray.count
        chartView.xAxis.drawGridLinesEnabled = false
        chartView.leftAxis.drawAxisLineEnabled = false
        chartView.leftAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawLabelsEnabled = false
        chartView.rightAxis.drawAxisLineEnabled = false
        chartView.legend.enabled = false
        chartView.drawGridBackgroundEnabled = false
        return chartView
    }()
    
    private lazy var cv: UICollectionView = {
        func createLayout() -> UICollectionViewCompositionalLayout {
            UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
                let section = sectionIndex
                switch section {
                case 0:
                    let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(80), heightDimension: .fractionalHeight(1.0))
                    let item = NSCollectionLayoutItem(layoutSize: itemSize)
                    
                    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(40))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                    group.interItemSpacing = .fixed(10)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 10 , bottom: 0, trailing: 0)
                    return section
                case 1:
                       let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
                       let item = NSCollectionLayoutItem(layoutSize: itemSize)
                       
                       let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.5))
                       let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                       let section = NSCollectionLayoutSection(group: group)
                       section.contentInsets = .init(top: 10, leading: 0 , bottom: 10, trailing: 10)
//                       section.orthogonalScrollingBehavior = .continuous
//                       section.supplementariesFollowContentInsets = false
                       return section

                default:
                    return nil
                }
            }
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        cv.register(dayCollectionViewCell.self, forCellWithReuseIdentifier: "dayCollectionViewCell")
        cv.register(chartsCollectionViewCell.self, forCellWithReuseIdentifier: "chartsCollectionViewCell")
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    var entriesValues : [BarChartDataEntry] = []
    let week: [dayAndCode] = [dayAndCode(day: "LUN", code: "MON"),
                              dayAndCode(day: "MAR", code: "TUE"),
                              dayAndCode(day: "MER", code: "WED"),
                              dayAndCode(day: "JEU", code: "THU"),
                              dayAndCode(day: "VEN", code: "FRI"),
                              dayAndCode(day: "SAM", code: "SUN"),
                              dayAndCode(day: "DIM", code: "SAT")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let localData = self.readLocalFile(forName: "info") {
            self.info = self.parse(jsonData: localData)
            
        }
        self.getAffluanceByday(dayCode: "MON")
//        self.entriesValues = self.setupDataForCharts()
        cv.dataSource = self
        cv.delegate = self
//        view.addSubview(barChartView)
        view.addSubview(cv)
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor, constant: 20),
            cv.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10),
            cv.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)

        ])
//        barChartView.top(to: cv)
//        barChartView.width(to: view)
//        barChartView.heightToWidth(of: view)

//        barChartView.xAxis.labelTextColor = .black
//        setData()
    }
    
    func getAffluanceByday(dayCode: String) {
        let startIndex = 6
        let endIndex = 19
        guard let dayliInfo = info?.dailyInfluxDto else {return}
        if let dayData = dayliInfo.first(where: {$0.day == dayCode}) {
            filteredInflux = Array(dayData.influx[startIndex...endIndex])
        }
        self.entriesValues =  self.setupDataForCharts()
//        print(filteredInflux)
    }
    
    func setupDataForCharts() -> [BarChartDataEntry]{
        var valuesCharts: [BarChartDataEntry] = []
        for (index, data) in self.filteredInflux.enumerated() {
            valuesCharts.append(BarChartDataEntry(x: Double(index), y: Double(data.influxAsNumeric)))
        }
        print(valuesCharts)
        return valuesCharts
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "dayCollectionViewCell", for: indexPath) as! dayCollectionViewCell
            cell.setupCell(day: week[indexPath.row].day)
            cell.backgroundColor = self.selectIndexPath == indexPath.row ? .gray : .white
            cell.layer.cornerRadius = self.selectIndexPath == indexPath.row ? 12 : 0
            return cell
        case 1:
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "chartsCollectionViewCell", for: indexPath) as! chartsCollectionViewCell
            cell.setupCell(entries: entriesValues)
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.getAffluanceByday(dayCode: week[indexPath.row].code)
//            self.cv.reloadSections(IndexSet(integer: 1))
            selectIndexPath = indexPath.row
            self.cv.reloadData()
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return week.count
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
}


