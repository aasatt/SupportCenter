//
//  AttachmentsView.swift
//  
//
//  Created by Aaron Satterfield on 5/11/20.
//

import Foundation
import UIKit

protocol AttachmentsViewDelegate: AttachmentItemDelegate {
    func didSelectAddItem()
}

protocol AttachmentItemDelegate: AnyObject {
    func removeAttachment(attachment: Attachment)
}

class AttachmentsView: UIScrollView, AttachmentItemDelegate {

    let viewHeight: CGFloat = 70.0

    weak var attachmentsDelegate: AttachmentsViewDelegate?

    private lazy var addButton: AddButton = {
        let b = AddButton()
        b.addTarget(self, action: #selector(self.actionAddImage), for: .touchUpInside)
        return b
    }()

    lazy var stackView: UIStackView = {
        let s = UIStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .horizontal
        s.spacing = 8.0
        s.distribution = .fill
        s.alignment = .fill
        // add the add button
        let item = AttachmentItemView()
        item.setContentView(addButton)
        s.addArrangedSubview(item)
        return s
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        addSubview(stackView)
        showsHorizontalScrollIndicator = false
        contentInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: viewHeight),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.heightAnchor.constraint(equalTo: heightAnchor)
        ])

    }

    func addAttachment(_ attachment: Attachment) {
        let v = AttachmentItemView()
        v.delegate = self
        v.attachment = attachment
        stackView.insertArrangedSubview(v, at: stackView.arrangedSubviews.count-1)
    }

    @objc func actionAddImage() {
        attachmentsDelegate?.didSelectAddItem()
    }

    func removeAttachment(attachment: Attachment) {
        attachmentsDelegate?.removeAttachment(attachment: attachment)
        if let v = stackView.arrangedSubviews.first(where: {($0 as? AttachmentItemView)?.attachment == attachment}) {
            self.stackView.removeArrangedSubview(v)
            v.removeFromSuperview()
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.25, animations: {
                self.layoutIfNeeded()
            })
        }
    }

}

private class AttachmentItemView: UIView {

    weak var delegate: AttachmentItemDelegate?

    var contentView: UIView? {
        didSet {
            guard let v = contentView else { return }
            setContentView(v)
        }
    }

    var attachment: Attachment? {
        didSet {
            let imageView = UIImageView(image: attachment?.thumbnail)
            imageView.contentMode = .scaleAspectFill
            contentView = imageView
            closeButton.alpha = attachment != nil ? 1.0 : 0.0
        }
    }

    lazy var closeButton: UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        b.tintColor = .systemRed
        b.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        b.widthAnchor.constraint(equalTo: b.heightAnchor).isActive = true
        b.contentHorizontalAlignment = .trailing
        b.contentVerticalAlignment = .top
        b.alpha = 0.0
        b.addTarget(self, action: #selector(self.actionRemove), for: .touchUpInside)
        return b
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        addSubview(closeButton)
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: heightAnchor, constant: 10.0),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            closeButton.topAnchor.constraint(equalTo: topAnchor)
        ])
    }

    func setContentView(_ contentView: UIView) {
        insertSubview(contentView, at: 0)

        contentView.layer.cornerRadius = 8.0
        contentView.layer.borderColor = UIColor.label.withAlphaComponent(0.8).cgColor
        contentView.layer.borderWidth = 1.0
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.clipsToBounds = true

        let center = contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
        center.priority = .defaultHigh
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1.0),
            center,
            contentView.topAnchor.constraint(equalTo: topAnchor, constant: 10.0),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    @objc func actionRemove() {
        guard let attachment = attachment else { return }
        delegate?.removeAttachment(attachment: attachment)
    }

}

private class AddButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    func setup() {
        setImage(UIImage(systemName: "folder.fill.badge.plus"), for: .normal)

        tintColor = .label
        layer.cornerRadius = 8.0
        layer.borderColor = UIColor.label.withAlphaComponent(0.8).cgColor
        layer.borderWidth = 1.0
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0).isActive = true
    }

}


