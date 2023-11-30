//
//  ChartsViewCollectionViewCell.swift
//  pocCharts
//
//  Created by Thomas TEROSIET on 29/11/2023.
//

import Foundation
import UIKit
import DGCharts

class chartsCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        fatalError("init \(coder) has not been implemented")
    }
    
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
    
    func setupCell(entries: [BarChartDataEntry]) {
        self.setData(values: entries)
        self.setupUI()
    }
}

private extension chartsCollectionViewCell {
    func setupUI() {
        barChartView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(barChartView)
        NSLayoutConstraint.activate([
            barChartView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            barChartView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
            barChartView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
            barChartView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
        ])
    }
    
    func setData(values: [BarChartDataEntry]) {
        let set1 = BarChartDataSet(entries: values)
        set1.setColor(.orange)
        set1.drawValuesEnabled = false
        let data = BarChartData(dataSet: set1)
        barChartView.data = data
    }
}
