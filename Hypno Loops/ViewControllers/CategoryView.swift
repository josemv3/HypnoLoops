//
//  LoopCollectionsViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit

class CategoryView: UIViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var loopCollectionsCV: UICollectionView!
    @IBOutlet weak var TopProfileImage: UIImageView!
    
    var categoryData = CategoryData()
    var sectionData = SectionHeaderData()
    static let sectionHeaderElementKind = "section-header-element-kind"
    var dataSource: UICollectionViewDiffableDataSource<String, CategoryItem>!//SOURCE1
    var testDict: [String: [CategoryItem]] = [:]
    var cellStringReceived = ""
    var itemSelected = ""
    
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<String, CategoryItem> {
        var snapshot = NSDiffableDataSourceSnapshot<String, CategoryItem>()
        
        for section in sectionData.sectionHeaders {
            snapshot.appendSections([section])
            snapshot.appendItems(categoryData.finalCategories[section]!) // new data
        }
        return snapshot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Build Section header stings
        sectionData.makeSectionHeaders() //this can be replaced with just the enum
        //Build category objects in an array
        categoryData.getSubCategories()
        //zip section headers and catogory items to populate collectionView
        categoryData.finalCategories = zip(sectionData.sectionHeaders, categoryData.subCategories).reduce(into: [:]) { $0[$1.0] = $1.1 }
        print(categoryData.finalCategories)
        
        TopProfileImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
        TopProfileImage.layer.borderWidth = BorderSize.small.size
        TopProfileImage.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
        
        loopCollectionsCV.register(
            CategoryViewHeader.self, forSupplementaryViewOfKind: CategoryView.sectionHeaderElementKind, withReuseIdentifier: "Header")
            
        loopCollectionsCV.collectionViewLayout = configureLayout()
        configureDataSource()
    }
    
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
        dataSource = UICollectionViewDiffableDataSource<String, CategoryItem>(collectionView: loopCollectionsCV) { (collectionView, indexPath, item) -> CategoryViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryViewCell.reuseidentifier, for: indexPath) as? CategoryViewCell else {
                fatalError("Cannot create new cell")
            }
            cell.cellLabel.text = item.name
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
            
            header.label.text = String(self.sectionData.sectionHeaders[indexPath.section])
            //header.label.font = UIFont(name: "Chalkduster", size: 18)
            header.label.textColor = UIColor.white
            
            return header
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<String, CategoryItem>()//SOURCE3
        
        for section in sectionData.sectionHeaders { //replace this with just enum (hashable)
            initialSnapshot.appendSections([section])
            initialSnapshot.appendItems(categoryData.finalCategories[section]!)
        }
       
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        print(item.name)
        
        if item.name == "Self healing" {
            performSegue(withIdentifier: SegueID.gotoRecord.rawValue, sender: self)
        } else {
            itemSelected = item.name
            performSegue(withIdentifier: SegueID.gotoAffirmationsView.rawValue, sender: self)
            
            
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueID.gotoAffirmationsView.rawValue {
            let destinationVC = segue.destination as! AffirmationsView
            destinationVC.categoryReceived = itemSelected
            
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
