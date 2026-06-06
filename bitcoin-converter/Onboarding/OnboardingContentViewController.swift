//
//  OnboardingContentViewController.swift
//  bitcoin-converter
//

import UIKit

final class OnboardingContentViewController: UIViewController {

    let pageIndex: Int
    private let page: OnboardingPage

    init(page: OnboardingPage, index: Int) {
        self.page = page
        self.pageIndex = index
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bitcoinBlue

        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .bitcoinOrange
        if page.isSystemImage {
            let config = UIImage.SymbolConfiguration(pointSize: 120, weight: .regular)
            imageView.image = UIImage(systemName: page.imageName, withConfiguration: config)
        } else {
            imageView.image = UIImage(named: page.imageName)
            imageView.layer.cornerRadius = 28
            imageView.clipsToBounds = true
        }

        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont(name: "Avenir-Heavy", size: 26) ?? .boldSystemFont(ofSize: 26)
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.text = NSLocalizedString(page.titleKey, comment: "")

        let subtitleLabel = UILabel()
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont(name: "Avenir-Medium", size: 17) ?? .systemFont(ofSize: 17)
        subtitleLabel.textColor = UIColor.white.withAlphaComponent(0.85)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = NSLocalizedString(page.subtitleKey, comment: "")

        view.addSubview(imageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)

        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 60),
            imageView.widthAnchor.constraint(equalToConstant: 160),
            imageView.heightAnchor.constraint(equalToConstant: 160),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 32),
            titleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -32),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -32)
        ])
    }
}
