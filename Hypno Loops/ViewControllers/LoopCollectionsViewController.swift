//
//  LoopCollectionsViewController.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 1/20/23.
//

import UIKit

private var setA = [
    "airplane", "ball", "car",
    "drum", "earphones", "flower",
    "ghost", "home", "icecream",
    "juice", "ketchup", "lightning",
    "moon", "nuts","oven"]


class LoopCollectionsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var loopCollectionsCV: UICollectionView!
    @IBOutlet weak var TopProfileImage: UIImageView!
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    var dataSource: UICollectionViewDiffableDataSource<String, String>!//SOURCE1
    private var currentSet = setA
    var headerSetA = ["Likes", "Health", "Love", "Goals", "Mental Stability"]
    var itemsBySectionAndName: [String: [String]] = ["Likes": [], "Health": ["drum", "earphones", "flower", "test", "another"], "Love": ["ghost", "home", "icecream"], "Goals": ["juice", "ketchup", "lightning"], "Mental Stability": ["moon", "nuts","oven"]]
    var cellStringReceived = ""
//    enum Section {
//        case main
//    }
    
    var filteredItemsSnapshot: NSDiffableDataSourceSnapshot<String, String> {
        var snapshot = NSDiffableDataSourceSnapshot<String, String>()
        
        for section in headerSetA {
            snapshot.appendSections([section])
            snapshot.appendItems(itemsBySectionAndName[section]!) // new data
        }
        return snapshot
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TopProfileImage.layer.cornerRadius = CornerRadiusModifiers.normal.size
        TopProfileImage.layer.borderWidth = 2
        TopProfileImage.layer.borderColor = UIColor(named: "New Blue")?.cgColor
        
        loopCollectionsCV.register(
            LoopCollectionViewSectionHeader.self, forSupplementaryViewOfKind: LoopCollectionsViewController.sectionHeaderElementKind, withReuseIdentifier: "Header")
            
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
            elementKind: LoopCollectionsViewController.sectionHeaderElementKind,
            alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK: - Data Source (Cell)
    
    func configureDataSource() {//SOURCE2
        dataSource = UICollectionViewDiffableDataSource<String, String>(collectionView: loopCollectionsCV) { (collectionView, indexPath, item) -> LoopCollecttionsCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoopCollecttionsCell.reuseidentifier, for: indexPath) as? LoopCollecttionsCell else {
                fatalError("Cannot create new cell")
            }
            cell.cellLabel.text = item.description
            cell.backgroundColor = .black
            cell.layer.cornerRadius = CornerRadiusModifiers.small.size
            cell.layer.borderWidth = BorderSize.small.size
            cell.layer.borderColor = UIColor(named: "New Blue")?.cgColor
            cell.likeButton.setImage(UIImage(named: "heart"), for: .normal)
            
            cell.delegate = self
            return cell
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! LoopCollectionViewSectionHeader
            
            header.label.text = String(self.headerSetA[indexPath.section])
            //header.label.font = UIFont(name: "Chalkduster", size: 18)
            header.label.textColor = UIColor.white
            
            return header
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<String, String>()//SOURCE3
        
        for section in headerSetA {
            initialSnapshot.appendSections([section])
            initialSnapshot.appendItems(itemsBySectionAndName[section]!)
        }
       print(itemsBySectionAndName)
        
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        print(item)
        
        performSegue(withIdentifier: SegueID.gotoRecord.rawValue, sender: self)
    }
}

extension LoopCollectionsViewController: LoopCellDelegate {
    func didLikeItem(_ item: String) {
        cellStringReceived = item
      
        for (key, var value) in itemsBySectionAndName {
            if let index = value.firstIndex(of: item) {
                // Remove the item if it exists in the value array
                value.remove(at: index)
                itemsBySectionAndName[key] = value
                print("Removed '\(item)' from value for key '\(key)'")
            }
        }
        
        itemsBySectionAndName["Likes"]?.append(item)
        self.dataSource.apply(self.filteredItemsSnapshot)
        
        print(itemsBySectionAndName)
    }
}

//category type
//name
//origin - so unlikes go back to category
//array with be category objects instead of stings.







//print(cellStringReceived)
//        if let key = itemsBySectionAndName.first(where: { $0.value.contains(cellStringReceived) })?.key {
//        }
