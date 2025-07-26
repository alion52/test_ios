//
//  MainViewController.swift
//  FoodDeliveryApp
//
//  Created by AleksandrKr on 23.07.25.
//
import UIKit

class MainViewController: UIViewController {
    
    // MARK: - Data Models
    struct Banner {
        let imageName: String
    }
    
    struct Category {
        let id: String
        let name: String
    }
    
    
    // MARK: - Constants
    private enum Constants {
        static let bannerHeight: CGFloat = 160
        static let productCellHeight: CGFloat = 120
        static let categoryHeight: CGFloat = 40
        static let horizontalPadding: CGFloat = 16
    }
    
    // MARK: - Properties
    private let banners: [Banner] = [
        Banner(imageName: "Banner1"),
        Banner(imageName: "Banner2"),
        Banner(imageName: "Banner3")
    ]
    
    private var categories: [Category] = [
        Category(id: "1", name: "Пицца"),
        Category(id: "2", name: "Комбо"),
        Category(id: "3", name: "Десерты"),
        Category(id: "4", name: "Напитки")
    ]
    
    private var products: [String: [Product]] = [
        "1": [
            Product(
                id: "101",
                name: "Ветчина и грибы",
                descriptionText: "Ветчина, шампиньоны, увеличенная порция моцареллы, томатный соус",
                price: 345,
                imageName: "Pizza1",
                discount: "30%"
            ),
            Product(
                id: "102",
                name: "Баварские колбаски",
                descriptionText: "Баварские колбаски, ветчина, пикантная пепперони, острая чоризо, моцарелла, томатный соус",
                price: 345,
                imageName: "Pizza2",
                discount: nil
            ),
            Product(
                id: "103",
                name: "Нежный лосось",
                descriptionText: "Лосось, томаты черри, моцарелла, соус песто",
                price: 459,
                imageName: "Pizza3",
                discount: "20%"
            )
        ],
        "2": [
            Product(
                id: "201",
                name: "Комбо #1",
                descriptionText: "Пицца + напиток + картофель фри",
                price: 599,
                imageName: "Combo1",
                discount: "15%"
            ),
            Product(
                id: "202",
                name: "Комбо #2",
                descriptionText: "2 пиццы + 2 напитка + соус",
                price: 899,
                imageName: "Combo2",
                discount: "20%"
            ),
            Product(
                id: "203",
                name: "Семейный набор",
                descriptionText: "3 пиццы, 3 напитка, картофель фри и наггетсы",
                price: 1299,
                imageName: "Combo3",
                discount: "25%"
            )
        ],
        "3": [
            Product(
                id: "301",
                name: "Тирамису",
                descriptionText: "Классический итальянский десерт",
                price: 199,
                imageName: "Dessert1",
                discount: nil
            ),
            Product(
                id: "302",
                name: "Чизкейк",
                descriptionText: "Нежный чизкейк с ягодным соусом",
                price: 249,
                imageName: "Dessert2",
                discount: "10%"
            ),
            Product(
                id: "303",
                name: "Шоколадный фондан",
                descriptionText: "Тёплый шоколадный кекс с жидкой серединкой",
                price: 179,
                imageName: "Dessert3",
                discount: nil
            )
        ],
        "4": [
            Product(
                id: "401",
                name: "Кола",
                descriptionText: "Газированный напиток 0.5л",
                price: 99,
                imageName: "Drink1",
                discount: nil
            ),
            Product(
                id: "402",
                name: "Апельсиновый сок",
                descriptionText: "Свежевыжатый сок 0.3л",
                price: 149,
                imageName: "Drink2",
                discount: nil
            ),
            Product(
                id: "403",
                name: "Мохито",
                descriptionText: "Освежающий безалкогольный коктейль",
                price: 179,
                imageName: "Drink3",
                discount: "5%"
            )
        ]
    ]
    
    private var selectedCategoryIndex = 0
    
