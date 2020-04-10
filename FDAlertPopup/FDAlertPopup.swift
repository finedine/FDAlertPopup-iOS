//
//  FDAlertPopup.swift
//  FDAlertPopup
//
//  Created by Emre Ertan on 27.03.2020.
//  Copyright © 2020 Emre Ertan. All rights reserved.
//

import UIKit
import SnapKit
import LGButton
import Lottie

public enum LottieTypes {
    case wait
    case success
    case fail
    case info
    case custom(_ resource: String)
}

public enum IconTypes {
    case success
    case fail
    case info
    case custom(_ resource: String)
}

public class FDAlertPopup: UIViewController {

    let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffect.Style.dark))
    let contentView = UIView()
    let animationView = AnimationView()
    let imageView = UIImageView()
    let stackView = UIStackView()
    let buttonStackView = UIStackView()

    let titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = hexToColor("333C4E")
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.numberOfLines = 0

        return label
    }()
    let bodyLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = hexToColor("333C4E")
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0

        return label
    }()
    let noteLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = hexToColor("333C4E")
        label.font = UIFont.italicSystemFont(ofSize: 18)
        label.numberOfLines = 0

        return label
    }()

    let confirmButton: LGButton = {
        let button = LGButton()
        button.cornerRadius = 25
        button.titleColor = hexToColor("E6034B")
        button.titleString = ""

        button.bgColor = hexToColor("E6034B")
        button.borderWidth = 1
        button.borderColor = .clear

        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 160, height: 50))
        }
        button.titleFontName = UIFont.boldSystemFont(ofSize: 20).fontName
        button.titleFontSize = UIFont.boldSystemFont(ofSize: 20).pointSize

        button.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)

        return button
    }()
    let cancelButton: LGButton = {
        let button = LGButton()
        button.cornerRadius = 25
        button.titleColor = hexToColor("6A6A6A")
        button.titleString = ""

        button.borderColor = hexToColor("6A6A6A")
        button.borderWidth = 1
        button.bgColor = .clear

        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 160, height: 50))
        }
        button.titleFontName = UIFont.boldSystemFont(ofSize: 20).fontName
        button.titleFontSize = UIFont.boldSystemFont(ofSize: 20).pointSize

        button.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)

        return button
    }()

    public var confirmAction: (() -> Void)?
    public var cancelAction: (() -> Void)?

    public var lottieResource: LottieTypes?
    public var iconResource: IconTypes?

    public var titleLabelFont: UIFont = UIFont.boldSystemFont(ofSize: 22) {
        didSet {
            titleLabel.font = titleLabelFont
        }
    }
    public var bodyLabelFont: UIFont = UIFont.systemFont(ofSize: 20) {
        didSet {
            bodyLabel.font = bodyLabelFont
        }
    }
    public var noteLabelFont: UIFont = UIFont.italicSystemFont(ofSize: 18) {
        didSet {
            noteLabel.font = noteLabelFont
        }
    }

    public var buttonsFont: UIFont = UIFont.boldSystemFont(ofSize: 20) {
        didSet {
            confirmButton.titleFontName = buttonsFont.fontName
            confirmButton.titleFontSize = buttonsFont.pointSize
            cancelButton.titleFontName = buttonsFont.fontName
            cancelButton.titleFontSize = buttonsFont.pointSize
        }
    }

    public var titleLabelColor: UIColor = hexToColor("333333") {
        didSet {
            titleLabel.textColor = titleLabelColor
        }
    }
    public var bodyLabelColor: UIColor = hexToColor("333333") {
        didSet {
            bodyLabel.textColor = bodyLabelColor
        }
    }
    public var noteLabelColor: UIColor = hexToColor("333333") {
        didSet {
            noteLabel.textColor = noteLabelColor
        }
    }

    public var titleText: String = ""
    public var bodyText: String = ""
    public var noteText: String = ""

    public var confirmButtonText: String = "" {
        didSet {
            confirmButton.titleString = confirmButtonText
        }
    }
    public var confirmButtonTitleColor: UIColor = hexToColor("E6034B") {
        didSet {
            confirmButton.titleColor = confirmButtonTitleColor
        }
    }
    public var confirmButtonBgColor: UIColor = hexToColor("E6034B") {
        didSet {
            confirmButton.bgColor = confirmButtonBgColor
        }
    }
    public var confirmButtonBorderColor: UIColor = .clear {
        didSet {
            confirmButton.borderColor = confirmButtonBorderColor
        }
    }

    public var cancelButtonText: String = "" {
        didSet {
            cancelButton.titleString = cancelButtonText
        }
    }
    public var cancelButtonTitleColor: UIColor = hexToColor("6A6A6A") {
        didSet {
            cancelButton.titleColor = cancelButtonTitleColor
        }
    }
    public var cancelButtonBgColor: UIColor = .clear {
        didSet {
            cancelButton.bgColor = cancelButtonBgColor
        }
    }
    public var cancelButtonBorderColor: UIColor = hexToColor("6A6A6A") {
        didSet {
            cancelButton.borderColor = cancelButtonBorderColor
        }
    }
}

