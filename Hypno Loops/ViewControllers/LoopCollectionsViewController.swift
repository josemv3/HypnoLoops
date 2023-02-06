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

    var dataSource: UICollectionViewDiffableDataSource<Section, String>!//SOURCE1
    private var currentSet = setA
    
    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
            heightDimension: .fractionalWidth(0.3))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitem: item, count: grouItemCount)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK: - Data Source (Cell)
    
    func configureDataSource() {//SOURCE2
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: loopCollectionsCV) { (collectionView, indexPath, item) -> LoopCollecttionsCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoopCollecttionsCell.reuseidentifier, for: indexPath) as? LoopCollecttionsCell else {
                fatalError("Cannot create new cell")
            }
            cell.cellLabel.text = item.description
            cell.backgroundColor = .systemGray
            return cell
        }
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()//SOURCE3
        
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(currentSet)
        
        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        print(item)
        performSegue(withIdentifier: SegueID.gotoRecord.rawValue, sender: self)
    }

}
