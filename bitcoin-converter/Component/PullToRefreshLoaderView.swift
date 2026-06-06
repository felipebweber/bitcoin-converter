//
//  PullToRefreshLoaderView.swift
//  bitcoin-converter
//

import UIKit

final class PullToRefreshLoaderView: UIView {

    enum State: Equatable {
        case idle
        case pulling(progress: CGFloat, pullDistance: CGFloat)
        case armed(pullDistance: CGFloat)
        case loading
    }

    private enum Metrics {
        static let orbitSize: CGFloat = 74
        static let iconSize: CGFloat = 52
        static let iconCornerRadius: CGFloat = 14
        static let maxPullDistance: CGFloat = 128
        static let hiddenTranslationY: CGFloat = -46
    }

    private let contentStack = UIStackView()
    private let orbitView = UIView()
    private let shadowView = UIView()
    private let iconView = UIImageView()
    private let label = UILabel()
    private let orbitTrackLayer = CAShapeLayer()
    private let orbitProgressLayer = CAShapeLayer()

    private var currentState: State = .idle
    private var isReduceMotionEnabled: Bool {
        UIAccessibility.isReduceMotionEnabled
    }

    override var intrinsicContentSize: CGSize {
        CGSize(width: 140, height: 140)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        apply(state: .idle, animated: false)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        apply(state: .idle, animated: false)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let orbitBounds = orbitView.bounds.insetBy(dx: 3, dy: 3)
        let orbitPath = UIBezierPath(
            arcCenter: CGPoint(x: orbitBounds.midX, y: orbitBounds.midY),
            radius: orbitBounds.width / 2,
            startAngle: -.pi / 2,
            endAngle: 1.5 * .pi,
            clockwise: true
        )

        orbitTrackLayer.frame = orbitView.bounds
        orbitTrackLayer.path = orbitPath.cgPath

        orbitProgressLayer.frame = orbitView.bounds
        orbitProgressLayer.path = orbitPath.cgPath
    }

    func setState(_ state: State, animated: Bool = true) {
        apply(state: state, animated: animated)
    }

