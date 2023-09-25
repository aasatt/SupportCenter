//
//  SupportCenterHelpContainerViewDelegate.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

protocol SupportCenterHelpContainerViewDelegate: AnyObject {
    func actionCancel()
    func presentComposeSheet(for option: ReportOption)
}

class SupportCenterHelpContainerView: UIView {

    weak var delegate: SupportCenterHelpContainerViewDelegate?

    var options: [ReportOption] = []

    lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.distribution = .fill
        s.alignment = .fill
        s.spacing = 0
        return s
    }()

    lazy var helpLabelContainer: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        v.addSubview(helpLabel)
        helpLabel.leadingAnchor.constraint(equalTo: v.leadingAnchor, constant: 20.0).isActive = true
        helpLabel.centerYAnchor.constraint(equalTo: v.centerYAnchor).isActive = true
        return v
    }()

    lazy var helpLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.preferredFont(forTextStyle: .headline).withTraits(traits: .traitBold)
        l.textColor = .label
        l.text = "Need Help?"
        return l
    }()

    lazy var cancelButton: UIButton = {
        let b = UIButton(type: .system)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        b.setTitle("Cancel", for: .normal)
        b.addTarget(self, action: #selector(self.actionCancel), for: .touchUpInside)
        return b
    }()

    convenience init(options: [ReportOption]) {
        self.init(frame: .zero, options: options)
    }

    init(frame: CGRect, options: [ReportOption]) {
        self.options = options
        super.init(frame: frame)
        initalize()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func initalize() {
        backgroundColor = .secondarySystemFill
        layer.masksToBounds = true
        layer.cornerRadius = 20.0

        addSubview(stackView)
        stackView.addArrangedSubview(helpLabelContainer)
        addSeparator()

        options.forEach {
            let bugOptionView = ReportOptionView(option: $0)
            bugOptionView.onSelect = { [weak self] in self?.delegate?.presentComposeSheet(for: $0) }
            stackView.addArrangedSubview(bugOptionView)
            addSeparator()
        }
        stackView.addArrangedSubview(cancelButton)

        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }


    func addSeparator() {
        stackView.addArrangedSubview(SeperatorLineView())
    }

    @objc func actionCancel() {
        delegate?.actionCancel()
    }

}

