//
//  SupportButton.swift
//  SupportCenter
//
//  Created by Aaron Satterfield on 9/23/25.
//

import SwiftUI

extension EnvironmentValues {
    @Entry public var supportCenterPresentingViewName: String?
    @Entry public var mailServer: MailServer?
}

struct SupportButton<Label: View>: View {
    @Environment(\.mailServer) var mailServer
    @State var isPresenting = false
    let label: () -> Label

    init(@ViewBuilder label: @escaping () -> Label) {
        self.label = label
    }

    var body: some View {
        ZStack {
            Button {
                isPresenting = true
            } label: {
                label()
            }

            if isPresenting, let mailServer {
                SupportView(presentingSupport: $isPresenting, mailServer: mailServer)
            }
        }
    }
}

public struct SupportView: UIViewControllerRepresentable {
    @Environment(\.supportCenterPresentingViewName) private var presentingViewName
    @Binding var presentingSupport: Bool
    let mailServer: MailServer

    public func makeUIViewController(context: Context) -> SupportWrappingViewController {
        let controller = SupportWrappingViewController(mailServer: mailServer)
        controller.presentingViewName = presentingViewName
        controller.onDismiss = {
            presentingSupport = false
        }
        return controller
    }

    public func updateUIViewController(_ uiViewController: SupportWrappingViewController, context: Context) {
        if presentingSupport {
            uiViewController.present()
        }
    }
}

public final class SupportWrappingViewController: UIViewController, @MainActor SupportCenterViewControllerDelegate {
    private let mailServer: MailServer
    fileprivate var presentingViewName: String?

    var onDismiss: (() -> Void)?

    init(mailServer: MailServer) {
        self.mailServer = mailServer
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        present()
    }

    @MainActor
    public func present() {
        // metadata is captured automatically by SupportCenter
        SupportCenter.present(with: mailServer, from: self, presentingViewName: presentingViewName, delegate: self)
    }

    @MainActor
    public func supportCenterDidDismiss() {
        onDismiss?()
    }
}


#if DEBUG

#Preview {
    SupportButton {
        Text("Contact Us")
    }
    .environment(\.mailServer, .smtp2go(configuration: .init(apiToken: "preview", supportEmail: "preview", fromEmail: "preview")))
}

#endif
