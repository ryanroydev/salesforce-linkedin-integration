import { LightningElement, wire } from 'lwc';
import { subscribe, MessageContext } from 'lightning/messageService';
import POSTMC from '@salesforce/messageChannel/PostMessageChannel__c';
import getPosts from '@salesforce/apex/LinkedinDataService.getPosts';
import { refreshApex } from '@salesforce/apex';
export default class PostContainer extends LightningElement {
    error;
    posts;

    @wire(getPosts)
    wiredGetPosts(result){
        this.wiredPostsResult = result; 
        const { error, data } = result;
        if(data){
            try {
                const parsedData = JSON.parse(data);
                this.posts = parsedData.elements;
                this.error = undefined;
            } catch (e) {
                this.posts = undefined;
                this.error = 'Error Encountered : ' + e.message;
            }

        } else if(error){
            this.posts = undefined;
            this.error = error;
        }
  
       
    }
    @wire(MessageContext)
    messageContext;

    connectedCallback(){
        this.subscription = subscribe(
            this.messageContext,
            POSTMC,
            (message) => this.handleMessage(message));
    };
    handleMessage(message) {
        if(message.refresh){
            refreshApex(this.wiredPostsResult); 
        }
    }
    handleRefreshPost(){
        refreshApex(this.wiredPostsResult); 
    }
    getPostUrl(postId) {
        return `https://www.linkedin.com/feed/update/${postId}`;
    }

}