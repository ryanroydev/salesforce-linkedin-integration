import { LightningElement, wire } from 'lwc';
import { publish, MessageContext } from 'lightning/messageService';
import POSTMC from '@salesforce/messageChannel/PostMessageChannel__c';
import createPost from '@salesforce/apex/LinkedinDataService.createPost';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CreatePost extends LightningElement {
    acceptedFormats = ['.jpg','.png','.jpeg'];
    postText;
    postImage;
    postError;
    imagePreviewUrl
    imagePreviewName;
    showSpinner;


    @wire(MessageContext)
    messageContext;


    sendMessageRefreshPost(){
        const message = {
            refresh : true
        }
        publish(this.messageContext, POSTMC, message);
    }

    handleInputChange(event){
        this.postText = event.target.value;
    }

    handleUploadFile(event) {
      
        if (event.detail.files && event.detail.files.length) {
            const imageFile = event.detail.files[0];
   
            this.showSpinner = true;
            const fileReader = new FileReader();
            fileReader.onloadend = () => {
                const fileBody = fileReader.result;
                
                const base64FileBody = this.arrayBufferToBase64(fileBody);
                this.imagePreviewUrl = `data:${imageFile.type};base64,${base64FileBody}`;
                this.imagePreviewName = imageFile.name;
                const apexParams = {
                    fileName: imageFile.name,
                    fileBody : base64FileBody
                };

                this.postImage = JSON.stringify(apexParams);

                console.log(this.postImage)
                
                
                this.showSpinner = false; 
            };
            fileReader.readAsArrayBuffer(imageFile);
        }
    }

    arrayBufferToBase64(arrayBuffer) {
        const uint8Array = new Uint8Array(arrayBuffer);
        let binaryString = '';
        uint8Array.forEach(byte => {
            binaryString += String.fromCharCode(byte);
        });
        return window.btoa(binaryString);  
    }

    handlePostClick(event){
        this.showSpinner = true;
        if(this.postText){

            createPost({postMessage : this.postText, postImage : this.postImage})
            .then((data)=>{
                this.sendMessageRefreshPost();
                this.resetCreatePost();
                this.postError = undefined;
                this.showToast('Success','Your post was successful!','success');
                this.showSpinner = false;
                
            })
            .catch((error)=>{
                this.postError = error;
            });
            
        } else {
           
            this.showToast('Error','Please Enter Post Message','error');
            this.showSpinner = false;
        }
    }

    resetCreatePost(){
        this.imagePreviewUrl = null;
        this.imagePreviewName = null;
        this.postText = null;
    }

    showToast(title,message,variant){
        const myToast = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant, 
         }); 
        this.dispatchEvent(myToast);
    }


}