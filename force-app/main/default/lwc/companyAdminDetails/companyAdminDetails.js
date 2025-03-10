import { LightningElement,wire } from 'lwc';
import getOrgAdmin from '@salesforce/apex/LinkedinDataService.getOrgAdmin';

export default class CompanyAdminDetails extends LightningElement {
    admin;
    error;
    
    @wire(getOrgAdmin) 
    wiredGetOrgAdmin({error,data}){
        if(data){
            try {
                const parsedData = JSON.parse(data);
                this.admin = parsedData;
             
                this.error = undefined;
            } catch (e) {
                this.admin = undefined;
                this.error = e.message;
           }
        }else if(error){
            this.error = error;
        }
    
            
    
    };
   
}