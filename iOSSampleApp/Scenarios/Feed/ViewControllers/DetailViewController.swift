//
//  DetailViewController.swift
//  iOSSampleApp
//
//  Created by Igor Kulman on 05/10/2017.
//  Copyright © 2017 Igor Kulman. All rights reserved.
//

import CleanroomLogger
import RxCocoa
import RxSwift
import UIKit

final class DetailViewController: UIViewController, FeedStoryboardLodable {

    // MARK: - Outlets

    @IBOutlet private weak var webView: UIWebView!

    // MARK: - Properties

    var viewModel: DetailViewModel!
    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupBinding()
        setupData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = viewModel.item.title
    }

    private func setupData() {
        if let link = viewModel.item.link, let url = URL(string: link) {
            webView.loadRequest(NSURLRequest(url: url) as URLRequest)
        }
    }

    private func setupBinding() {
        webView.rx.didStartLoad.subscribe(onNext: { UIApplication.shared.isNetworkActivityIndicatorVisible = true }).disposed(by: disposeBag)
        webView.rx.didFinishLoad.subscribe(onNext: { UIApplication.shared.isNetworkActivityIndicatorVisible = false }).disposed(by: disposeBag)
        webView.rx.didFailLoad.subscribe(onNext: { error in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            Log.error?.message("Webview loading failed with \(error.localizedDescription)")
        }).disposed(by: disposeBag)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
