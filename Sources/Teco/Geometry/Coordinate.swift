//
//  Coordinate.swift
//  Part of the Teco project.
//
//  Created by Sherman Barros <skippyr.developer@icloud.com>
//  Visit my website: https://dragonscave.xyz.
//  Follow me on GitHub: https://github.com/skippyr.
//
//  Refer to the LICENSE file that comes in its source code for more details.
//  If not available, all rights are reserved to the author.
//

/// Represents a coordinate within the terminal screen cell-grid.
///
/// The origin point, where column and row are both zero, is at the top left corner of the screen. From there, those components increase going right and down, respectively.
struct Coordinate {
    /// The column component of the coordinate.
    public var column: CellUnit
    /// The row component of the coordinate.
    public var row: CellUnit

    /// Creates a new coordinate from its components.
    ///
    /// - Parameter column: the column component of the coordinate.
    /// - Parameter row: the row component of the coordinate.
    public init(column: CellUnit, row: CellUnit) {
        self.column = column
        self.row = row
    }
}
