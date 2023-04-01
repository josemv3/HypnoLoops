//
//  AffirmationsView.swift
//  Hypno Loops
//
//  Created by Joey Rubin on 2/25/23.
//

import UIKit

class AffirmationsView: UIViewController, UICollectionViewDelegate {
    @IBOutlet weak var affirmationCV: UICollectionView!
    
    var dataSource: UICollectionViewDiffableDataSource<Section, String>!//SOURCE1
    let affirmationsString = AffirmationStings()
    var categoryReceived = "" //receiving var fromm sections CV
    var showAffirmation: [String] = [] //categoryReceived is used to pull affirmation in dict
    var noAffirmation = "No affirmation selected..."

    enum Section {
        case main
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //2 sources of truth
        showAffirmation = affirmationsString.affirmations[categoryReceived] ?? ["Error"]
        affirmationCV.collectionViewLayout = configureLayout()
        configureDataSource()
    }
    
    //MARK: - Layout
    private func configureLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let groupItemCount = 1
        
        // Item definition
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 0)
        
        // Group definition
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.22)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: groupItemCount
        )
        group.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: 5,
            bottom: 5,
            trailing: 5
        )
        // Section and layout definition
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: spacing,
            leading: spacing,
            bottom: spacing,
            trailing: spacing
        )
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    //MARK: - DataSource
    private func configureDataSource() {
        ///CELL
        dataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: affirmationCV, cellProvider: { collectionView, indexPath, item in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AffirmationCell.reuseidentifier, for: indexPath) as! AffirmationCell
            cell.layer.cornerRadius = CornerRadiusModifiers.normal.size
            cell.layer.borderColor = UIColor(named: Color.hlBlue.rawValue)?.cgColor
            cell.layer.borderWidth = BorderSize.small.size
            cell.layer.backgroundColor = UIColor.black.cgColor
            cell.selectedButton.layer.cornerRadius = CornerRadiusModifiers.small.size
            cell.affirmationLabel.text = self.showAffirmation[indexPath.item] //showAfffirmation is an optional array built from affirmations Dict. Then Item bulds cells from string sentences.
            
            return cell
        })
        
        var initialSnapshot = NSDiffableDataSourceSnapshot<Section, String>()//SOURCE3
        
        initialSnapshot.appendSections([.main])
        initialSnapshot.appendItems(showAffirmation)

        dataSource.apply(initialSnapshot, animatingDifferences: false)
    }
    
    
}
