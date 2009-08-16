/*
 * Copyright 2009 Google Inc.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.google.appengine.demos.gwtdlx.solver

import org.scalatest.junit.JUnit3Suite
import com.google.appengine.demos.gwtdlx.solver._

class SudokuTest extends JUnit3Suite {

  def testRowColToBox() {
    var r = 0
    var c = 0

    var box = SudokuUtil.rowColToBox(r,c)
    assert(box == 0)

    r = 8
    c = 8
    box = SudokuUtil.rowColToBox(r,c)
    assert(box == 8)

    r = 4
    c = 4
    box = SudokuUtil.rowColToBox(r,c)
    assert(box == 4)
  }

  def testDlxRow() {
    val dlxrow = SudokuUtil.dlxRow(0,0,1)
    assert(dlxrow.length == 324)

    // left fold.
    assert( ((0 /: dlxrow) (_ + _ )) == 4 )

    assert(dlxrow(0) == 1)
    assert(dlxrow(1) == 0)
  }

  def testDlxRowsForSquare() {
    assert (SudokuUtil.dlxRowsForSquare(0,0,1).length == 1)
    assert (SudokuUtil.dlxRowsForSquare(0,0,0).length == 9)
  }

  def testEncode() {
    val r = 0
    val c = 0
    val encoded = SudokuUtil.encode(r,c)

    assert(encoded(0) == 1)
    assert(encoded(1) == 0)
  }

  def testDecode() {
    val encoded = SudokuUtil.encode(0,0)

    val tup = SudokuUtil.decode(encoded)

    assert(tup._1 == 0)
    assert(tup._2 == 0)
    assert(tup == (0,0))

    assert(SudokuUtil.decode(SudokuUtil.encode(5,5)) == (5,5))
  }

  def testDlxRowToRcv() {
    val dlxrow = SudokuUtil.dlxRow(0,0,1)
    val tup = SudokuUtil.dlxRowToRcv(dlxrow)

    assert(tup == (0,0,1))
  }

  def testSquaresToDlxRows() {
    val blank = SudokuUtil.buildBlankBoard()

    val blank_dlxrows = SudokuUtil.squaresToDlxRows(blank)
    assert(blank_dlxrows.length == 729)

    val filledsquares = Array(Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9),
                              Array(1,2,3,4,5,6,7,8,9))

    val filleddlxrows = SudokuUtil.squaresToDlxRows(filledsquares)
    assert(filleddlxrows.length == 81)
  }

  def testSudokuPuzzle() {
    val blank = SudokuUtil.buildBlankBoard()
    val blankPuzzle = new Sudoku(blank)

    val soln = blankPuzzle.solve()
    assert(soln != null)
    assert(soln.length == 9)
    assert(soln(0).length == 9)
  }

  /**
   * Should return null for an unsolvable board.
   */
  def testFailureForUnsolveable() {
    val failSquares = Array(Array(0,0,0,0,0,0,0,0,0),
                            Array(1,2,3,4,5,6,7,0,9),
                            Array(0,0,0,0,0,0,0,0,0),
                            Array(0,0,0,0,0,0,0,0,0),
                            Array(0,0,0,0,0,0,0,0,0),
                            Array(0,0,0,0,0,0,0,0,0),
                            Array(0,0,0,0,0,0,0,0,0),
                            Array(0,0,0,0,0,0,0,8,0),
                            Array(0,0,0,0,0,0,0,0,0))
    val failPuzzle = new Sudoku(failSquares)
    val soln = failPuzzle.solve()
    assert(soln == null)
  }
}
