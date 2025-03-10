public with sharing class LinkedinDataService {
    
	@AuraEnabled(cacheable=true)
    public static String getPosts(){
        
        HttpResponse res = LinkedinCallout.getOrgPosts();
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
            return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
    
	@AuraEnabled(cacheable=true)
    public static String getImageUrl(String urnimage){
        HttpResponse res = LinkedinCallout.getImageUrl(urnimage);
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
             return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String getOrgDetail(){
        
        HttpResponse res = LinkedinCallout.getOrgDetail();
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
             return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String getOrgAdmin(){
        
        HttpResponse res = LinkedinCallout.getOrgAdmin();
        if (res.getStatusCode() == 200) {
            return res.getBody();
        } else {
             return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String createPost(String postMessage, string postImage){
        
        HttpResponse res = LinkedinCallout.createPost(postMessage,postImage);
        if (res.getStatusCode() == 201) {
            return res.getBody();
        } else {
            return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String deletePost(String postUrn){
        
        HttpResponse res = LinkedinCallout.deletePost(postUrn);
        if (res.getStatusCode() == 204) {
            return res.getBody();
        } else {
            return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static String insertPostDataToCustomObject(){
        
        HttpResponse res = LinkedinCallout.getOrgPosts();
        if (res.getStatusCode() == 200) {
            
            try{
           
                List<Linkedin_Post__c> postList = new List<Linkedin_Post__c>();
                
                Map<String, Object> responseBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
                List<Object> elementPosts = (List<Object>)responseBody.get('elements');
                
                for(Object post : elementPosts){
                    
                    String imageUrl = null;
                    Map<String, Object> postMap = (Map<String, Object>)post;
                    
                    Long timestampInSeconds = (long)postMap.get('createdAt');
                    DateTime createdAt = DateTime.newInstance(timestampInSeconds);
                    
                    if(postMap.get('content') != null){
                        Map<String, Object> content = (Map<String, Object>)postMap.get('content');
                        Map<String, Object> media = (Map<String, Object>)content.get('media');
                    	
                        
                        HttpResponse getImageResponse = LinkedinCallout.getImageUrl(media.get('id').toSTring());
                        if (getImageResponse.getStatusCode() == 200) {

                            Map<String, Object> imageBody = (Map<String, Object>) JSON.deserializeUntyped(getImageResponse.getBody());
                            imageUrl = imageBody.get('downloadUrl').toString();
                               
                        } 
                    }
                    
                    
                    
                    postList.add(new Linkedin_Post__c(
                        					Post_Message__c = (String)postMap.get('commentary'),
                                            Linkedin_Post_Id__c  = (String)postMap.get('id'),
                        					Created_At__c  = createdAt,
                        					Image_Url__c = imageUrl
                    			));
                    
                }
                
                if(postList.size() > 0){
                    
                    insert postList;
                }
                      
            } catch (DmlException e) {
                System.debug('DML Error: ' + e.getMessage());
            } catch (Exception e) {
                System.debug('General Error: ' + e.getMessage());
            }
            
            return res.getBody();
        } else {
            return 'Error: ' + res.getStatusCode() + ' ' + res.getStatus();
        }
    }
}