// ProductCell.swift
import UIKit


class ProductCell: UICollectionViewCell {
    static let reuseIdentifier = "ProductCell"

    private let productImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = .systemGray5
        return iv
    }()
    
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()
    private let discountBadge = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        nameLabel.numberOfLines = 1
        
        descriptionLabel.font = UIFont.systemFont(ofSize: 14)
        descriptionLabel.textColor = .gray
        descriptionLabel.numberOfLines = 2
        
        priceLabel.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        discountBadge.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        discountBadge.textColor = .white
        discountBadge.backgroundColor = .systemRed
        discountBadge.textAlignment = .center
        discountBadge.layer.cornerRadius = 4
        discountBadge.clipsToBounds = true
        discountBadge.isHidden = true
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, priceLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        
        contentView.addSubview(imageView)
        contentView.addSubview(stackView)
        contentView.addSubview(discountBadge)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        discountBadge.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
               imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
               imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
               imageView.widthAnchor.constraint(equalToConstant: 132),
               imageView.heightAnchor.constraint(equalToConstant: 127),
               
               stackView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 12),
               stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
               stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
               
               discountBadge.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -8),
               discountBadge.topAnchor.constraint(equalTo: imageView.topAnchor, constant: 8),
               discountBadge.widthAnchor.constraint(equalToConstant: 40),
               discountBadge.heightAnchor.constraint(equalToConstant: 20)
           ])
    }
    
    func configure(with product: Product) {
        if let originalImage = UIImage(named: product.imageName) {
            let targetSize = CGSize(width: 200, height: 200)
            let resizedImage = originalImage.resized(to: targetSize)
            imageView.image = resizedImage
        }
        
        nameLabel.text = product.name
        descriptionLabel.text = product.descriptionText
        priceLabel.text = product.formattedPrice
        
        if let discount = product.discount {
            discountBadge.isHidden = false
            discountBadge.text = discount
        } else {
            discountBadge.isHidden = true
        }
    }
}

extension UIImage {
    enum ResizeMode {
        case aspectFill
        case aspectFit
    }
    
    func resized(to size: CGSize, mode: ResizeMode = .aspectFill) -> UIImage {
        let aspectWidth = size.width / self.size.width
        let aspectHeight = size.height / self.size.height
        let aspectRatio: CGFloat
        
        switch mode {
        case .aspectFill:
            aspectRatio = max(aspectWidth, aspectHeight)
        case .aspectFit:
            aspectRatio = min(aspectWidth, aspectHeight)
        }
        
        let newSize = CGSize(
            width: self.size.width * aspectRatio,
            height: self.size.height * aspectRatio
        )
        
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            let rect = CGRect(
                x: (size.width - newSize.width) / 2,
                y: (size.height - newSize.height) / 2,
                width: newSize.width,
                height: newSize.height
            )
            self.draw(in: rect)
        }
    }
}
