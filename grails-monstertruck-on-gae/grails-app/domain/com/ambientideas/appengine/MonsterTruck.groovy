package com.ambientideas.appengine

import javax.persistence.*;
// import com.google.appengine.api.datastore.Key;

@Entity
class MonsterTruck implements Serializable {

    @Id
	@GeneratedValue(strategy = GenerationType.IDENTITY)
	Long id

    static constraints = {
    	id visible:false
	}
	
	String truckName
	String driverName
	int horsePower
}
