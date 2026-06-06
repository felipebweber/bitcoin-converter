//
//  OnboardingPageViewController.swift
//  bitcoin-converter
//

import UIKit

final class OnboardingPageViewController: UIViewController {

    var onFinish: (() -> Void)?

    private let pages: [OnboardingPage] = OnboardingPage.all
    private lazy var contentControllers: [OnboardingContentViewController] = pages.enumerated().map {
        OnboardingContentViewController(page: $0.element, index: $0.offset)
    }
    private var currentIndex: Int = 0

    private let pageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )

    private let pageControl = UIPageControl()
    private let skipButton = UIButton(type: .system)
    private let primaryButton = UIButton(type: .system)

    private let backgroundColor = UIColor.bitcoinBlue
    private let accentColor = UIColor.bitcoinOrange

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = backgroundColor

        addPageViewController()
        addSkipButton()
        addPageControl()
        addPrimaryButton()

        updateForIndex(0)
    }

    private func addPageViewController() {
        addChild(pageViewController)
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageViewController.view)
        pageViewController.didMove(toParent: self)

        pageViewController.dataSource = self
        pageViewController.delegate = self
        pageViewController.setViewControllers([contentControllers[0]], direction: .forward, animated: false)

        NSLayoutConstraint.activate([
            pageViewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func addSkipButton() {
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.setTitle(NSLocalizedString("onboarding.skip", comment: ""), for: .normal)
        skipButton.titleLabel?.font = UIFont(name: "Avenir-Medium", size: 16) ?? .systemFont(ofSize: 16)
        skipButton.setTitleColor(UIColor.white.withAlphaComponent(0.85), for: .normal)
        skipButton.addTarget(self, action: #selector(didTapFinish), for: .touchUpInside)
        view.addSubview(skipButton)
        NSLayoutConstraint.activate([
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            skipButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }

    private func addPageControl() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = UIColor.white.withAlphaComponent(0.3)
        pageControl.currentPageIndicatorTintColor = accentColor
        pageControl.isUserInteractionEnabled = false
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -88)
        ])
    }

    private func addPrimaryButton() {
        primaryButton.translatesAutoresizingMaskIntoConstraints = false
        primaryButton.backgroundColor = accentColor
        primaryButton.setTitleColor(.white, for: .normal)
        primaryButton.titleLabel?.font = UIFont(name: "Avenir-Heavy", size: 17) ?? .boldSystemFont(ofSize: 17)
        primaryButton.layer.cornerRadius = 26
        primaryButton.addTarget(self, action: #selector(didTapPrimary), for: .touchUpInside)
        view.addSubview(primaryButton)
        NSLayoutConstraint.activate([
            primaryButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32),
            primaryButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32),
            primaryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -24),
            primaryButton.heightAnchor.constraint(equalToConstant: 52)
        ])
    }

    private func updateForIndex(_ index: Int) {
        currentIndex = index
        pageControl.currentPage = index
        let isLast = index == pages.count - 1
        let key = isLast ? "onboarding.start" : "onboarding.next"
        primaryButton.setTitle(NSLocalizedString(key, comment: ""), for: .normal)
        skipButton.isHidden = isLast
    }

    @objc private func didTapPrimary() {
        if currentIndex == pages.count - 1 {
            didTapFinish()
            return
        }
        let next = currentIndex + 1
        pageViewController.setViewControllers(
            [contentControllers[next]],
            direction: .forward,
            animated: true
        ) { [weak self] _ in
            self?.updateForIndex(next)
        }
    }

    @objc private func didTapFinish() {
        onFinish?()
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? OnboardingContentViewController else { return nil }
        let prev = current.pageIndex - 1
        guard prev >= 0 else { return nil }
        return contentControllers[prev]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = viewController as? OnboardingContentViewController else { return nil }
        let next = current.pageIndex + 1
        guard next < contentControllers.count else { return nil }
        return contentControllers[next]
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed,
              let visible = pageViewController.viewControllers?.first as? OnboardingContentViewController else { return }
        updateForIndex(visible.pageIndex)
    }
}
