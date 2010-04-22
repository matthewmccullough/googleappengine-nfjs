package com.ambientideas.invoicetimetracking;

import java.io.IOException;
import java.util.Date;
import java.util.logging.Logger;
import javax.jdo.PersistenceManager;
import javax.servlet.http.*;
import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;

public class AddTimeServlet extends HttpServlet {
	private static final long serialVersionUID = -547355420609921703L;
	private static final Logger log = Logger.getLogger(AddTimeServlet.class
			.getName());

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		UserService userService = UserServiceFactory.getUserService();
		User user = userService.getCurrentUser();

		String hoursWorked = req.getParameter("hoursWorked");
		log.warning("Hours Worked: " + hoursWorked);
		log.warning("Hours Worked as Float: " + new Float(hoursWorked));
		String workComments = req.getParameter("workComments");
		log.warning("Work Comments: " + workComments);
		
		Date date = new Date();
		log.warning("Date: " + date);
		
		String employeeName = "Anonymous";
		if (user != null && user.getEmail() != null) {
			employeeName = user.getEmail();
		}
		
		TimeTracked timetracked = new TimeTracked(new Float(hoursWorked),
				workComments, date, employeeName);
		
		log.info("Creating time for: " + timetracked);

		PersistenceManager pm = PMF.get().getPersistenceManager();
		try {
			pm.makePersistent(timetracked);
		} finally {
			pm.close();
		}

		resp.sendRedirect("/listtime.jsp");
	}
}
