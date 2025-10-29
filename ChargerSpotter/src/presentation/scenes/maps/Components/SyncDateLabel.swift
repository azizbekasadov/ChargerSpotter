//
//  SyncDateLabel.swift
//  ChargerSpotter
//
//  Created by Azizbek Asadov on 29.10.2025.
//

import UIKit

final class SyncDateLabel: UIView {
    
    private lazy var updateDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .headline)
        label.textColor = UIColor.label
        label.setContentHuggingPriority(.required, for: .horizontal)
        label.setContentHuggingPriority(.required, for: .vertical)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterial)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        blurView.layer.cornerRadius = 16
        blurView.clipsToBounds = true
        blurView.layer.borderWidth = 1
        blurView.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        return blurView
    }()
    
    var text: String? {
        didSet {
            if let text {
                updateDateLabel.text = "Updated: " + text
            }
            blurView.sizeToFit()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(blurView)
        blurView.contentView.addSubview(updateDateLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: self.topAnchor),
            blurView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            updateDateLabel.topAnchor.constraint(equalTo: blurView.topAnchor, constant: 6),
            updateDateLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -6),
            updateDateLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 12),
            updateDateLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -12),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
