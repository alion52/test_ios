//
//  ProductDetailViewController..swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 25.07.25.
//
import UIKit

class ProductDetailViewController: UIViewController {
    
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: product.imageName)
        imageView.contentMode = .scaleAspectFit
        
        let nameLabel = UILabel()
        nameLabel.text = product.name
        nameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = product.descriptionText
        descriptionLabel.font = UIFont.systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        
        let priceLabel = UILabel()
        priceLabel.text = product.formattedPrice
        priceLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        
        let stackView = UIStackView(arrangedSubviews: [imageView, nameLabel, descriptionLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
}
