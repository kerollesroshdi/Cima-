//
//  UITableViewNibExtension.swift
//  GAC Certificates
//
//  Created by Kerolles Roshdi on 4/16/20.
//  Copyright © 2020 ExpertApps. All rights reserved.
//

import UIKit

extension UITableView {
    
    func registerHeaderClass<Header: UITableViewHeaderFooterView>(headerClass: Header.Type) {
        let identifier = String(describing: Header.self)
        self.register(Header.self, forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerHeaderNib<Header: UITableViewHeaderFooterView>(headerClass: Header.Type) {
        let identifier = String(describing: Header.self)
//        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
        self.register(UINib(nibName: identifier, bundle: nil), forHeaderFooterViewReuseIdentifier: identifier)
    }
    
    func registerCellClass<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        self.register(Cell.self, forCellReuseIdentifier: identifier)
    }
    
    func registerCellNib<Cell: UITableViewCell>(cellClass: Cell.Type) {
        let identifier = String(describing: Cell.self)
        self.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
    }
    
    func dequeue<Cell: UITableViewCell>() -> Cell {
        let identifier = String(describing: Cell.self)
        guard let cell = self.dequeueReusableCell(withIdentifier: identifier) as? Cell else { fatalError("Error dequeuing cell with id: \(identifier)") }
        return cell
    }
    
    func dequeue<Header: UITableViewHeaderFooterView>() -> Header {
        let identifier = String(describing: Header.self)
        guard let header = self.dequeueReusableHeaderFooterView(withIdentifier: identifier) as? Header else { fatalError("Error dequeuing header") }
        return header
    }
    
}
