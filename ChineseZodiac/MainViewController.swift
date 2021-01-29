//
//  TableView.swift
//  ChineseZodiac
//
//  Created by Kevin on 2017-05-30.
//  Copyright © 2017 Monorail Apps. All rights reserved.
//

import UIKit


final class MainViewController: UIViewController {
  // MARK: Private Types
  // MARK: API Variables
  // MARK: Private Variables
  private lazy var delegate = ZodiacTableViewDelegate()
  private lazy var dataSource = ZodiacTableViewDataSource()
  private let DETAILS_SEGUE_IDENTIFIER = "showDetailsVC"
  
  private lazy var tableView: UITableView = {
    let tv = UITableView()
    tv.translatesAutoresizingMaskIntoConstraints = false
    let nib = UINib.init(nibName: "PersonCell", bundle: nil)
    tv.register(nib, forCellReuseIdentifier: "PersonCell")
    tv.delegate = delegate
    tv.dataSource = dataSource
    tv.rowHeight = 60
    return tv
  }()
  
  private lazy var segmentedControl: UISegmentedControl = {
    let sc = ZodiacSegmentedControl()
    sc.addTarget(self, action: #selector(segmentChange), for: .valueChanged)
    return sc
  }()
  
  // MARK: API Functions
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationBar()
    setupUI()
    setupTableView()
  }

  // MARK: Private Functions
  private func setupUI() {
    configureViewBackgroundColor()
    configureNavigationTitle()
    view.addSubview(segmentedControl)
    view.addSubview(tableView)
    let multiplier: CGFloat = 1
    if #available(iOS 11.0, *) {
      NSLayoutConstraint.activate(
        [
          segmentedControl.topAnchor.constraint(
            equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor,
            multiplier: multiplier
          ),
          segmentedControl.leadingAnchor.constraint(
            equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor,
            multiplier: multiplier
          ),
          view.trailingAnchor.constraint(
            equalToSystemSpacingAfter: segmentedControl.trailingAnchor,
            multiplier: multiplier
          ),
          tableView.topAnchor.constraint(
            equalToSystemSpacingBelow: segmentedControl.bottomAnchor,
            multiplier: multiplier
          ),
          tableView.leadingAnchor.constraint(
            equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor,
            multiplier: multiplier
          ),
          view.safeAreaLayoutGuide.trailingAnchor.constraint(
            equalToSystemSpacingAfter: tableView.trailingAnchor,
            multiplier: multiplier
          ),
          view.safeAreaLayoutGuide.bottomAnchor.constraint(
            equalToSystemSpacingBelow: tableView.bottomAnchor,
            multiplier: multiplier
          )
        ]
      )
    } else {
      NSLayoutConstraint.activate(
        [
          segmentedControl.topAnchor.constraint(
            equalTo: view.topAnchor,
            constant: 8 * multiplier
          ),
          segmentedControl.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 8 * multiplier
          ),
          segmentedControl.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -8 * multiplier
          ),
          tableView.topAnchor.constraint(
            equalTo: segmentedControl.bottomAnchor,
            constant: 8 * multiplier
          ),
          tableView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor,
            constant: 8 * multiplier
          ),
          tableView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor,
            constant: -8 * multiplier
          ),
          view.bottomAnchor.constraint(
            equalTo: tableView.bottomAnchor,
            constant: 8 * multiplier
          )
        ]
      )
    }
  }

  private func setupNavigationBar() {
    let addButton = UIBarButtonItem(
      barButtonSystemItem: .add,
      target: self,
      action: #selector(didTapAddPerson)
    )
    navigationItem.rightBarButtonItem = addButton
  }

  private func configureViewBackgroundColor() {
    if #available(iOS 13, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }
  }

  private func configureNavigationTitle() {
    navigationItem.title = "Chinese Zodiac"
    if #available(iOS 11, *) {
      navigationController?.navigationBar.prefersLargeTitles = true
    }
  }


  private func setupTableViewDelegate() {
    delegate.parentController = self
  }
  
  private func setupTableViewDataSource() {
    let dataManager = PersonDataManager.shared
    dataSource.dataManager = dataManager
    dataSource.parentController = self
  }
  
  private func setupTableView() {
    setupTableViewDelegate()
    setupTableViewDataSource()
  }
  
  @objc
  private func segmentChange(_ sender: Any) {
    let sortBy = PersonSort(rawValue: segmentedControl.selectedSegmentIndex)!
    dataSource.sort = sortBy
    tableView.reloadData()
  }

  @objc
  private func didTapAddPerson() {
    let destination = BirthdaySelectionViewController()
    navigationController?.pushViewController(destination, animated: true)
  }
  
  // MARK: Initializers
}

// MARK: Person Present
extension MainViewController: PersonPresenting {
  func didSelectPerson(at row: Int) {
    let person = dataSource.person(at: row)
    let destination = DetailsVC()
    destination.person = person
    navigationController?.pushViewController(destination, animated: true)
  }
}

// MARK: Person Delete
extension MainViewController: PersonDeleting {
  func deletePerson(at row: Int) {
    dataSource.deletePerson(at: row)
  }
}

extension MainViewController: PersonDataUpdating {
  func delete(at indexPath: IndexPath) {
    tableView.beginUpdates()
    tableView.deleteRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()
  }
  
  func insert(at indexPath: IndexPath) {
    tableView.beginUpdates()
    tableView.insertRows(at: [indexPath], with: .automatic)
    tableView.endUpdates()
  }
}
