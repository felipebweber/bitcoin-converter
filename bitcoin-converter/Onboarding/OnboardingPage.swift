//
//  OnboardingPage.swift
//  bitcoin-converter
//

import UIKit

struct OnboardingPage {
    let imageName: String
    let isSystemImage: Bool
    let titleKey: String
    let subtitleKey: String

    static let all: [OnboardingPage] = [
        OnboardingPage(
            imageName: "AppIcon",
            isSystemImage: false,
            titleKey: "onboarding.slide1.title",
            subtitleKey: "onboarding.slide1.subtitle"
        ),
        OnboardingPage(
            imageName: "list.bullet.rectangle.portrait.fill",
            isSystemImage: true,
            titleKey: "onboarding.slide2.title",
            subtitleKey: "onboarding.slide2.subtitle"
        ),
        OnboardingPage(
            imageName: "square.grid.2x2.fill",
            isSystemImage: true,
            titleKey: "onboarding.slide3.title",
            subtitleKey: "onboarding.slide3.subtitle"
        )
    ]
}
