import { LightningElement,wire } from 'lwc';
import getOrgDetail from '@salesforce/apex/LinkedinDataService.getOrgDetail';
export default class CompanyDetails extends LightningElement {

    company;
    error;

    @wire(getOrgDetail) 
    wiredGetOrgDetail({error,data}){
        if(data){
            try {
                const parsedCompany = JSON.parse(data);
                this.company = parsedCompany;
                if (this.company && this.company.localizedName) {
                    console.log('Company Name:', this.company.localizedName);
                } else {
                    console.warn('Localized Name is not available in the company data');
                }
                this.error = undefined;
            } catch (e) {
                this.company = undefined;
                this.error = e.message;
                this.showToast('Error', 'An error occurred while fetching company details: ' + this.error.body.message, 'error');
            }
        }else if(error){
            this.error = error;
            this.showToast('Error', 'An error occurred while fetching company details: ' + this.error.body.message, 'error');
        }

        

    };

    showToast(title, message, variant) {
        const event = new ShowToastEvent({
            title: title,     
            message: message, 
            variant: variant  
        });
        this.dispatchEvent(event); 
    }
}