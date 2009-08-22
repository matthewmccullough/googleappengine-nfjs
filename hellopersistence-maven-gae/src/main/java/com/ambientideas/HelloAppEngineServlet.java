package com.ambientideas;

import java.io.IOException;
import javax.servlet.http.*;
import com.google.appengine.api.datastore.*;

public class HelloAppEngineServlet extends HttpServlet {
  public void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {
    resp.setContentType("text/plain");
    resp.getWriter().println("Hello world from Ambient Ideas and Maven");
    
    //Reading the most recent timestamp from BigTable
    
    ////////////////////////////////////////////////
    //Writing the current timestamp to BigTable
    ////////////////////////////////////////////////
    // Get a handle on the datastore itself
    DatastoreService datastore = DatastoreServiceFactory.getDatastoreService();
    
    //Save a row
    Entity personEntityNew = new Entity("Person");
    personEntityNew.setProperty("name", "Matthew McCullough");
    personEntityNew.setProperty("email", "matthewm@ambientideas.com");
    personEntityNew.setProperty("ssn", 444555777);
    datastore.put(personEntityNew);
    resp.getWriter().println("Data written");

    // Lookup data by known key name
//    Entity personEntity = null;
//  
//    try {
//      personEntity = datastore.get(KeyFactory.createKey("Person", "matthewm@ambientideas.com"));
//    } catch (EntityNotFoundException e) {
//      e.printStackTrace();
//    }
//    
//    resp.getWriter().println("Person: " + personEntity);

//    // Or perform a query
//    Query query = new Query("Person", personEntity.getKey());
//    query.addFilter("dueDate", Query.FilterOperator.LESS_THAN, new java.util.Date());
//    for (Entity taskEntity : datastore.prepare(query).asIterable()) {
//      if ("done".equals(taskEntity.getProperty("status"))) {
//        datastore.delete(taskEntity.getKey());
//      } else {
//        taskEntity.setProperty("status", "overdue");
//        datastore.put(taskEntity);
//      }
//    }
  }
}