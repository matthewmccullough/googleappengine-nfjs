package com.ambientideas.appengine

import javax.persistence.*;
// import com.google.appengine.api.datastore.Key;

@Entity
class Venue implements Serializable {

    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Long id

    static constraints = {
    	id visible:false
	}
	
	String venueName
	int seatingCapacity
}
