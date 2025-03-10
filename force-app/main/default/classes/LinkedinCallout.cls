public class LinkedinCallout {
    
	public static final String LINKINAPI_NAME = 'Linkedin_API';
    
    public static Application_Credential__mdt getCredential(){
        Application_Credential__mdt credsMdt = [SELECT  Endpoint__c,Access_Token__c,Version__c,Organization__c
                                                FROM Application_Credential__mdt
                                                WHERE DeveloperName = :LINKINAPI_NAME
                                                LIMIT 1];
        
        return credsMdt;
    }
    
    public static HttpResponse getOrgPosts(){
        //AppCredential__c creds = AppCredential__c.getOrgDefaults();
        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(creds.Endpoint__c + '/rest/posts?author='+ EncodingUtil.urlEncode('urn:li:organization:' +creds.Organization__c, 'UTF-8')  +'&q=author&count=10');
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);
        request.setMethod('GET');
      
       
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            //System.Debug(response.getBody());
        }
        
        
        return response;
    }
     public static HttpResponse getOrgDetail(){
         
        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(creds.Endpoint__c + '/rest/organizations/' + creds.Organization__c);
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);
        request.setMethod('GET');
      
       
        HttpResponse response = http.send(request);
        
        if(response.getStatusCode() == 200){
            //System.Debug(response.getBody());
        }
        
        
        return response;
    }
    
     public static HttpResponse getImageUrl(String urnimage){

        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(creds.Endpoint__c + '/v2/images/' + urnimage);
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);
        request.setMethod('GET');
      
        HttpResponse response = http.send(request);
        
        return response;
    }
    
    public static HttpResponse getOrgAdmin(){
         
        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(creds.Endpoint__c + '/v2/userinfo');
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);
        request.setMethod('GET');
      
        HttpResponse response = http.send(request);
        
        return response;
    } 
    public static HttpResponse initializeUpload(){
         
        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(creds.Endpoint__c + '/rest/images?action=initializeUpload');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        
        Map<String, Object> requestBody = new Map<String, Object>();
        requestBody.put('initializeUploadRequest', 
                         new Map<String, Object> {'owner' => 'urn:li:organization:' + creds.Organization__c}
                        );
        
      	String jsonBody = JSON.serialize(requestBody);
        system.debug(jsonBody);
        request.setBody(jsonBody);
        HttpResponse response = http.send(request);
        
        return response;
    } 
    public static HttpResponse deletePost(String postUrn){
         
        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(creds.Endpoint__c + '/rest/posts/' + postUrn);
        request.setMethod('DELETE');
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);

        HttpResponse response = http.send(request);
        
        return response;
    } 
    public static HttpResponse uploadFile(String uploadUrl, Blob blobFile){
         
        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(uploadUrl);
        request.setMethod('PUT');
        request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
        request.setHeader('LinkedIn-Version',creds.Version__c);
        request.setHeader('Content-Type', 'application/octet-stream');
        
        System.Debug(blobFile);
		request.setBodyAsBlob(blobFile); 
    
        HttpResponse response = http.send(request);
        
        return response;
    } 
	public static HttpResponse createPost(String postMessage, string postImage){
        

        Application_Credential__mdt creds = getCredential(); //USE MDT because custom setting has limited in 255 chars
        
        String postImageUrl  = null;
        
        System.Debug(postImage);
         if(postImage != null){
             //Map<String, Object> postImageBody =  postImage;
             Map<String, Object> postImageBody = (Map<String, Object>) JSON.deserializeUntyped(postImage);
            
            String blobFileString = postImageBody.get('fileBody').toString();
            Blob blobFile = EncodingUtil.base64Decode(blobFileString);
             
             HttpResponse initUploadReponse = initializeUpload();

             if(initUploadReponse.getStatusCode() == 200){
			 	 Map<String, Object> initBody = (Map<String, Object>) JSON.deserializeUntyped(initUploadReponse.getBody());
                 Map<String, Object> initValue = (Map<String, Object>) initBody.get('value');
                 
                 String UploadUrl = initValue.get('uploadUrl').toString();
                 HttpResponse uploadResponse = uploadFile(UploadUrl, blobFile);
                 
                 
                 
                 if(uploadResponse.getStatusCode() == 201){
                     
                    postImageUrl = initValue.get('image').toString();
                 }
             }
             
         }
        
          System.debug('Upload STatus' + postImageUrl);
        
        
          Http http = new Http();
          HttpRequest request = new HttpRequest();
          request.setEndpoint(creds.Endpoint__c + '/rest/posts');
          request.setMethod('POST');
          request.setHeader('Authorization', 'Bearer ' + creds.Access_Token__c);
          request.setHeader('LinkedIn-Version',creds.Version__c);
          request.setHeader('Content-Type', 'application/json;charset=UTF-8');

          Map<String, Object> requestBody = new Map<String, Object>();
          requestBody.put('author', 'urn:li:organization:' + creds.Organization__c);
          requestBody.put('commentary', postMessage);
          requestBody.put('visibility', 'PUBLIC');
    
          Map<String, Object> distributionMap = new Map<String, Object>();
          distributionMap.put('feedDistribution', 'MAIN_FEED');
        
           if(postImageUrl != null){
              Map<String, Object> contentMap = new Map<String, Object>();
              
              contentMap.put('media', new Map<String, Object>{'id'=>postImageUrl});
              requestBody.put('content', contentMap);
            
           }

          List<Object> targetEntities = new List<Object>();
          List<Object> thirdPartyDistributionChannels = new List<Object>();
            
          distributionMap.put('targetEntities', targetEntities);
          distributionMap.put('thirdPartyDistributionChannels', thirdPartyDistributionChannels);
    
          requestBody.put('distribution', distributionMap);
          requestBody.put('lifecycleState', 'PUBLISHED');
        
          String jsonBody = JSON.serialize(requestBody);
          request.setBody(jsonBody);
        
          system.debug('body' + jsonBody);
        
          HttpResponse response = http.send(request);
         
          if(response.getStatusCode() == 201){
                 
              System.Debug(request.getBody());
          }
          
          return response;      
    }
}