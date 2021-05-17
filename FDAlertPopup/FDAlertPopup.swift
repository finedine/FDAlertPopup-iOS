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
    var animationView: AnimationView?
    var lottieFallback = UIImageView()
    let imageView = UIImageView()
    let stackView = UIStackView()
    let buttonStackView = UIStackView()

    let titleLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = hexToColor("333C4E")
        label.font = UIFont(name: "NunitoSans-SemiBold", size: 24)
        label.numberOfLines = 0

        return label
    }()
    let bodyLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = hexToColor("333C4E")
        label.font = UIFont(name: "NunitoSans-Regular", size: 20)
        label.numberOfLines = 0

        return label
    }()
    let noteLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = hexToColor("333C4E")
        label.font = UIFont(name: "NunitoSans-Italic", size: 18)
        label.numberOfLines = 0

        return label
    }()

    let confirmButton: LGButton = {
        let button = LGButton()
        button.cornerRadius = 25
        button.titleColor = .white
        button.titleString = ""

        button.bgColor = hexToColor("E6034B")
        button.borderWidth = 1
        button.borderColor = .clear

        button.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 160, height: 50))
        }
        button.titleFontName = (UIFont(name: "NunitoSans-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)).fontName
        button.titleFontSize = (UIFont(name: "NunitoSans-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)).pointSize

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
        button.titleFontName = (UIFont(name: "NunitoSans-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)).fontName
        button.titleFontSize = (UIFont(name: "NunitoSans-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20)).pointSize

        button.addTarget(self, action: #selector(buttonsTapped), for: .touchUpInside)

        return button
    }()

    public var confirmAction: (() -> Void)?
    public var cancelAction: (() -> Void)?

    public var lottieResource: LottieTypes? = nil {
        didSet {
            self.initializeLottieView()
        }
    }
    public var iconResource: IconTypes? = nil {
        didSet {
            self.initializeIconView()
        }
    }

    public var titleLabelFont: UIFont = UIFont(name: "NunitoSans-SemiBold", size: 24) ?? UIFont.boldSystemFont(ofSize: 22) {
        didSet {
            titleLabel.font = titleLabelFont
        }
    }
    public var bodyLabelFont: UIFont = UIFont(name: "NunitoSans-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20) {
        didSet {
            bodyLabel.font = bodyLabelFont
        }
    }
    public var noteLabelFont: UIFont = UIFont(name: "NunitoSans-Italic", size: 18) ?? UIFont.italicSystemFont(ofSize: 20) {
        didSet {
            noteLabel.font = noteLabelFont
        }
    }
    public var buttonsFont: UIFont = UIFont(name: "NunitoSans-Bold", size: 20) ?? UIFont.boldSystemFont(ofSize: 20) {
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

    public var titleText: String = "" {
        didSet {
            self.initializeLabels()
        }
    }
    public var bodyText: String = "" {
        didSet {
            self.initializeLabels()
        }
    }
    public var noteText: String = "" {
        didSet {
            self.initializeLabels()
        }
    }

    public var confirmButtonText: String = "" {
        didSet {
            confirmButton.titleString = confirmButtonText
            if view.superview != nil {
                checkButtons()
            }
        }
    }
    public var confirmButtonTitleColor: UIColor = .white {
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
            if view.superview != nil {
                checkButtons()
            }
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
        self.buttonStackView.distribution = .fillEqually

        blurEffectView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }

        self.contentView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(380)
            make.center.equalToSuperview()
        }
    }

    func display() {
        if lottieResource != nil {

            if #available(iOS 10.0, *) {
                animationView = AnimationView()
                self.contentView.addSubview(animationView!)
                initializeLottieView()

                animationView?.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(self.contentView.snp.top).offset(35)
                    make.centerX.equalTo(self.contentView.snp.centerX)
                    make.size.equalTo(CGSize(width: 80, height: 80))
                }
            } else {
                self.contentView.addSubview(lottieFallback)
                lottieFallback.contentMode = .scaleAspectFit
                initializeLottieView()
                lottieFallback.snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(self.contentView.snp.top).offset(35)
                    make.centerX.equalTo(self.contentView.snp.centerX)
                    make.size.equalTo(CGSize(width: 80, height: 80))
                }
            }
        } else if iconResource != nil {

            self.contentView.addSubview(imageView)
            initializeIconView()

            imageView.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(self.contentView.snp.top).offset(35)
                make.centerX.equalTo(self.contentView.snp.centerX)
                make.size.equalTo(CGSize(width: 40, height: 40))
            }
        }

        self.contentView.addSubview(stackView)
        self.initializeLabels()

        stackView.snp.makeConstraints { (make) -> Void in
            if lottieResource != nil {
                if let animation = self.animationView {
                    make.top.equalTo(animation.snp.bottom).offset(10)
                } else {
                    make.top.equalTo(lottieFallback.snp.bottom).offset(10)
                }
            } else if iconResource != nil {
                make.top.equalTo(self.imageView.snp.bottom).offset(10)
            } else {
                make.top.equalTo(self.contentView.snp.top).offset(35)
            }
            make.centerX.equalTo(self.contentView.snp.centerX)
            make.leading.greaterThanOrEqualTo(self.contentView.snp.leading).offset(35)
            make.trailing.lessThanOrEqualTo(self.contentView.snp.trailing).offset(-35)
        }

        checkButtons()

        if lottieResource == nil, iconResource == nil, titleText == "", bodyText == "", noteText == "", cancelButtonText == "", confirmButtonText == "" {

        } else {
            self.modalPresentationStyle = .overFullScreen
            self.modalTransitionStyle = .crossDissolve
            UIApplication.getTopViewController()?.present(self, animated: true, completion: nil)
        }
    }

    private func initializeLabels() {
        if self.stackView.superview != nil {
            if stackView.subviews.count > 0 {
                stackView.subviews.forEach { view in
                    view.removeFromSuperview()
                }
            }

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
        }
    }

    private func initializeLottieView() {
        if self.animationView?.superview != nil || self.lottieFallback.superview != nil {

            let bundle = Bundle(for: FDAlertPopup.self)
            animationView?.loopMode = .playOnce
            switch lottieResource {
            case .success:
                animationView?.animation = Animation.filepath(bundle.path(forResource: "success", ofType: "json") ?? "")
                lottieFallback.image = UIImage(named: "success", in: bundle, compatibleWith: nil)
            case .fail:
                animationView?.animation = Animation.filepath(bundle.path(forResource: "fail", ofType: "json") ?? "")
                lottieFallback.image = UIImage(named: "fail", in: bundle, compatibleWith: nil)
            case .info:
                animationView?.animation = Animation.filepath(bundle.path(forResource: "info", ofType: "json") ?? "")
                lottieFallback.image = UIImage(named: "info", in: bundle, compatibleWith: nil)
            case .wait:
                animationView?.animation = Animation.filepath(bundle.path(forResource: "wait", ofType: "json") ?? "")
                animationView?.loopMode = .loop
            case .custom(let resource):
                animationView?.animation = Animation.named(resource)
            case .none:
                animationView?.animation = Animation.named("")
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.animationView?.play()
            }
        }
    }

    private func initializeIconView() {
        if imageView.superview != nil {
            let bundle = Bundle(for: FDAlertPopup.self)
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
        }
    }

    private func checkButtons() {
        self.buttonStackView.subviews.forEach { view in
            view.removeFromSuperview()
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
                    if let animation = self.animationView {
                        make.top.equalTo(animation.snp.bottom).offset(25)
                    } else {
                        make.top.equalTo(lottieFallback.snp.bottom).offset(25)
                    }
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
