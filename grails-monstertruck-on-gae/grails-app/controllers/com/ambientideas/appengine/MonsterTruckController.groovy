

package com.ambientideas.appengine

class MonsterTruckController {
    
    def index = { redirect(action:list,params:params) }

    // the delete, save and update actions only accept POST requests
    static allowedMethods = [delete:'POST', save:'POST', update:'POST']

    def list = {
        params.max = Math.min( params.max ? params.max.toInteger() : 10,  100)
        [ monsterTruckInstanceList: MonsterTruck.list( params ), monsterTruckInstanceTotal: MonsterTruck.count() ]
    }

    def show = {
        def monsterTruckInstance = MonsterTruck.get( params.id )

        if(!monsterTruckInstance) {
            flash.message = "MonsterTruck not found with id ${params.id}"
            redirect(action:list)
        }
        else { return [ monsterTruckInstance : monsterTruckInstance ] }
    }

    def delete = {
        def monsterTruckInstance = MonsterTruck.get( params.id )
        if(monsterTruckInstance) {
            try {
                monsterTruckInstance.delete(flush:true)
                flash.message = "MonsterTruck ${params.id} deleted"
                redirect(action:list)
            }
            catch(org.springframework.dao.DataIntegrityViolationException e) {
                flash.message = "MonsterTruck ${params.id} could not be deleted"
                redirect(action:show,id:params.id)
            }
        }
        else {
            flash.message = "MonsterTruck not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def edit = {
        def monsterTruckInstance = MonsterTruck.get( params.id )

        if(!monsterTruckInstance) {
            flash.message = "MonsterTruck not found with id ${params.id}"
            redirect(action:list)
        }
        else {
            return [ monsterTruckInstance : monsterTruckInstance ]
        }
    }

    def update = {
        def monsterTruckInstance = MonsterTruck.get( params.id )
        if(monsterTruckInstance) {
            if(params.version) {
                def version = params.version.toLong()
                if(monsterTruckInstance.version > version) {
                    
                    monsterTruckInstance.errors.rejectValue("version", "monsterTruck.optimistic.locking.failure", "Another user has updated this MonsterTruck while you were editing.")
                    render(view:'edit',model:[monsterTruckInstance:monsterTruckInstance])
                    return
                }
            }
            monsterTruckInstance.properties = params
            if(!monsterTruckInstance.hasErrors() && monsterTruckInstance.save(flush:true)) {
                flash.message = "MonsterTruck ${params.id} updated"
                redirect(action:show,id:monsterTruckInstance.id)
            }
            else {
                render(view:'edit',model:[monsterTruckInstance:monsterTruckInstance])
            }
        }
        else {
            flash.message = "MonsterTruck not found with id ${params.id}"
            redirect(action:list)
        }
    }

    def create = {
        def monsterTruckInstance = new MonsterTruck()
        monsterTruckInstance.properties = params
        return ['monsterTruckInstance':monsterTruckInstance]
    }

    def save = {
        def monsterTruckInstance = new MonsterTruck(params)
		MonsterTruck.withTransaction {
	        if(monsterTruckInstance.save(flush:true)) {
	            flash.message = "MonsterTruck ${monsterTruckInstance.id} created"
	            redirect(action:show,id:monsterTruckInstance.id)
	        }
	        else {
	            render(view:'create',model:[monsterTruckInstance:monsterTruckInstance])
	        }
		}
    }
}
