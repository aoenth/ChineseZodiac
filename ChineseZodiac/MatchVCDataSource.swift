//
//  MatchVCDataSource.swift
//  ChineseZodiac
//
//  Created by Kevin Peng on 2020-02-22.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit
import CoreData

class MatchVCDataSource: NSObject, UICollectionViewDataSource {

  let MAX_MATCHING_PEOPLE = 10
  private let CELL_IDENTIFIER = "PersonColCell"
  private var selectedPersons: Set<Person> = []
  
  var dataManager: PersonDataManaging!
  var sort: PersonSort = .name {
    didSet {
      dataManager.sort = sort
    }
  }
  
  var numberOfSelectedItems: Int {
    return selectedPersons.count
  }
  
  var numberOfItems: Int {
    dataManager.numberOfObjects
  }
  
  func person(at item: Int) -> Person {
    dataManager.fetch(at: IndexPath(item: item, section: 0))
  }
  
  func isSelectionLegal() -> Bool {
    return numberOfSelectedItems <= MAX_MATCHING_PEOPLE && numberOfSelectedItems > 1
  }
  
  func canMatchAll() -> Bool {
    return numberOfSelectedItems == 0 && numberOfItems <= MAX_MATCHING_PEOPLE && numberOfItems >= 2
  }
  
  func tapPerson(at item: Int) {
    let tappedPerson = person(at: item)
    if selectedPersons.contains(tappedPerson) {
      selectedPersons.remove(tappedPerson)
    } else {
      selectedPersons.insert(tappedPerson)
    }
  }
  
  func deselectAll() {
    selectedPersons.removeAll()
  }
  
  func isPersonSelected(at item: Int) -> Bool {
    let personToQuery = person(at: item)
    return selectedPersons.contains(personToQuery)
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return numberOfItems
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {    
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CELL_IDENTIFIER,
                                                        for: indexPath) as? PersonCollectionCell else {
      fatalError("Cannot dequeue or cast UITableView as \"PersonColCell\"")
    }
    let personAtIndexPath = person(at: indexPath.item)
    let isSelected = isPersonSelected(at: indexPath.item)
    cell.configureCell(person: personAtIndexPath, isSelected: isSelected)
    return cell
  }
}

extension MatchVCDataSource: PersonsSendable {
  func send(to receiver: PersonsReceivable) {
    if selectedPersons.isEmpty {
      receiver.receive(persons: dataManager.allPeople)
    } else {
      let personArray = Array(selectedPersons)
      receiver.receive(persons: personArray)
    }
  }
}

extension MatchVCDataSource: NSFetchedResultsControllerDelegate {
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .delete:
      if let person = anObject as? Person {
        selectedPersons.remove(person)
      }
    default:
      break
    }
  }
}
