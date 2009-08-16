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

class MatrixTests extends JUnit3Suite {
  
  var rows1 : List[List[Int]] = 
    List(List(0, 0, 1, 0, 1, 1, 0),
         List(1, 0, 0, 1, 0, 0, 1),
         List(0, 1, 1, 0, 0, 1, 0),
         List(1, 0, 0, 1, 0, 0, 0),
         List(0, 1, 0, 0, 0, 0, 1),
         List(0, 0, 0, 1, 1, 0, 1))

  var rows2 : List[List[Int]] = 
    List(List(0, 0, 0, 0, 0, 1, 0),
         List(0, 0, 0, 1, 0, 0, 0),
         List(0, 0, 0, 0, 0, 1, 0),
         List(0, 0, 0, 1, 0, 0, 0),
         List(0, 0, 0, 0, 0, 0, 0),
         List(0, 0, 0, 1, 0, 0, 0))

  var matrix = new SparseMatrix(rows1)
  var sparser = new SparseMatrix(rows2)

  def testInitMatrix() {
     // every column has a 1 in it, and there's a special column header.
     assert(matrix.columns.length == 8)
     assert(matrix.node_table.size == 16)
 
     // not every column has a 1, but there's always a column there.
     assert(sparser.columns.size == 8)
     assert(sparser.node_table.size == 5)    
  }  

 
  def testColIndecesFor() {
    assert(matrix.colindices_for(0).equals( List(2, 4, 5)) )
    assert(matrix.colindices_for(5).equals( List(3, 4, 6)) )
  }
  
  def testRowIndecesFor() {
    assert(matrix.rowindices_for(0).equals( List(1,3)) )
    assert(matrix.rowindices_for(5).equals( List(0,2)) )
  }
  

  def testLinkNodesInRows() {
    val table = matrix.node_table

    // leftmost wraps around to rightmost
    assert(table(0,2).left == table(0,5))

    // leftmost has a right
    assert(table(0,2).right == table(0,4))
    
    // rightmost wraps around to left
    assert(table(0,5).right == table(0,2))
 
    // left of my right is me!
    assert(table(0,5).right.left == table(0,5))
   } 
 
  def testLinkNodesInColumns() {
    val table = matrix.node_table
    val coltable = matrix.column_table
 
    assert(table(0,2).up == coltable(2))
    assert(coltable(2).down == table(0,2))
 
    assert(table(2,1).down == table(4,1))
    assert(table(4,1).up == table(2,1))
    assert(table(4,1).down == coltable(1))
  }
  
  def testLinkColumns() {
    val coltable = matrix.column_table
    val col_header = matrix.header

    assert(coltable(0).left == col_header)
    assert(col_header.right == coltable(0))
    assert(coltable(1).right == coltable(2))
  } 
  
  def testColumnSizes() {
    val coltable = matrix.column_table
    assert(coltable(1).size == 2)
    assert(coltable(6).size == 3)
  }

  def testCover() {
    """See figure 3 in the Knuth paper."""
    
    // mat is a copy of matrix, and we're about to mutate it.
    val mat = new SparseMatrix(rows1)
    val coltable = mat.column_table
    val table = mat.node_table
    val col_header = mat.header

    mat.cover(coltable(0))
 
    assert(col_header.right == coltable(1))
    assert(coltable(1).left == col_header)
 
    assert(coltable(3).down == table(5,3))
    assert(table(5,3).up == coltable(3))
    assert(coltable(6).down == table(4,6))    
  }
  
  def testUncover() {
     """See figure 3 in the Knuth paper."""
     val mat = new SparseMatrix(rows1)
 
     val coltable = mat.column_table
     val table = mat.node_table
     val col_header = mat.header

     mat.cover(coltable(0))
     assert(col_header.right == coltable(1))
 
     mat.uncover(coltable(0))
     assert(coltable(1).left == coltable(0))
     assert(col_header.right == coltable(0))
 
     assert(coltable(3).down == table(1,3))
     assert(table(5,3).up == table(3,3))
     assert(coltable(6).down == table(1,6))    
  }
}
