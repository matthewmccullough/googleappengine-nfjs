package com.ambientideas;

import java.io.IOException;
import java.util.Random;

import javax.servlet.http.*;
import com.google.appengine.api.datastore.*;

public class HelloAppEngineServlet extends HttpServlet {
	private static final long serialVersionUID = -8654772299999064278L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello world from Ambient Ideas and Maven");

		// Get a handle on the datastore itself
		DatastoreService datastore = DatastoreServiceFactory
				.getDatastoreService();

		savePerson(resp, datastore);
		saveRandomPersons(resp, datastore);
		getPerson(resp, datastore);
		queryPersons(resp, datastore);
	}

	private void queryPersons(HttpServletResponse resp,
			DatastoreService datastore) throws IOException {
		// Perform a query of all persons added earlier than NOW
		resp.getWriter().println("** BigTable data query RUNNING");
		Query query = new Query("Person");
		query.addFilter("ssn", Query.FilterOperator.LESS_THAN,
				Integer.MAX_VALUE);
		query.addSort("ssn", Query.SortDirection.ASCENDING);
		query.addSort("name", Query.SortDirection.ASCENDING);
		for (Entity personQueryEntity : datastore.prepare(query).asIterable()) {
			resp.getWriter().println("** BigTable data query success");
			resp.getWriter().println(
					"" + personQueryEntity.getProperty("saveDate") + ", "
							+ personQueryEntity.getProperty("name") + ", "
							+ personQueryEntity.getProperty("ssn"));
		}
	}

	private void getPerson(HttpServletResponse resp, DatastoreService datastore)
			throws IOException {
		// Lookup data by a known key name
		resp.getWriter().println("** BigTable data attempting getting one Person");
		
		Entity personEntity = null;
		try {
			personEntity = datastore.get(KeyFactory.createKey("Person",
					"matthewm@ambientideas.com"));
			resp.getWriter().println("** BigTable data read one Person successfully");
			resp.getWriter().println("Person: " + personEntity);
		} catch (EntityNotFoundException e) {
			e.printStackTrace();
			resp.getWriter().println("** BigTable data reading EXCEPTION");
		}
	}

	private void savePerson(HttpServletResponse resp, DatastoreService datastore)
			throws IOException {
		// Save a known row
		resp.getWriter().println("** BigTable data attempting writing one Person");
		
		Entity personEntityNew = new Entity("Person",
				"matthewm@ambientideas.com");
		personEntityNew.setProperty("name", "Matthew McCullough");
		personEntityNew.setProperty("email", "matthewm@ambientideas.com");
		personEntityNew.setProperty("ssn", 444555777);
		personEntityNew.setProperty("saveDate", new java.util.Date());
		datastore.put(personEntityNew);
		
		resp.getWriter().println("** BigTable data wrote one Person successfully");
	}

	private void saveRandomPersons(HttpServletResponse resp, DatastoreService datastore)
			throws IOException {
		// Save 5 random rows
		resp.getWriter().println("** BigTable data random Persons attempting writing");
		
		for (int i = 0; i < 5; i++) {
			Entity personRandomEntityNew = new Entity("Person", "x"
					+ new Random().nextInt() + "random@ambientideas.com");
			personRandomEntityNew.setProperty("name", "Matthew McCullough");
			personRandomEntityNew.setProperty("email",
					"random@ambientideas.com");
			personRandomEntityNew.setProperty("ssn", Math.abs(new Random()
					.nextInt()));
			personRandomEntityNew.setProperty("saveDate", new java.util.Date());
			datastore.put(personRandomEntityNew);
		}
		resp.getWriter().println("** BigTable data random Persons written successfully");
	}
}