    private func configureView() {
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
        alpha = 0

        contentStack.axis = .vertical
        contentStack.alignment = .center
        contentStack.spacing = 8
        contentStack.translatesAutoresizingMaskIntoConstraints = false

        orbitView.translatesAutoresizingMaskIntoConstraints = false
        orbitView.backgroundColor = .clear

        shadowView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.backgroundColor = UIColor.bitcoinBlue.withAlphaComponent(0.18)
        shadowView.layer.cornerRadius = 4

        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.image = UIImage(named: "bitcoinRefreshIcon")
        iconView.contentMode = .scaleAspectFill
        iconView.layer.cornerRadius = Metrics.iconCornerRadius
        iconView.layer.masksToBounds = true
        iconView.layer.shadowColor = UIColor.black.cgColor
        iconView.layer.shadowOpacity = 0
        iconView.layer.shadowRadius = 0
        iconView.layer.shadowOffset = .zero

        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        label.textColor = UIColor.bitcoinBlue.withAlphaComponent(0.95)
        label.textAlignment = .center
        label.text = NSLocalizedString("refresh_pull_prompt", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false

        orbitTrackLayer.fillColor = UIColor.clear.cgColor
        orbitTrackLayer.strokeColor = UIColor.bitcoinBlue.withAlphaComponent(0.18).cgColor
        orbitTrackLayer.lineWidth = 4

        orbitProgressLayer.fillColor = UIColor.clear.cgColor
        orbitProgressLayer.strokeColor = UIColor.bitcoinOrange.cgColor
        orbitProgressLayer.lineWidth = 4
        orbitProgressLayer.lineCap = .round
        orbitProgressLayer.strokeEnd = 0.02

        orbitView.layer.addSublayer(orbitTrackLayer)
        orbitView.layer.addSublayer(orbitProgressLayer)
        orbitView.addSubview(shadowView)
        orbitView.addSubview(iconView)
        addSubview(contentStack)
        contentStack.addArrangedSubview(orbitView)
        contentStack.addArrangedSubview(label)

        NSLayoutConstraint.activate([
            contentStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentStack.centerYAnchor.constraint(equalTo: centerYAnchor),

            orbitView.widthAnchor.constraint(equalToConstant: Metrics.orbitSize),
            orbitView.heightAnchor.constraint(equalToConstant: Metrics.orbitSize),

            iconView.widthAnchor.constraint(equalToConstant: Metrics.iconSize),
            iconView.heightAnchor.constraint(equalToConstant: Metrics.iconSize),
            iconView.centerXAnchor.constraint(equalTo: orbitView.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: orbitView.centerYAnchor),

            shadowView.centerXAnchor.constraint(equalTo: orbitView.centerXAnchor),
            shadowView.bottomAnchor.constraint(equalTo: orbitView.bottomAnchor, constant: -4),
            shadowView.widthAnchor.constraint(equalToConstant: 42),
            shadowView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }

    private func apply(state: State, animated: Bool) {
        currentState = state

        switch state {
        case .idle:
            stopLoadingAnimations()
            updatePresentation(
                progress: 0,
                pullDistance: 0,
                labelText: NSLocalizedString("refresh_pull_prompt", comment: ""),
                animated: animated
            )
        case let .pulling(progress, pullDistance):
            stopLoadingAnimations()
            updatePresentation(
                progress: progress,
                pullDistance: pullDistance,
                labelText: NSLocalizedString("refresh_pull_prompt", comment: ""),
                animated: animated
            )
        case let .armed(pullDistance):
            stopLoadingAnimations()
            updatePresentation(
                progress: 1,
                pullDistance: pullDistance,
                labelText: NSLocalizedString("refresh_release_prompt", comment: ""),
                animated: animated
            )
        case .loading:
            updatePresentation(
                progress: 1,
                pullDistance: 112,
                labelText: NSLocalizedString("refresh_loading_prompt", comment: ""),
                animated: animated
            )
            startLoadingAnimationsIfNeeded()
        }
    }

    private func updatePresentation(progress rawProgress: CGFloat,
                                    pullDistance rawPullDistance: CGFloat,
                                    labelText: String,
                                    animated: Bool) {
        let progress = min(max(rawProgress, 0), 1)
        let pullDistance = min(max(rawPullDistance, 0), Metrics.maxPullDistance)
        let translateY = Metrics.hiddenTranslationY + pullDistance * 0.38
        let scale = 0.72 + progress * 0.28
        let iconTranslationY = (1 - progress) * 14
        let iconRotation = ((progress - 1) * -8) * (.pi / 180)
        let shadowScaleX = 0.62 + progress * 0.28
        let targetAlpha = min(1, progress * 1.4)

        let orbitTransform = CGAffineTransform(scaleX: scale, y: scale)
        let iconTransform = CGAffineTransform(translationX: 0, y: iconTranslationY).rotated(by: iconRotation)
        let shadowTransform = CGAffineTransform(scaleX: shadowScaleX, y: 1)
        let containerTransform = CGAffineTransform(translationX: 0, y: translateY)

        let updates = {
            self.alpha = targetAlpha
            self.accessibilityElementsHidden = targetAlpha < 0.05
            self.transform = containerTransform
            self.orbitView.transform = orbitTransform
            self.iconView.transform = iconTransform
            self.shadowView.transform = shadowTransform
            self.shadowView.alpha = 0.25 + progress * 0.5
            self.label.text = labelText
            self.orbitProgressLayer.strokeEnd = max(0.02, progress * 0.92)
            self.orbitProgressLayer.opacity = Float(0.35 + progress * 0.45)
        }

        if animated {
            UIView.animate(
                withDuration: 0.18,
                delay: 0,
                options: [.beginFromCurrentState, .curveEaseOut, .allowUserInteraction],
                animations: updates
            )
        } else {
            updates()
        }
    }

    private func startLoadingAnimationsIfNeeded() {
        stopLoadingAnimations()

        guard !isReduceMotionEnabled else { return }

        let rotation = CABasicAnimation(keyPath: "transform.rotation")
        rotation.fromValue = 0
        rotation.toValue = CGFloat.pi * 2
        rotation.duration = 1.12
        rotation.repeatCount = .infinity
        rotation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        orbitView.layer.add(rotation, forKey: "refresh.orbitRotation")

        let bounce = CAKeyframeAnimation(keyPath: "transform")
        bounce.values = [
            CATransform3DMakeRotation(-2 * (.pi / 180), 0, 0, 1),
            CATransform3DConcat(CATransform3DMakeTranslation(0, -13, 0),
                                CATransform3DConcat(CATransform3DMakeScale(0.96, 1.05, 1),
                                                    CATransform3DMakeRotation(4 * (.pi / 180), 0, 0, 1))),
            CATransform3DConcat(CATransform3DMakeTranslation(0, 2, 0),
                                CATransform3DConcat(CATransform3DMakeScale(1.08, 0.92, 1),
                                                    CATransform3DMakeRotation(-3 * (.pi / 180), 0, 0, 1))),
            CATransform3DMakeRotation(-2 * (.pi / 180), 0, 0, 1)
        ]
        bounce.keyTimes = [0, 0.42, 0.7, 1]
        bounce.duration = 0.76
        bounce.repeatCount = .infinity
        bounce.isRemovedOnCompletion = false
        iconView.layer.add(bounce, forKey: "refresh.iconBounce")

        let shadowScale = CAKeyframeAnimation(keyPath: "transform.scale.x")
        shadowScale.values = [0.9, 0.54, 1.04, 0.9]
        shadowScale.keyTimes = [0, 0.42, 0.7, 1]
        shadowScale.duration = 0.76
        shadowScale.repeatCount = .infinity
        shadowView.layer.add(shadowScale, forKey: "refresh.shadowScale")

        let shadowOpacity = CAKeyframeAnimation(keyPath: "opacity")
        shadowOpacity.values = [0.7, 0.36, 0.78, 0.7]
        shadowOpacity.keyTimes = [0, 0.42, 0.7, 1]
        shadowOpacity.duration = 0.76
        shadowOpacity.repeatCount = .infinity
        shadowView.layer.add(shadowOpacity, forKey: "refresh.shadowOpacity")
    }

    private func stopLoadingAnimations() {
        orbitView.layer.removeAnimation(forKey: "refresh.orbitRotation")
        iconView.layer.removeAnimation(forKey: "refresh.iconBounce")
        shadowView.layer.removeAnimation(forKey: "refresh.shadowScale")
        shadowView.layer.removeAnimation(forKey: "refresh.shadowOpacity")
    }
}
