package com.ambientideas.invoicetimetracking;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URL;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SendMailAlertServlet extends HttpServlet {

	private static final long serialVersionUID = 6904726972704540014L;

	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, UnsupportedEncodingException {
		Properties props = new Properties();
		Session session = Session.getDefaultInstance(props, null);

		//String msgBody = "A scheduled event on the Time Tracking App requested that we send you a mail....";
		
		URL url = new URL("http://www.ambientideas.com/index.html");
        BufferedReader reader = new BufferedReader(new InputStreamReader(url.openStream()));
        String pageContents = "...";
        String line;

        while ((line = reader.readLine()) != null) {
            pageContents = "" + pageContents + line;
        }
        reader.close();
        
        
        String msgBody = pageContents;

		Message msg = new MimeMessage(session);
		try {
			msg.setFrom(new InternetAddress("matthewm@ambientideas.com"));
			msg.addRecipient(Message.RecipientType.TO, new InternetAddress(
					"ambientideas@gmail.com", "Time Tracking User"));

			msg.setSubject("A scheduled event on the Time Tracking App");

			msg.setText(msgBody);
			Transport.send(msg);
		} catch (AddressException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
