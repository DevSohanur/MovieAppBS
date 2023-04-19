//
//  MovieEmptyCell.swift
//  MovieAppBS
//
//  Created by Sohanur Rahman on 19/4/23..
//


import UIKit

class MovieEmptyCell: UICollectionViewCell {
    
    static let identifire = "MovieEmptyCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "No Result Found"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect){
        super.init(frame: .zero)
        
        contentView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
            
        // Set static constraints
        NSLayoutConstraint.activate([
            
            // Title Label
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}




