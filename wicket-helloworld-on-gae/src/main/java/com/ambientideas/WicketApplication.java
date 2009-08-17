package com.ambientideas;

import org.apache.wicket.protocol.http.WebApplication;
import org.apache.wicket.protocol.http.HttpSessionStore;

/**
 * Application object for your web application. If you want to run this application without deploying, run the Start class.
 * 
 * @see wicket.myproject.Start#main(String[])
 */
public class WicketApplication extends WebApplication
{    
    /**
     * Constructor
     */
	public WicketApplication()
	{
	}
	
	/**
	 * @see wicket.Application#getHomePage()
	 */
	public Class getHomePage()
	{
		return HomePage.class;
	}
	
	// Necessary for Wicket on GAE to stop thread spawning and file writing to disk
	// Reference:
	// http://united-coders.com/nico-heid/running-a-java-wicket-application-in-the-google-app-engine
	@Override
  public HttpSessionStore newSessionStore(){
     return new HttpSessionStore(this);
  }

}
