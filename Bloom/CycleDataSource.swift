//
//  CycleDataSource.swift
//  Bloom
//
//  Created by Blake Robinson on 2/1/17.
//  Copyright © 2017 Blake Robinson. All rights reserved.
//

import UIKit

class CycleDataSource: NSObject, UITableViewDataSource {
    
    fileprivate let dateFormatter = DateFormatter()
    var dataSource: [Day]?
    
    var uuid: UUID? {
        return dataSource?.first?.uuid
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dayInCycle", for: indexPath) as! CycleTableViewCell
        if let day = dataSource?[indexPath.row] {
            cell.dayNumber.text = String(indexPath.row + 1)
            cell.date.text = dateText(day)
            cell.daySymbol.category = CycleController.category(for: day)
            cell.dayDescription.text = day.shortDescription ?? "--"
            cell.intercourseHeart.isHidden = !day.intercourse
        }
        
        
        return cell
    }
    
    private func dateText(_ day: Day) -> String {
        dateFormatter.dateFormat = "EEEE, MMM dd"
        return dateFormatter.string(from: day.date.subtractSecondsFromGMT())
    }
}
