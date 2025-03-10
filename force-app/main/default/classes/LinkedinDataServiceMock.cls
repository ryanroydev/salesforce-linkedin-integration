global class LinkedinDataServiceMock implements HttpCalloutMock {
     global HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            
            if (req.getEndpoint().contains('/rest/posts?author=')) {
                res.setStatusCode(200);
                res.setBody(getStaticResourceBody('GetOrgPostsResourse'));
            } else if (req.getEndpoint().contains('/v2/images/')) {
                res.setStatusCode(200);
                res.setBody(getStaticResourceBody('GetImageUrlResource'));
            } else if (req.getEndpoint().contains('/rest/posts/urn:li:share:')) {
                res.setStatusCode(204);
                res.setBody('{}');
            } else if (req.getEndpoint().contains('/rest/images?action=initializeUpload')) {
                res.setStatusCode(200);
                res.setBody(getStaticResourceBody('InitializeUploadResource'));
            } else if (req.getEndpoint().contains('/rest/organizations/')) {
                res.setStatusCode(200);
                res.setBody(getStaticResourceBody('GetOrgDetailResource'));
            } else if (req.getEndpoint().contains('/v2/userinfo')) {
                res.setStatusCode(200);
                res.setBody(getStaticResourceBody('GetOrgAdminResource'));
            } else if (req.getEndpoint().contains('/rest/posts')) {
                res.setStatusCode(201);
                res.setBody('{"postId": "123", "status": "created"}');
             } else if (req.getEndpoint().contains('/dms-uploads/')) {
                res.setStatusCode(201);
                res.setBody('{}');
            } 
            return res;
      
    }
    
    private String getStaticResourceBody(String resourceName) {
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = :resourceName LIMIT 1];
        String resourceBody = sr.Body.toString();
        return resourceBody;
    }
}