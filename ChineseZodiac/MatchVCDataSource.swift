//
//  MatchVCDataSource.swift
//  ChineseZodiac
//
//  Created by Kevin Peng on 2020-02-22.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class MatchVCDataSource: NSObject, UICollectionViewDataSource {

  private let CELL_IDENTIFIER = "PersonColCell"
  private var persons = [Person]()
  private var selectedPersons: Set<Person> = []
  
  var numberOfItems: Int {
    return persons.count
  }
  
  func person(at item: Int) -> Person {
    return persons[item]
  }
  
  func tapPerson(at item: Int) {
    let tappedPerson = person(at: item)
    if selectedPersons.contains(tappedPerson) {
      selectedPersons.remove(tappedPerson)
    } else {
      selectedPersons.insert(tappedPerson)      
    }
  }
  
  func isPersonSelected(at item: Int) -> Bool {
    let personToQuery = person(at: item)
    return selectedPersons.contains(personToQuery)
  }
  
  func fetchData() {
    if let persons = PersonDataManager.shared.retrieveData(sortBy: .name) {
      self.persons = persons
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return persons.count
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
      receiver.receive(persons: self.persons)
    } else {
      let personArray = Array(selectedPersons)
      receiver.receive(persons: personArray)
    }
  }
}
