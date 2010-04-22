package com.ambientideas.invoicetimetracking;

import java.util.Date;

import javax.jdo.annotations.IdGeneratorStrategy;
import javax.jdo.annotations.IdentityType;
import javax.jdo.annotations.PersistenceCapable;
import javax.jdo.annotations.Persistent;
import javax.jdo.annotations.PrimaryKey;

@PersistenceCapable(identityType = IdentityType.APPLICATION)
public class TimeTracked {
	@PrimaryKey
	@Persistent(valueStrategy = IdGeneratorStrategy.IDENTITY)
	private Long id;

	@Persistent
	private Float hoursWorked;

	@Persistent
	private String workComments;
	
    @Persistent
    private Date date;
    
    @Persistent
    private String employeeName;
	
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Float getHoursWorked() {
		return hoursWorked;
	}

	public void setHoursWorked(Float hoursWorked) {
		this.hoursWorked = hoursWorked;
	}

	public String getWorkComments() {
		return workComments;
	}

	public void setWorkComments(String workComments) {
		this.workComments = workComments;
	}

	public Date getDate() {
		return date;
	}

	public void setDate(Date date) {
		this.date = date;
	}

	public String getEmployeeName() {
		return employeeName;
	}

	public void setEmployeeName(String employeeName) {
		this.employeeName = employeeName;
	}
}
