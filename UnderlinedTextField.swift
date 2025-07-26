//
//  UnderlinedTextField.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 24.07.25.

import UIKit

class UnderlinedTextField: UITextField {
    
    private let bottomLine = CALayer()
        private let leftIconView = UIImageView()
        private let rightButton = UIButton()
    
    var leftIcon: UIImage? {
            didSet {
                leftIconView.image = leftIcon
                leftIconView.isHidden = leftIcon == nil
                setNeedsLayout()
            }
        }
    
    var rightIcon: UIImage? {
            didSet {
                rightButton.setImage(rightIcon, for: .normal)
                rightButton.isHidden = rightIcon == nil
                setNeedsLayout()
            }
        }
        
        var rightButtonAction: (() -> Void)?
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
            setup()
        }
    
    private func setup() {
        borderStyle = .none
                font = UIFont.systemFont(ofSize: 16)
                textColor = .black
        
        layer.cornerRadius = 20
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
                
        leftIconView.contentMode = .scaleAspectFit
               leftIconView.tintColor = .gray
               leftView = leftIconView
               leftViewMode = .always
               
               rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
               rightView = rightButton
               rightViewMode = .always
               
               bottomLine.backgroundColor = UIColor.lightGray.cgColor
               layer.addSublayer(bottomLine)
           }
           
           @objc private func rightButtonTapped() {
               rightButtonAction?()
           }
           
           override func layoutSubviews() {
               super.layoutSubviews()
               
               let lineHeight: CGFloat = 1.0
               bottomLine.frame = CGRect(
                   x: 0,
                   y: bounds.height - lineHeight,
                   width: bounds.width,
                   height: lineHeight
               )
           }
           
           override func textRect(forBounds bounds: CGRect) -> CGRect {
               var rect = super.textRect(forBounds: bounds)
               let leftPadding = leftIcon != nil ? 40 : 16
               let rightPadding = rightIcon != nil ? 40 : 16
               rect.origin.x += CGFloat(leftPadding)
               rect.size.width -= CGFloat(leftPadding + rightPadding)
               return rect
           }
           
           override func editingRect(forBounds bounds: CGRect) -> CGRect {
               return textRect(forBounds: bounds)
           }
           
           override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
               return textRect(forBounds: bounds)
           }
           
           override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
               let iconSize: CGFloat = 20
               return CGRect(
                   x: 12,
                   y: (bounds.height - iconSize) / 2,
                   width: iconSize,
                   height: iconSize
               )
           }
           
           override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
               let iconSize: CGFloat = 20
               return CGRect(
                   x: bounds.width - iconSize - 12,
                   y: (bounds.height - iconSize) / 2,
                   width: iconSize,
                   height: iconSize
               )
           }
       }
