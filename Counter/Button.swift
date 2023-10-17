//
//  Button.swift
//  Counter
//
//  Created by Gleb Ivantsov on 15.10.2023.
//

import UIKit

final class Button: UIButton {
    
    struct Config {
                
        var configuration: UIButton.Configuration
        
        init(backgroundColor: UIColor, size: Size) {
            configuration = UIButton.Configuration.plain()
            var symbolConfiguration = UIImage.SymbolConfiguration(hierarchicalColor: .black)
            switch size {
            case .s:
                configuration.cornerStyle = .small
                configuration.buttonSize = .small
                symbolConfiguration = symbolConfiguration.applying(UIImage.SymbolConfiguration(pointSize: 16))
            case .m:
                configuration.cornerStyle = .medium
                configuration.buttonSize = .medium
                symbolConfiguration = symbolConfiguration.applying(UIImage.SymbolConfiguration(pointSize: 24))
            }
            configuration.preferredSymbolConfigurationForImage = symbolConfiguration
            configuration.background.backgroundColor = backgroundColor
        }
    }
    
    enum Size {
        case s
        case m
    }
    
    public var touchUpInside: (() -> Void)?
    
    private let config: Config
    
    init(backgroundColor: UIColor, size: Size) {
        config = Config(backgroundColor: backgroundColor, size: size)
        super.init(frame: .zero)
        configuration = config.configuration
        setupButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    private func setupButton() {
        addTarget(self, action: #selector(touch), for: .touchUpInside)
    }
    
    @objc
    private func touch() {
        touchUpInside?()
    }
}