    // MARK: - UI Elements
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { [weak self] section, _ in
            self?.layout(for: section)
        }
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .systemBackground
        cv.delegate = self
        cv.dataSource = self
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    private let stickyHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.isHidden = true
        return view
    }()
    
    private let stickyCategoriesView = CategoriesView()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupCollectionView()
        setupNavigationBar()
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
            navigationItem.title = "Меню"
            navigationController?.navigationBar.prefersLargeTitles = false
            
            let cartButton = UIBarButtonItem(
                image: UIImage(systemName: "cart"),
                style: .plain,
                target: self,
                action: #selector(cartButtonTapped)
            )
            navigationItem.rightBarButtonItem = cartButton
        }
    
    private func setupViews() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(collectionView)
        view.addSubview(stickyHeaderView)
        stickyHeaderView.addSubview(stickyCategoriesView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        stickyHeaderView.translatesAutoresizingMaskIntoConstraints = false
        stickyCategoriesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stickyHeaderView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stickyHeaderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stickyHeaderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stickyHeaderView.heightAnchor.constraint(equalToConstant: Constants.categoryHeight),
            
            stickyCategoriesView.topAnchor.constraint(equalTo: stickyHeaderView.topAnchor),
            stickyCategoriesView.leadingAnchor.constraint(equalTo: stickyHeaderView.leadingAnchor),
            stickyCategoriesView.trailingAnchor.constraint(equalTo: stickyHeaderView.trailingAnchor),
            stickyCategoriesView.bottomAnchor.constraint(equalTo: stickyHeaderView.bottomAnchor)
        ])
        
        stickyCategoriesView.configure(with: categories.map { $0.name })
        stickyCategoriesView.didSelectCategory = { [weak self] index in
            self?.scrollToCategory(index: index)
        }
    }
    
    private func setupCollectionView() {
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.reuseIdentifier)
        collectionView.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.reuseIdentifier)
        collectionView.register(ProductCell.self, forCellWithReuseIdentifier: ProductCell.reuseIdentifier)
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier
        )
    }
    
    // MARK: - Actions
    @objc private func cartButtonTapped() {
        
    }
    
    private func scrollToCategory(index: Int) {
        selectedCategoryIndex = index
        let section = index + 2
        collectionView.scrollToItem(
            at: IndexPath(item: 0, section: section),
            at: .top,
            animated: true
        )
    }
}

// MARK: - UICollectionViewDataSource
extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2 + categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0: return banners.count
        case 1: return categories.count
        default:
            let category = categories[section - 2]
            return products[category.id]?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.reuseIdentifier, for: indexPath) as! BannerCell
            cell.configure(with: banners[indexPath.item].imageName)
            return cell
            
        case 1:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseIdentifier, for: indexPath) as! CategoryCell
            cell.configure(with: categories[indexPath.item].name, isSelected: indexPath.item == selectedCategoryIndex)
            return cell
            
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCell.reuseIdentifier, for: indexPath) as! ProductCell
            let category = categories[indexPath.section - 2]
            if let product = products[category.id]?[indexPath.item] {
                cell.configure(with: product)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader, indexPath.section > 1 else {
            return UICollectionReusableView()
        }
        
        let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: SectionHeaderView.reuseIdentifier,
            for: indexPath) as! SectionHeaderView
        
        let category = categories[indexPath.section - 2]
        header.configure(with: category.name)
        return header
    }
}

// MARK: - UICollectionViewDelegate
extension MainViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let categorySectionFrame = collectionView.layoutAttributesForItem(at: IndexPath(item: 0, section: 1))?.frame ?? .zero
        let offsetY = scrollView.contentOffset.y
        
        stickyHeaderView.isHidden = offsetY < categorySectionFrame.minY
        
        guard offsetY > categorySectionFrame.minY else { return }
        
        let visibleSections = collectionView.indexPathsForVisibleItems
            .map { $0.section }
            .filter { $0 > 1 }
        
        guard let firstVisibleSection = visibleSections.min() else { return }
        let newSelectedIndex = firstVisibleSection - 2
        
        if newSelectedIndex != selectedCategoryIndex {
            selectedCategoryIndex = newSelectedIndex
            stickyCategoriesView.selectCategory(at: newSelectedIndex)
            
            collectionView.indexPathsForVisibleItems
                .filter { $0.section == 1 }
                .forEach { indexPath in
                    if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCell {
                        cell.configure(with: categories[indexPath.item].name,
                                     isSelected: indexPath.item == selectedCategoryIndex)
                    }
                }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            selectedCategoryIndex = indexPath.item
            stickyCategoriesView.selectCategory(at: selectedCategoryIndex)
            scrollToCategory(index: selectedCategoryIndex)
        } else if indexPath.section > 1 {
            let category = categories[indexPath.section - 2]
            if let product = products[category.id]?[indexPath.item] {
                showProductDetail(product)
            }
        }
    }
    
    private func showProductDetail(_ product: Product) {
        let detailVC = ProductDetailViewController()
        detailVC.product = product
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - Compositional Layout
extension MainViewController {
    private func layout(for section: Int) -> NSCollectionLayoutSection {
        switch section {
        case 0: return createBannersSection()
        case 1: return createCategoriesSection()
        default: return createProductsSection()
        }
    }
    
    private func createBannersSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.9),
                                              heightDimension: .absolute(Constants.bannerHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets = .init(top: 16, leading: Constants.horizontalPadding,
                                    bottom: 24, trailing: Constants.horizontalPadding)
        section.interGroupSpacing = Constants.horizontalPadding
        
        return section
    }
    
    private func createCategoriesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                             heightDimension: .absolute(Constants.categoryHeight))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(100),
                                              heightDimension: .absolute(Constants.categoryHeight))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 16, leading: Constants.horizontalPadding,
                                    bottom: 16, trailing: Constants.horizontalPadding)
        section.interGroupSpacing = 12
        
        return section
    }
    
    private func createProductsSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(180)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(Constants.productCellHeight))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: 16, leading: Constants.horizontalPadding,
                                    bottom: 16, trailing: Constants.horizontalPadding)
        section.interGroupSpacing = 12
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return section
    }
}
