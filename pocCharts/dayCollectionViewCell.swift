//
//  dayCollectionViewCell.swift
//  pocCharts
//
//  Created by Thomas TEROSIET on 29/11/2023.
//

import Foundation
import UIKit

class dayCollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder){
        fatalError("init \(coder) has not been implemented")
    }
    
    private var label = UILabel()
    
    func setupCell(day: String) {
        self.label.text = day
        print(day)
        self.setupUI()
    }
}

private extension dayCollectionViewCell {
    func setupUI() {
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
                label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5),
                label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5),
                label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -5)
            ])
    }
}