public extension FDAlertPopup {

    @objc private func buttonsTapped(sender: LGButton!) {
        switch sender {
        case confirmButton:
            if let callback = self.confirmAction {
                callback()
                self.dismiss(animated: true, completion: nil)
            }
        default:
            if let callback = self.cancelAction {
                callback()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(blurEffectView)
        self.view.addSubview(contentView)
        self.contentView.backgroundColor = .white
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true

        self.stackView.axis = .vertical
        self.stackView.spacing = 15
        self.buttonStackView.spacing = 15

        blurEffectView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }

        self.contentView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(380)
            make.center.equalToSuperview()
        }
    }

    func display() {
        let bundle = Bundle(for: FDAlertPopup.self)

        if lottieResource != nil {
            switch lottieResource {
            case .success:
                animationView.animation = Animation.filepath(bundle.path(forResource: "success", ofType: "json") ?? "")
            case .fail:
                animationView.animation = Animation.filepath(bundle.path(forResource: "fail", ofType: "json") ?? "")
            case .info:
                animationView.animation = Animation.filepath(bundle.path(forResource: "info", ofType: "json") ?? "")
            case .wait:
                animationView.animation = Animation.filepath(bundle.path(forResource: "wait", ofType: "json") ?? "")
                animationView.loopMode = .loop
            case .custom(let resource):
                animationView.animation = Animation.named(resource)
            case .none:
                animationView.animation = Animation.named("")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animationView.play()
            }

            self.contentView.addSubview(animationView)
            animationView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.contentView.snp.top).offset(35)
                make.centerX.equalTo(self.contentView.snp.centerX)
                make.size.equalTo(CGSize(width: 80, height: 80))
            }
        } else if iconResource != nil {
            imageView.contentMode = .scaleAspectFit

            switch iconResource {
            case .success:
                imageView.image = UIImage(named: "success", in: bundle, compatibleWith: nil)
            case .fail:
                imageView.image = UIImage(named: "fail", in: bundle, compatibleWith: nil)
            case .info:
                imageView.image = UIImage(named: "info", in: bundle, compatibleWith: nil)
            case .custom(let resource):
                imageView.image = UIImage(named: resource)
            case .none:
                imageView.image = UIImage(named: "")
            }

            self.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.contentView.snp.top).offset(35)
                make.centerX.equalTo(self.contentView.snp.centerX)
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
        }

        self.contentView.addSubview(stackView)

        if titleText != "" {
            titleLabel.text = titleText
            stackView.addArrangedSubview(titleLabel)
        }
        if bodyText != "" {
            bodyLabel.text = bodyText
            stackView.addArrangedSubview(bodyLabel)
        }
        if noteText != "" {
            noteLabel.text = noteText
            stackView.addArrangedSubview(noteLabel)
        }

        stackView.snp.makeConstraints { (make) -> Void in
            if lottieResource != nil {
                make.top.equalTo(self.animationView.snp.bottom).offset(10)
            } else if iconResource != nil {
                make.top.equalTo(self.imageView.snp.bottom).offset(10)
            } else {
                make.top.equalTo(self.contentView.snp.top).offset(35)
            }
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.leading.greaterThanOrEqualTo(self.contentView.snp.leading).offset(35)
            make.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(-35)
        }

        if cancelButtonText != "" || confirmButtonText != "" {
            self.contentView.addSubview(buttonStackView)
            if cancelButtonText != "" {
                self.buttonStackView.addArrangedSubview(cancelButton)
            }
            if confirmButtonText != "" {
                self.buttonStackView.addArrangedSubview(confirmButton)
            }

            buttonStackView.snp.makeConstraints { (make) -> Void in
                if self.stackView.subviews.count > 0 {
                    make.top.equalTo(self.stackView.snp.bottom).offset(25)
                } else if lottieResource != nil {
                    make.top.equalTo(self.animationView.snp.bottom).offset(25)
                } else if iconResource != nil {
                    make.top.equalTo(self.imageView.snp.bottom).offset(25)
                } else {
                    make.top.equalTo(self.contentView.snp.top).offset(35)
                }

                make.centerX.equalTo(self.contentView.snp.centerX)
                make.leading.greaterThanOrEqualTo(self.contentView.snp.leading).offset(35)
                make.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(-35)
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-35)
            }
        } else {
            stackView.snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(self.contentView.snp.bottom).offset(-35)
            }
        }

        if lottieResource == nil, iconResource == nil, titleText == "", bodyText == "", noteText == "", cancelButtonText == "", confirmButtonText == "" {

        } else {
            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
            UIApplication.getTopViewController()?.present(self, animated: true, completion: nil)
        }
    }
}

extension FDAlertPopup {
    static func hexToColor(_ hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }

        if (cString.count) != 6 {
            return UIColor.gray
        }

        var rgbValue: UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

extension UIApplication {

    /// Returns the top most UIViewController
    /// - Parameter base: Base view controller
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopViewController(base: nav.visibleViewController)

        } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
            return getTopViewController(base: selected)

        } else if let presented = base?.presentedViewController {
            return getTopViewController(base: presented)
        }
        return base
    }
}