//
//  LoopCollectionsViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit

class CategoryView: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var loopCollectionsCV: UICollectionView!
    @IBOutlet weak var topProfileImage: UIImageView!
    
    var categoryData = CategoryData()
    var sectionData = SectionHeaderData()
    static let sectionHeaderElementKind = "section-header-element-kind"
    var dataSource: UICollectionViewDiffableDataSource<SectionHeaderModel, CategoryModel>!//SOURCE1
    var testDict: [String: [CategoryModel]] = [:]
    var cellStringReceived = ""
    var itemSelected = ""
    var userData: UserData?
    var headers = [SectionHeaderModel]()
    var categorySelected: CategoryModel?
    
    
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<SectionHeaderModel, CategoryModel> {
        var snapshot = NSDiffableDataSourceSnapshot<SectionHeaderModel, CategoryModel>()
        
        for section in headers {
            snapshot.appendSections([section])
            snapshot.appendItems(section.categories) // new data
        }
        return snapshot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveHeaders()
//        configureProfileImageView()
        //Build Section header stings
//        sectionData.makeSectionHeaders() //this can be replaced with just the enum
        //Build category objects in an array
        categoryData.getSubCategories()
        //zip section headers and catogory items to populate collectionView
//        categoryData.finalCategories = zip(sectionData.sectionHeaders, categoryData.subCategories).reduce(into: [:]) { $0[$1.0] = $1.1 }
        //print(categoryData.finalCategories)
        
        topProfileImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
        topProfileImage.layer.borderWidth = BorderSize.small.size
        topProfileImage.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        loopCollectionsCV.register(
            CategoryViewHeader.self, forSupplementaryViewOfKind: CategoryView.sectionHeaderElementKind, withReuseIdentifier: "Header")
            
        loopCollectionsCV.collectionViewLayout = configureLayout()
        configureDataSource()
    }
    
    func retrieveHeaders() {
        NetworkManager.shared.getSectionHeaders { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                self.headers = response
            case .failure(let failure):
                print(failure)
            }
        }
    }
    
//    func configureProfileImageView()  {
//        guard let url = userData?.imageURL else { return }
//        NetworkManager.shared.fetchUserProfileImageURL(photoURLString: url, imageView: topProfileImage)
//    }
    
    //MARK: - Compositional CV LAYOUT
    
    func configureLayout() -> UICollectionViewCompositionalLayout {
        let spacing: CGFloat = 5
        let grouItemCount = 3
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalWidth(0.3))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.25))

        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitem: item, count: grouItemCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        //for scrolling horizontal after the 3rd cell shows. 
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: CategoryView.sectionHeaderElementKind,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK: - Data Source (Cell)
    
    func configureDataSource() {//SOURCE2
        dataSource = UICollectionViewDiffableDataSource<SectionHeaderModel, CategoryModel>(collectionView: loopCollectionsCV) { (collectionView, indexPath, item) -> CategoryViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.reuseidentifier, for: indexPath) as? CategoryViewCell else {
                fatalError("Cannot create new cell")
            }
            cell.cellLabel.text = item.title
            cell.cellLabel.lineBreakMode = .byWordWrapping
            cell.cellLabel.numberOfLines = 3
            cell.backgroundColor = .black
            cell.layer.cornerRadius = CornerRadiusModifiers.small.size
            cell.layer.borderWidth = BorderSize.small.size
            cell.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
            cell.likeButton.setImage(UIImage(named: "heart"), for: .normal)
            
            //cell.delegate = self
            return cell
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! CategoryViewHeader
            
            header.label.text = self.headers[indexPath.section].headerTitle
            //header.label.font = UIFont(name: "Chalkduster", size: 18)
            header.label.textColor = UIColor.white
            
            return header
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<SectionHeaderModel, CategoryModel>()//SOURCE3
        
        for section in headers { //replace this with just enum (hashable)
            initialSnapshot.appendSections([section])
            initialSnapshot.appendItems(section.categories)
        }
       
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        //print(item.name)
        categorySelected = item
        performSegue(withIdentifier: SegueID.gotoAffirmationsView.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == SegueID.gotoAffirmationsView.rawValue {
            let destinationVC = segue.destination as! AffirmationsView
            //destinationVC.categoryReceived = itemSelected
            //destinationVC.userData = userData
            destinationVC.category = categorySelected 
        
        }
    }
}

//extension LoopCollectionsViewController: LoopCellDelegate {
//    func didLikeItem(_ item: String) {
//        cellStringReceived = item
//
//        for (key, var value) in itemsBySectionAndName {
//            if let index = value.firstIndex(of: item) {
//                // Remove the item if it exists in the value array
//                value.remove(at: index)
//                itemsBySectionAndName[key] = value
//                print("Removed '\(item)' from value for key '\(key)'")
//            }
//        }
//
//        testDict["Likes"]?.append(item)
//        self.dataSource.apply(self.filteredItemsSnapshot)
//
//        //print(itemsBySectionAndName)
//    }
//}

//category type
//name
//origin - so unlikes go back to category
//array with be category objects instead of stings.







//print(cellStringReceived)
//        if let key = itemsBySectionAndName.first(where: { $0.value.contains(cellStringReceived) })?.key {
//        }
