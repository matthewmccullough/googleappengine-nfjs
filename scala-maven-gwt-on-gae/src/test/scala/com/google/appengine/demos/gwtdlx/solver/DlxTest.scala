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

import com.google.appengine.demos.gwtdlx.solver._

import org.scalatest.junit.JUnit3Suite

class DlxTest extends JUnit3Suite {

  val rows1 = List(List(0, 0, 1, 0, 1, 1, 0),
                   List(1, 0, 0, 1, 0, 0, 1),
                   List(0, 1, 1, 0, 0, 1, 0),
                   List(1, 0, 0, 1, 0, 0, 0),
                   List(0, 1, 0, 0, 0, 0, 1),
                   List(0, 0, 0, 1, 1, 0, 1))

  // Only columns 3 and 5 have 1s. This is an unsolvable cover problem.
  val rows2 = List (List(0, 0, 0, 0, 0, 1, 0),
                    List(0, 0, 0, 1, 0, 0, 0),
                    List(0, 0, 0, 0, 0, 1, 0),
                    List(0, 0, 0, 1, 0, 0, 0),
                    List(0, 0, 0, 0, 0, 0, 0),
                    List(0, 0, 0, 1, 0, 0, 0))

  val rows3 = List(List(1, 0),
                   List(0, 1))

  val rows4 = List(List(1, 0, 0, 0),
                   List(0, 1, 0, 0),
                   List(0, 0, 1, 0),
                   List(0, 0, 0, 1))

  def testOccupiedColIndices() {
    val matrix2 = new SparseMatrix(rows2)
    val occupiedcols2 = matrix2.occupied_colindices()
    val shouldBeOccupied2 = List(3,5)
    assert(occupiedcols2.equals(shouldBeOccupied2))

    val matrix3 = new SparseMatrix(rows3)
    val occupiedcols3 = matrix3.occupied_colindices()
    val shouldBeOccupied3 = List(0,1)
    assert(occupiedcols3.equals(shouldBeOccupied3))
  }

  def testOccupiedRowIndices() {
    val matrix2 = new SparseMatrix(rows2)
    val occupiedcols2 = matrix2.occupied_rowindices()
    val shouldBeOccupied2 = List(0,1,2,3,5)
    assert(occupiedcols2.equals(shouldBeOccupied2))

    val matrix3 = new SparseMatrix(rows3)
    val occupiedcols3 = matrix3.occupied_rowindices()
    val shouldBeOccupied3 = List(0,1)
    assert(occupiedcols3.equals(shouldBeOccupied3))
  }

  def testChooseColumn() {
    val matrix = new SparseMatrix(rows1)
    val dlx = new DLX(matrix)
    val coltable = matrix.column_table

    val column = dlx.choose_column()

    assert(coltable(0) == column)

    matrix.cover(column) 

    // See Figure 3; column D now only has one node in it.
    val aftercover = dlx.choose_column()

    assert (coltable(3) == aftercover)
  }

  def testSearch() {
    val matrix = new SparseMatrix(rows1)
    val dlx = new DLX(matrix)
    val result = dlx.search(0)
    assert(result != null)

    val mat2 = new SparseMatrix(rows2)
    val dlx2 = new DLX(mat2)
    val result2 = dlx2.search(0)
    assert(result2 == null)

    val mat3 = new SparseMatrix(rows3)
    val dlx3 = new DLX(mat3)
    val res3 = dlx3.search(0)
    assert(res3 != null)

    for (node <- res3) { println(node) }

    val mat4 = new SparseMatrix(rows4)
    val dlx4 = new DLX(mat4)
    val res4 = dlx4.search(0)
    assert(res4 != null)

    for (node <- res4) { println(node) }
  }
}
