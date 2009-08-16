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

package com.google.appengine.demos.gwtdlx.client;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;
import com.google.gwt.dom.client.Document;
import com.google.gwt.dom.client.InputElement;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.RootPanel;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
public class GwtDlx implements EntryPoint {
  private final Label ajax = new Label("ajax: the cloud is thinking.");
  private final SudokuApiAsync api = GWT.create(SudokuApi.class);
  private final HTML noSolution = new HTML("&empty;");

  public void onModuleLoad() {
    Button button = new Button("solve");
    Button clearButton = new Button("clear");

    button.addClickHandler(buildClickHandler());
    clearButton.addClickHandler(buildClearHandler());

    RootPanel.get("button").add(button);
    RootPanel.get("button").add(clearButton);

    noSolution.setVisible(false);
    noSolution.setStyleName("fail");

    RootPanel.get().add(noSolution);
    RootPanel.get().add(ajax);
    ajax.setStyleName("ajax");
    ajax.setVisible(false);
    ajax.setHorizontalAlignment(Label.ALIGN_CENTER);
    noSolution.setHorizontalAlignment(Label.ALIGN_CENTER);
  }

  private ClickHandler buildClearHandler() {
    ClickHandler out = new ClickHandler() {
      public void onClick(ClickEvent event) {
        noSolution.setVisible(false);
        for (int r = 0; r < 9; r++) {
          for (int c = 0; c < 9; c++) {
            InputElement elt = getBox(r, c);
            elt.setValue("");
          }
        }
      }
    };
    return out;
  }

  private ClickHandler buildClickHandler() {
    ClickHandler out = new ClickHandler() {
      public void onClick(ClickEvent event) {
        ajax.setVisible(true);
        int board[][] = new int[9][9];

        for (int r = 0; r < 9; r++) {
          for (int c = 0; c < 9; c++) {
            InputElement elt = getBox(r, c);

            int val = 0;
            String str = elt.getValue();
            if (str.length() == 1 && Character.isDigit(str.charAt(0))) {
              val = str.charAt(0) - '0';
            }

            board[r][c] = val;
          }
        }
        api.solveSudoku(board, buildCallback());
      }
    };
    return out;
  }

  private InputElement getBox(int r, int c) {
    String cellname = "cell" + r + "" + c;
    InputElement elt = (InputElement) Document.get().getElementById(cellname);

    return elt;
  }

  private AsyncCallback<int[][]> buildCallback() {
    AsyncCallback<int[][]> out = new AsyncCallback<int[][]>() {
      public void onFailure(Throwable caught) {
      }

      public void onSuccess(int[][] result) {
        ajax.setVisible(false);
        if (result == null) {
          noSolution.setVisible(true);
          return;
        }

        noSolution.setVisible(false);
        for (int r = 0; r < result.length; r++) {
          for (int c = 0; c < result[r].length; c++) {
            InputElement elt = getBox(r, c);
            elt.setValue(result[r][c] + "");
          }
        }
        ajax.setVisible(false);
      }
    };
    return out;
  }
}
