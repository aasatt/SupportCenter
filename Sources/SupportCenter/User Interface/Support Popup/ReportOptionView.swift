//
//  ReportOptionView.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

class ReportOptionView: UIView {

    let option: ReportOption
    var onSelect: ((_ option: ReportOption) -> Void)?

    lazy var iconImageView: UIImageView = {
        let i = UIImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.tintColor = tintColor
        i.contentMode = .scaleAspectFit
        i.image = option.icon
        i.heightAnchor.constraint(equalToConstant: 22.0).isActive = true
        i.widthAnchor.constraint(equalToConstant: 22.0).isActive = true

        return i
    }()

    lazy var titleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .body)
        l.textColor = .label
        l.text = option.title
        l.numberOfLines = 1
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return l
    }()

    lazy var desciptionLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .caption1)
        l.textColor = .label
        l.text = option.description
        l.numberOfLines = 2
        l.adjustsFontSizeToFitWidth = true
        l.minimumScaleFactor = 0.5
        l.lineBreakMode = .byWordWrapping
        l.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return l
    }()

    convenience init(option: ReportOption) {
        self.init(frame: .zero, option: option)
    }

    init(frame: CGRect, option: ReportOption) {
        self.option = option
        super.init(frame: frame)
        initalize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initalize() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionTap)))

        addSubview(iconImageView)
        addSubview(titleLabel)
        addSubview(desciptionLabel)

        iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0).isActive = true
        iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12.0).isActive = true

        titleLabel.topAnchor.constraint(equalTo: iconImageView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8.0).isActive = true
        titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4.0).isActive = true

        desciptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6.0).isActive = true
        desciptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
        desciptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4.0).isActive = true
        desciptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12.0).isActive = true

    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .secondarySystemFill
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        backgroundColor = .clear
    }

    @objc func actionTap() {
        onSelect?(option)
        UIView.animate(withDuration: 0.25) {
            self.backgroundColor = .clear
        }
    }

}

