//
//  Note+Extensions.swift
//  Mooskine
//
//  Created by Vlastimir Radojevic on 8/21/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import Foundation
import CoreData

extension Note {
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}
