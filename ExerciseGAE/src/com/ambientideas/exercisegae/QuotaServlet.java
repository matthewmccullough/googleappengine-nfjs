package com.ambientideas.exercisegae;

import java.io.IOException;
import javax.servlet.http.*;

import com.google.appengine.api.quota.QuotaService;
import com.google.appengine.api.quota.QuotaServiceFactory;

@SuppressWarnings("serial")
public class QuotaServlet extends HttpServlet {
	public void doGet(HttpServletRequest req, HttpServletResponse resp)
			throws IOException {
		resp.setContentType("text/plain");
		resp.getWriter().println("Hello, world");
		
		QuotaService qs = QuotaServiceFactory.getQuotaService();
        long startCumulativeCPUCycles = qs.getCpuTimeInMegaCycles();
        
        //Something time-expensive
        
        
        //Capture end time
        long endCumulativeCPUCycles = qs.getCpuTimeInMegaCycles();

        //Calculate delta
        double cpuSeconds = qs.convertMegacyclesToCpuSeconds(endCumulativeCPUCycles - startCumulativeCPUCycles);
        resp.getWriter().println("CPU Seconds: " + cpuSeconds);
        
        //Output grand total
        resp.getWriter().println("CPU Seconds: " + qs.convertMegacyclesToCpuSeconds(endCumulativeCPUCycles));
	}
}
