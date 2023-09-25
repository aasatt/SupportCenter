//
//  SupportCenterViewController.swift
//  
//
//  Created by Aaron Satterfield on 5/12/20.
//

import Foundation
import UIKit

public protocol SupportCenterViewControllerDelegate: AnyObject {
    func supportCenterDidDismiss()
}

class SupportCenterViewController: UIViewController, SupportCenterHelpContainerViewDelegate {
    weak var delegate: SupportCenterViewControllerDelegate?

    let options: [ReportOption]

    lazy var blurView: UIVisualEffectView = {
        let v = UIVisualEffectView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isUserInteractionEnabled = true
        v.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.actionBackgroundTapped)))
        return v
    }()

    lazy var containerView: SupportCenterHelpContainerView = {
        let v = SupportCenterHelpContainerView(options: self.options)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        v.delegate = self
        return v
    }()

    lazy var stage1ContainerConstraints: [NSLayoutConstraint] = {
        let leading = containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 40)
        let trailing = containerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -40)
        leading.priority = .defaultHigh
        trailing.priority = .defaultHigh
        let width = containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 480.0)
        return [leading, trailing, width]
    }()

    lazy var stage2ContainerConstraints: [NSLayoutConstraint] = {
        let leading = containerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 22)
        let trailing = containerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -22)
        leading.priority = .defaultHigh
        trailing.priority = .defaultHigh
        let width = containerView.widthAnchor.constraint(lessThanOrEqualToConstant: 520.0)
        return [leading, trailing, width]
    }()

    convenience init(options: [ReportOption]) {
        self.init(nibName: nil, bundle: nil, options: options)
        modalPresentationStyle = .overFullScreen
    }

    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, options: [ReportOption]) {
        self.options = options
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(blurView)
        view.addSubview(containerView)

        view.setNeedsUpdateConstraints()
        view.updateConstraintsIfNeeded()
        view.setNeedsLayout()
        view.layoutIfNeeded()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.view.layoutIfNeeded()
            self?.blurView.effect = UIBlurEffect.init(style: .regular)
            self?.containerView.alpha = 1.0
        }
        DispatchQueue.main.async {
            NSLayoutConstraint.deactivate(self.stage1ContainerConstraints)
            NSLayoutConstraint.activate(self.stage2ContainerConstraints)
            self.view.setNeedsLayout()
            UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseInOut, animations: {
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()

        // Blur Background
        blurView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        NSLayoutConstraint.activate(stage1ContainerConstraints)
    }

    @objc func actionBackgroundTapped() {
        hideAnimated()
    }

    func actionCancel() {
        hideAnimated()
    }


    func hideAnimated(completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            self?.blurView.effect = nil
            self?.containerView.alpha = 0.0
        }, completion: { [weak self] in
            guard $0 else { return }
            self?.dismiss(animated: false, completion: {
                completion?()
                self?.delegate?.supportCenterDidDismiss()
            })
        })
    }

    func presentComposeSheet(for option: ReportOption) {
        guard let controller = presentingViewController else { return }
        hideAnimated {
            controller.present(ComposeNavigationController(option: option), animated: true, completion: nil)
        }
    }

}
