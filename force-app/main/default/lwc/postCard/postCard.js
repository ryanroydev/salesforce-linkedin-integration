import { LightningElement ,api, track} from 'lwc';
import getImageUrl from '@salesforce/apex/LinkedinDataService.getImageUrl';
import deletePost from '@salesforce/apex/LinkedinDataService.deletePost';
const LINKEDIN_URL = "https://www.linkedin.com/feed/update/";
export default class PostCard extends LightningElement {
    isModalOpen = false;
    post;
    @track imageUrl;

    @api
    set postdata(post){
       this.post = post;
       this.fetchImageUrl();
    }
    get postdata(){
        return post;
    }

    get getPostUrl(){
        return LINKEDIN_URL + this.post.id;
    }
    get formattedCommentary() {
        // Replace new lines with <br /> tags for proper rendering
        return this.post.commentary.replace(/(?:\r\n|\r|\n)/g, '<br />');
    }
    get getPublishedAt(){
        const options = {
            year: 'numeric',
            month: 'short',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit',
            hour12: false
        };
        return new Date(this.post.publishedAt).toLocaleString('en-US', options);
    }



    get urnImageIdFromPost() {

        return this.post && this.post.content && this.post.content.media ? this.post.content.media.id : null;
    }

    fetchImageUrl() {
        const urnImageId = this.urnImageIdFromPost;

        if (urnImageId) {

            getImageUrl({ urnimage: urnImageId })
                .then((result) => {
                    const parsedData = JSON.parse(result);
                    this.imageUrl = parsedData.downloadUrl; 
                })
                .catch((error) => {
                    console.error('Error fetching image URL:', error);
                    this.imageUrl = null;
                });
        } else {
            this.imageUrl = null;
        }
    }

    connectedCallback() {
        this.fetchImageUrl();
    }

    handleDelete(){
        this.isModalOpen = true;
    }
    closeModal(){
        this.isModalOpen = false;
    }

    deletePost(event){
        deletePost({postUrn : this.post.id})
        .then((data) => {
            this.isModalOpen = false;
            this.refreshPost();
        })
        .catch((error) => {

        });
    }

    refreshPost(){
        const event = new CustomEvent('refreshpost');
        this.dispatchEvent(event);
    }
    
}