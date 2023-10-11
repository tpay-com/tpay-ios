//
//  Copyright © 2022 Tpay. All rights reserved.
//

import UIKit

final class CardBrandView: UIView {
    
    // MARK: - Properties
    
    private let appearance: Appearance
    
    override var intrinsicContentSize: CGSize {
        appearance.intrinsicContentSize
    }
    
    private var brandImage: UIImage {
        didSet {
            imageView.image = brandImage
        }
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: brandImage)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Initializers
    
    init(brandImage: UIImage, appearance: Appearance = .large) {
        self.brandImage = brandImage
        self.appearance = appearance
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        setupLayout()
        setupAppearance()
    }
    
    // MARK: - API
    
    func set(brandImage: UIImage) {
        self.brandImage = brandImage
    }
    
    // MARK: - Private
    
    private func setupLayout() {
        imageView.layout
            .add(to: self)
            .top.equalTo(self, .top).with(constant: appearance.offset.horizontal)
            .bottom.equalTo(self, .bottom).with(constant: -appearance.offset.horizontal)
            .leading.equalTo(self, .leading).with(constant: appearance.offset.vertical)
            .trailing.equalTo(self, .trailing).with(constant: -appearance.offset.vertical)
            .activate()
    }
    
    private func setupAppearance() {
        backgroundColor = .Colors.Neutral.white.color
        
        layer.masksToBounds = true
        layer.cornerRadius = 4
        layer.borderColor = Asset.Colors.Neutral._200.color.cgColor
        layer.borderWidth = 1
        
        setContentHuggingPriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .horizontal)
    }
}
