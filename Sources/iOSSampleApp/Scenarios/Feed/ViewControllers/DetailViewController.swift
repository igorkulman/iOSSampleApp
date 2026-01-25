//
//  DetailViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 05/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import UIKit
import WebKit

protocol DetailViewControllerDelegate: AnyObject {
    /**
     Invoked when user finished looking at the RSS source detail
     */
    func detailViewControllerDidFinish()
}

final class DetailViewController: UIViewController {

    // MARK: - UI

    private lazy var backBarButtonItem = UIBarButtonItem(
        image: .back,
        primaryAction: UIAction { [weak self] _ in
            self?.webView?.goBack()
        }
    )

    private lazy var forwardBarButtonItem = UIBarButtonItem(
        image: .forward,
        primaryAction: UIAction { [weak self] _ in
            self?.webView?.goForward()
        }
    )

    private lazy var reloadBarButtonItem = UIBarButtonItem(
        systemItem: .refresh,
        primaryAction: UIAction { [weak self] _ in
            guard let self = self else { return }
            self.webView?.stopLoading()
            if self.webView?.url != nil {
                self.webView?.reload()
            } else {
                self.load(self.item.link)
            }
        }
    )

    private lazy var stopBarButtonItem = UIBarButtonItem(
        systemItem: .stop,
        primaryAction: UIAction { [weak self] _ in
            self?.webView?.stopLoading()
        }
    )

    private lazy var doneBarButtonItem = UIBarButtonItem(
        systemItem: .done,
        primaryAction: UIAction { [weak self] _ in
            self?.delegate?.detailViewControllerDidFinish()
        }
    )

    private lazy var flexibleSpaceBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)

    private lazy var progressView = UIProgressView(progressViewStyle: .default) &> {
        $0.trackTintColor = .clear
    }

    // MARK: - Properties

    weak var delegate: DetailViewControllerDelegate?

    // MARK: - Fields

    private let item: RssItem
    private var webView: WKWebView?
    private var observations: [NSKeyValueObservation] = []

    // MARK: - Setup

    init(item: RssItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)

        webView.allowsBackForwardNavigationGestures = true
        webView.isMultipleTouchEnabled = true

        view = webView
        self.webView = webView
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()

        guard let navigationController = navigationController else {
            return
        }
        progressView.frame = CGRect(x: 0, y: navigationController.navigationBar.frame.size.height - progressView.frame.size.height, width: navigationController.navigationBar.frame.size.width, height: progressView.frame.size.height)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupObservations()
        setupData()
    }

    private func setupUI() {
        navigationItem.rightBarButtonItem = doneBarButtonItem
        title = item.title

        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.navigationBar.addSubview(progressView)
    }

    private func setupData() {
        load(item.link)
    }

    private func setupObservations() {
        guard let webView = webView else {
            return
        }

        observations.append(
            webView.observe(\.canGoBack, options: [.new]) { [weak self] _, change in
                self?.backBarButtonItem.isEnabled = change.newValue ?? false
            }
        )

        observations.append(
            webView.observe(\.canGoForward, options: [.new]) { [weak self] _, change in
                self?.forwardBarButtonItem.isEnabled = change.newValue ?? false
            }
        )

        observations.append(
            webView.observe(\.title, options: [.new]) { [weak self] _, change in
                self?.navigationItem.title = change.newValue ?? nil
            }
        )

        observations.append(
            webView.observe(\.estimatedProgress, options: [.new]) { [weak self] _, change in
                guard let self = self, let progress = change.newValue else { return }

                self.progressView.alpha = 1
                self.progressView.setProgress(Float(progress), animated: true)

                if progress >= 1.0 {
                    self.animateProgressAlpha()
                }
            }
        )

        observations.append(
            webView.observe(\.isLoading, options: [.new]) { [weak self] _, change in
                guard let self = self, let isLoading = change.newValue else { return }

                if isLoading {
                    self.toolbarItems = [
                        self.backBarButtonItem,
                        self.flexibleSpaceBarButtonItem,
                        self.forwardBarButtonItem,
                        self.flexibleSpaceBarButtonItem,
                        self.stopBarButtonItem
                    ]
                } else {
                    self.toolbarItems = [
                        self.backBarButtonItem,
                        self.flexibleSpaceBarButtonItem,
                        self.forwardBarButtonItem,
                        self.flexibleSpaceBarButtonItem,
                        self.reloadBarButtonItem
                    ]
                }
            }
        )
    }

    // MARK: - Internal

    private func animateProgressAlpha() {
        UIView.animate(withDuration: 0.3, delay: 0.3, options: .curveEaseOut, animations: { [weak self] in
            self?.progressView.alpha = 0
            }, completion: { [weak self] _ in
                self?.progressView.setProgress(0, animated: false)
        })
    }

    private func load(_ url: URL) {
        guard let webView = webView else {
            return
        }
        let request = URLRequest(url: url)
        DispatchQueue.main.async {
            webView.load(request)
        }
    }
}

#Preview {
    UINavigationController(rootViewController: DetailViewController(item: RssItem(title: "New post", description: "Some description", link: URL(string: "http://www.github.com/igorkulman/iOSSampleApp")!, pubDate: Date())))
}
