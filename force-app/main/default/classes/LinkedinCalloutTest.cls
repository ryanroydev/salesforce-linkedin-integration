@isTest
public class LinkedinCalloutTest {
    
  public static final string TESTIMAGE_URN = 'urn:li:image:D5622AQGghxUNH_OvBA';
    
  @isTest static void testGetOrgPostsRecord(){
        StaticResourceCalloutMock mock =  new StaticResourceCalloutMock();
        mock.setStaticResource('GetOrgPostsResourse');
        mock.setHeader('Content-Type','application/json');
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response =  LinkedinCallout.getOrgPosts();
        
        Assert.areEqual(200,response.getStatusCode());
        Assert.areEqual('application/json', response.getHeader('Content-Type'));
        Assert.areNotEqual(null, response);
      
		Map<String, Object> resultBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
        List<Object> elementsBody = (List<Object>)resultBody.get('elements');
        Assert.areNotEqual(0, elementsBody.size());
        Map<String, Object> testPost = (Map<String, Object>)elementsBody[0];
        String commentary = (String)testPost.get('commentary');
        Assert.areEqual('Sample Post', commentary);
        //System.debug('Post : ' + commentary);
        
    }
    
    @isTest static void testGetOrgDetail(){
        StaticResourceCalloutMock mock =  new StaticResourceCalloutMock();
        mock.setStaticResource('GetOrgDetailResource');
        mock.setHeader('Content-Type','application/json');
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response =  LinkedinCallout.getOrgDetail();
        
        Assert.areEqual(200,response.getStatusCode());
        Assert.areEqual('application/json', response.getHeader('Content-Type'));
        Assert.areNotEqual(null, response);
      
		Map<String, Object> resultBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
       
        Assert.areEqual('Ryan Useless Company', resultBody.get('localizedName'));
        Assert.areEqual('NON_PROFIT', resultBody.get('organizationType'));
        Assert.areEqual('https://web.postman.co/', resultBody.get('localizedWebsite'));
     
     
    }
    
     @isTest static void testGetImageUrl(){
        StaticResourceCalloutMock mock =  new StaticResourceCalloutMock();
        mock.setStaticResource('GetImageUrlResource');
        mock.setHeader('Content-Type','application/json');
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response =  LinkedinCallout.getImageUrl(TESTIMAGE_URN);
        
        Assert.areEqual(200,response.getStatusCode());
        Assert.areEqual('application/json', response.getHeader('Content-Type'));
        Assert.areNotEqual(null, response);
      
		Map<String, Object> resultBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
       
        Assert.areEqual('https://media.licdn.com/dms/image/v2/D5622AQGghxUNH_OvBA/feedshare-shrink_2048_1536/B56ZVotmrnGoAs-/0/1741218541145?e=1744243200&v=beta&t=3bjLfr3h6TYnfwybgdivOdygIzamVLKDdMtmkB4TV78', resultBody.get('downloadUrl'));
        Assert.areEqual('urn:li:image:D5622AQGghxUNH_OvBA', resultBody.get('id'));

     
     
    }
    
    
     @isTest static void testGetOrgAdmin(){
        StaticResourceCalloutMock mock =  new StaticResourceCalloutMock();
        mock.setStaticResource('GetOrgAdminResource');
        mock.setHeader('Content-Type','application/json');
        mock.setStatusCode(200);
        
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response =  LinkedinCallout.getOrgAdmin();
        
        Assert.areEqual(200,response.getStatusCode());
        Assert.areEqual('application/json', response.getHeader('Content-Type'));
        Assert.areNotEqual(null, response);
      
		Map<String, Object> resultBody = (Map<String, Object>)JSON.deserializeUntyped(response.getBody());
       
        Assert.areEqual('https://media.licdn.com/dms/image/v2/C5103AQHXbiw7LqNhoQ/profile-displayphoto-shrink_100_100/profile-displayphoto-shrink_100_100/0/1548408091128?e=1746662400&v=beta&t=Gh5IqJ_g44IVhBfKQ6DzJSDzg6Q38L6xcgsR7iqyk5I', resultBody.get('picture'));
        Assert.areEqual('admin sample', resultBody.get('name'));
        Assert.areEqual('adminsample@test.com', resultBody.get('email'));

     
     
    }
    
    @isTest static void testCreatePost(){
        StaticResourceCalloutMock mock =  new StaticResourceCalloutMock();
        mock.setStaticResource('GetOrgPostsResourse');
        mock.setHeader('Content-Type','application/json');
        mock.setStatusCode(201);
        
        Test.setMock(HttpCalloutMock.class, mock);
        HttpResponse response =  LinkedinCallout.createPost('Test Sample Post', LinkedinHelper.getStaticResourceBody('PostImageResource'));
        
        Assert.areEqual(201,response.getStatusCode());
        Assert.areEqual('application/json', response.getHeader('Content-Type'));
        Assert.areNotEqual(null, response);
      
    }
    
    
}