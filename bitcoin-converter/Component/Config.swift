//
//  Config.swift
//  bitcoin-converter
//
//  Created by Felipe Weber on 22/05/20.
//  Copyright © 2020 Felipe Weber. All rights reserved.
//

import UIKit

class Config: NSObject {

    func getUrlStandard() -> String? {
        guard let pathOfPlist = Bundle.main.path(forResource: "Info", ofType: "plist") else { return nil }
        guard let dictionary = NSDictionary(contentsOfFile: pathOfPlist) else { return nil }
        guard let urlStandard = dictionary["UrlStandard"] as? String else { return "" }
        return urlStandard
    }
}

extension UIColor {
    static let bitcoinOrange = UIColor(red: 236/255, green: 131/255, blue: 5/255, alpha: 1)
    static let bitcoinBlue = UIColor(red: 2/255, green: 76/255, blue: 170/255, alpha: 1)
    static let selectionBase = UIColor(red: 219/255, green: 211/255, blue: 211/255, alpha: 1)
}

final class SelectionGradientView: UIView {
    private let revealLayer = CALayer()
    private var progress: CGFloat = 0

    override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradient()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureGradient()
    }

    private func configureGradient() {
        isUserInteractionEnabled = false
        guard let gradientLayer = layer as? CAGradientLayer else { return }
        gradientLayer.colors = [
            UIColor.selectionBase.withAlphaComponent(0.72).cgColor,
            UIColor.selectionBase.withAlphaComponent(0).cgColor
        ]
        gradientLayer.locations = [0, 1]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        revealLayer.backgroundColor = UIColor.black.cgColor
        revealLayer.anchorPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.mask = revealLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateRevealFrame(animated: false)
    }

    func setProgress(_ progress: CGFloat,
                     animated: Bool,
                     duration: TimeInterval = 0.26,
                     completion: (() -> Void)? = nil) {
        self.progress = min(max(progress, 0), 1)
        updateRevealFrame(animated: animated, duration: duration, completion: completion)
    }

    private func updateRevealFrame(animated: Bool,
                                   duration: TimeInterval = 0.26,
                                   completion: (() -> Void)? = nil) {
        let targetWidth = bounds.width * progress
        let targetBounds = CGRect(x: 0, y: 0, width: targetWidth, height: bounds.height)
        let targetPosition = CGPoint(x: 0, y: bounds.midY)

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        if animated {
            let animation = CABasicAnimation(keyPath: "bounds.size.width")
            animation.fromValue = revealLayer.presentation()?.bounds.width ?? revealLayer.bounds.width
            animation.toValue = targetWidth
            animation.duration = duration
            animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            CATransaction.setCompletionBlock(completion)
            revealLayer.add(animation, forKey: "selectionReveal")
        } else {
            CATransaction.setCompletionBlock(completion)
        }

        revealLayer.bounds = targetBounds
        revealLayer.position = targetPosition
        CATransaction.commit()
    }
}
