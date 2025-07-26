//
//  AuthViewController.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 23.07.25.
//
import UIKit

final class AuthViewController: UIViewController {
    var onAuthSuccess: (() -> Void)?
    // MARK: - UI Elements
    
    private let scrollView = UIScrollView()
        private let contentView = UIView()
        
        private let logoImageView: UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "Logo1")
            iv.contentMode = .scaleAspectFit
            iv.backgroundColor = .clear
            iv.transform = CGAffineTransform(scaleX: 2, y: 2)
            return iv
        }()
        
        private let emailTextField = UnderlinedTextField()
        private let passwordTextField = UnderlinedTextField()
        
        private let loginButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Войти", for: .normal)
            btn.backgroundColor = .systemRed
            btn.setTitleColor(.white, for: .normal)
            btn.layer.cornerRadius = 8
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            return btn
        }()
        
        private let forgotPasswordButton: UIButton = {
            let btn = UIButton(type: .system)
            btn.setTitle("Забыли пароль?", for: .normal)
            btn.setTitleColor(.systemGray, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            return btn
        }()
        
        private let activityIndicator = UIActivityIndicatorView(style: .medium)
        
        private let messageBanner: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
            view.layer.cornerRadius = 12
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 8
            view.layer.shadowOffset = CGSize(width: 0, height: 4)
            view.isHidden = true
            view.transform = CGAffineTransform(translationX: 0, y: -100)
            return view
        }()
        
        private let messageLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
           super.viewDidLoad()
           setupViews()
           setupConstraints()
           setupObservers()
           setupGestureRecognizers()
       }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.isHidden = true
        
        scrollView.delaysContentTouches = false
        scrollView.canCancelContentTouches = true
        
        navigationItem.title = "Авторизация"
        
        emailTextField.placeholder = "Email"
           emailTextField.keyboardType = .emailAddress
           emailTextField.autocapitalizationType = .none
           emailTextField.returnKeyType = .next
           emailTextField.font = UIFont.systemFont(ofSize: 18)
           emailTextField.tintColor = .systemBlue
           emailTextField.leftIcon = UIImage(systemName: "envelope")
           
           passwordTextField.placeholder = "Пароль"
           passwordTextField.isSecureTextEntry = true
           passwordTextField.returnKeyType = .done
           passwordTextField.font = UIFont.systemFont(ofSize: 18)
           passwordTextField.tintColor = .systemBlue
           passwordTextField.leftIcon = UIImage(systemName: "lock")
           
           passwordTextField.rightIcon = UIImage(systemName: "eye.slash")
           passwordTextField.rightButtonAction = { [weak self] in
               guard let self = self else { return }
               self.passwordTextField.isSecureTextEntry.toggle()
               let imageName = self.passwordTextField.isSecureTextEntry ? "eye.slash" : "eye"
               self.passwordTextField.rightIcon = UIImage(systemName: imageName)
           }
            
            scrollView.showsVerticalScrollIndicator = false
            scrollView.keyboardDismissMode = .interactive
            
            [scrollView, contentView, logoImageView, emailTextField,
             passwordTextField, loginButton, forgotPasswordButton,
             activityIndicator, messageBanner, messageLabel].forEach {
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
            
        view.addSubview(scrollView)
            scrollView.addSubview(contentView)
            
            contentView.isUserInteractionEnabled = true
            
            [logoImageView, emailTextField, passwordTextField,
             loginButton, forgotPasswordButton, activityIndicator].forEach {
                contentView.addSubview($0)
                $0.isUserInteractionEnabled = true
            }
            
            view.addSubview(messageBanner)
            messageBanner.addSubview(messageLabel)
            
            loginButton.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
            forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
            
            emailTextField.delegate = self
            passwordTextField.delegate = self
        }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 150),
            logoImageView.heightAnchor.constraint(equalToConstant: 150),
            
            emailTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 40),
                    emailTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    emailTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    emailTextField.heightAnchor.constraint(equalToConstant: 50),
                    
                    passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 16),
                    passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
                    passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
                    passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            forgotPasswordButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 16),
            forgotPasswordButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 20),
            contentView.bottomAnchor.constraint(greaterThanOrEqualTo: activityIndicator.bottomAnchor, constant: 40),
            
            messageBanner.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            messageBanner.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            messageBanner.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            messageLabel.topAnchor.constraint(equalTo: messageBanner.topAnchor, constant: 16),
            messageLabel.leadingAnchor.constraint(equalTo: messageBanner.leadingAnchor, constant: 16),
            messageLabel.trailingAnchor.constraint(equalTo: messageBanner.trailingAnchor, constant: -16),
            messageLabel.bottomAnchor.constraint(equalTo: messageBanner.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Banner Methods
    
    private func showBanner(message: String, isError: Bool = true) {
        messageLabel.text = message
        messageBanner.backgroundColor = isError ?
            UIColor.systemRed.withAlphaComponent(0.9) :
            UIColor.systemGreen.withAlphaComponent(0.9)
        
        messageBanner.isHidden = false
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: {
            self.messageBanner.transform = .identity
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.hideBanner()
        }
    }
    
    private func hideBanner() {
        UIView.animate(withDuration: 0.3, animations: {
            self.messageBanner.transform = CGAffineTransform(translationX: 0, y: -100)
        }) { _ in
            self.messageBanner.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @objc private func handleLogin() {
        dismissKeyboard()
        
        guard validateFields() else { return }
        
        activityIndicator.startAnimating()
        loginButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.activityIndicator.stopAnimating()
            self?.loginButton.isEnabled = true
            
            if self?.emailTextField.text == "admin@example.com" &&
               self?.passwordTextField.text == "123456" {
                self?.showBanner(message: "Авторизация прошла успешно!", isError: false)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self?.onAuthSuccess?() // Вызываем обработчик успеха
                }
            } else {
                self?.showBanner(message: "Неверный логин или пароль")
            }
        }
    }
    @objc private func handleForgotPassword() {
        let alert = UIAlertController(
            title: "Восстановление пароля",
            message: "Введите ваш email для восстановления пароля",
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = "Email"
            textField.keyboardType = .emailAddress
        }
        
        alert.addAction(UIAlertAction(title: "Отправить", style: .default) { _ in
            if let email = alert.textFields?.first?.text, !email.isEmpty {
                self.showBanner(message: "Инструкции отправлены на \(email)")
            }
        })
        
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        
        present(alert, animated: true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let contentInsets = UIEdgeInsets(
            top: 0,
            left: 0,
            bottom: keyboardFrame.height - view.safeAreaInsets.bottom + 20,
            right: 0
        )
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillHide() {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Validation
    private func validateFields() -> Bool {
        guard let email = emailTextField.text, !email.isEmpty else {
            showBanner(message: "Введите email")
            return false
        }
        
        guard email.isValidEmail else {
            showBanner(message: "Введите корректный email")
            return false
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            showBanner(message: "Введите пароль")
            return false
        }
        
        guard password.count >= 6 else {
            showBanner(message: "Пароль должен содержать минимум 6 символов")
            return false
        }
        
        return true
    }
    
    private func navigateToMainScreen() {
        let mainVC = MainViewController()
        let navController = UINavigationController(rootViewController: mainVC)
        
        if let window = view.window ?? UIApplication.shared.connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: { $0.isKeyWindow }) {
            
            UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
                window.rootViewController = navController
            })
        }
    }
    
}

// MARK: - UITextFieldDelegate
extension AuthViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return true
    }
}

// MARK: - UIView Extension
extension UIView {
    func configure(_ config: (UIView) -> Void) {
        config(self)
    }
}

var onAuthSuccess: (() -> Void)?

private func handleSuccessfulAuth() {
        onAuthSuccess?()
    }
