//
//  SelectorTableViewCell.swift
//  bitcoin-converter
//

import UIKit

final class SelectorTableViewCell: UITableViewCell {

    @IBOutlet private weak var currencyLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    private let animatedSelectionView = SelectionGradientView()

    override func awakeFromNib() {
        super.awakeFromNib()
        tintColor = .bitcoinOrange
        animatedSelectionView.frame = contentView.bounds
        animatedSelectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.insertSubview(animatedSelectionView, at: 0)
        animatedSelectionView.setProgress(0, animated: false)
    }
    
    func setSelectorLabel(_ currency: String,_ description: String) {
        currencyLabel.text = currency
        descriptionLabel.text = description
    }

    func applySelectionState(isSelectedItem: Bool, animated: Bool = false) {
        accessoryType = isSelectedItem ? .checkmark : .none
        animatedSelectionView.setProgress(isSelectedItem ? 1 : 0, animated: animated)
        let primaryTextColor: UIColor = isSelectedItem ? .bitcoinBlue : .white
        let secondaryTextColor: UIColor = isSelectedItem ? UIColor.bitcoinBlue.withAlphaComponent(0.72) : .white
        if animated {
            UIView.animate(withDuration: 0.22) {
                self.currencyLabel.textColor = primaryTextColor
                self.descriptionLabel.textColor = secondaryTextColor
            }
        } else {
            currencyLabel.textColor = primaryTextColor
            descriptionLabel.textColor = secondaryTextColor
        }
    }
}
