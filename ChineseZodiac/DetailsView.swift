//
//  DetailsView.swift
//  ChineseZodiac
//
//  Created by Kevin Peng on 2020-02-21.
//  Copyright © 2020 Monorail Apps. All rights reserved.
//

import UIKit

class DetailsView: UIView {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var zodiacImg: UIImageView!
  fileprivate var dataSource = DetailsVCTableViewDataSource()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    tableView.showsVerticalScrollIndicator = false
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func updateInformation(forPerson person: Person) {
    let zodiacSign = person.birthdate.getZodiac()
    
    updateZodiacImage(zodiacSign.name)
    dataSource.person = person
    tableView.dataSource = dataSource
  }
  
  fileprivate func updateZodiacImage(_ zodiacSign: String) {
    if let image = UIImage(named: zodiacSign) {
      let tintableImage = image.withRenderingMode(.alwaysTemplate)
      zodiacImg.image = tintableImage
    }
  }
}
