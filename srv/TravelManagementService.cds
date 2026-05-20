using {employee.db as db} from '../db/employeeSchema';


service TravelManagement{

@odata.draft.enabled


    entity  TravelRequest as projection on db.TravelRequest
    actions{
      
        action approve() returns TravelRequest;

        
        action reject(rejectionReason : String) returns TravelRequest;
    }
    
    entity  TravelDocuments as projection on db. TravelDocuments;

    entity  States{
        key name : String;
    }

}