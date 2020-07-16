//
//  WeatherMetadataCell.swift
//  Weather
//
//  Created by Julian Weiss on 7/16/20.
//  Copyright © 2020 Julian Weiss. All rights reserved.
//

import UIKit

class WeatherMetadataCell: UITableViewCell {
    
    struct Model {
        let title: String
        let detail: String
    }
    
    static let REUSE_IDENTIFIER = "WeatherMetadataCell"
    static let WEATHER_FONT = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .current)
    static let PADDING: CGFloat = 8.0
    
    var model: Model? {
        didSet {
            topLabel.text = model?.title
            bottomLabel.text = model?.detail
        }
    }
    
    let topLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = WeatherMetadataCell.WEATHER_FONT
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let bottomLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .darkGray
        label.textAlignment = .center
        label.font = WeatherMetadataCell.WEATHER_FONT
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        topLabel.setContentHuggingPriority(.required, for: .vertical)
        topLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(topLabel)
        topLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: WeatherMetadataCell.PADDING).isActive = true
        topLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -WeatherMetadataCell.PADDING).isActive = true
        topLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: WeatherMetadataCell.PADDING).isActive = true

        bottomLabel.setContentHuggingPriority(.required, for: .vertical)
        bottomLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        contentView.addSubview(bottomLabel)
        bottomLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: WeatherMetadataCell.PADDING).isActive = true
        bottomLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -WeatherMetadataCell.PADDING).isActive = true
        bottomLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        model = nil
    }
    
}
