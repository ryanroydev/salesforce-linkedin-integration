@isTest
public class LinkedinDataServiceTest {

	 public static final string TESTIMAGE_URN = 'urn:li:image:D5622AQGghxUNH_OvBA';
    public static final string TESTPOST_URN = 'urn:li:share:7303630489729347584';

    @isTest
    static void testGetPosts() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());

        String response = LinkedinDataService.getPosts();

        Assert.areNotEqual(null, response);
        Assert.isTrue(response.contains('elements'));
    }

    @isTest
    static void testGetImageUrl() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());

        String response = LinkedinDataService.getImageUrl(TESTIMAGE_URN);

        Assert.areNotEqual(null, response);
        Assert.isTrue(response.contains('downloadUrl'));
    }

    @isTest
    static void testGetOrgDetail() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());
        
        String response = LinkedinDataService.getOrgDetail();
        
        Assert.areNotEqual(null, response);
        Assert.isTrue(response.contains('localizedName'));
    }


    @isTest
    static void testGetOrgAdmin() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());

        String response = LinkedinDataService.getOrgAdmin();

        Assert.areNotEqual(null, response);
        Assert.isTrue(response.contains('Ryan Roy Santos'));
    }

    @isTest
    static void testCreatePost() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());
        
        String response = LinkedinDataService.createPost('Test post message', LinkedinHelper.getStaticResourceBody('PostImageResource'));

        Assert.areNotEqual(null, response);
      
    }
    @isTest
    static void testDeletePost() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());
        
        String response = LinkedinDataService.deletePost(TESTPOST_URN);

        Assert.areNotEqual(null, response);
      
    }
    @isTest
    static void testInvalidGetPosts() {
        
       Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceErrorMock());

        String response = LinkedinDataService.getPosts();
        
        Assert.isTrue(response.contains('Error:'));
    }
    
	@isTest
    static void testInvalidGetImageUrl() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceErrorMock());

        String response = LinkedinDataService.getImageUrl(TESTIMAGE_URN);

        Assert.isTrue(response.contains('Error:'));
    }

    @isTest
    static void testInvalidGetOrgDetail() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceErrorMock());
        
        String response = LinkedinDataService.getOrgDetail();
        
        Assert.isTrue(response.contains('Error:'));
    }


    @isTest
    static void testInvalidGetOrgAdmin() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceErrorMock());

        String response = LinkedinDataService.getOrgAdmin();

        Assert.isTrue(response.contains('Error:'));
    }

    @isTest
    static void testInvalidCreatePost() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceErrorMock());
        
        String response = LinkedinDataService.createPost('Test post message', LinkedinHelper.getStaticResourceBody('PostImageResource'));

        Assert.isTrue(response.contains('Error:'));
      
    }
    
    
     @isTest
    static void testInsertPostDataToCustomObject() {
        
        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceMock());

        Test.startTest();
        String result = LinkedinDataService.insertPostDataToCustomObject();
        Test.stopTest();

        Assert.isTrue(result.contains('elements')); // Checking if the post ID is in the response
        

        List<Linkedin_Post__c> posts = [SELECT Id, Post_Message__c, Linkedin_Post_Id__c, Created_At__c, Image_Url__c FROM Linkedin_Post__c];
        
        Assert.areEqual(posts.size() , 1, 'One record should be inserted');
        Assert.areEqual('Sample Post', posts[0].Post_Message__c, 'Post message should match');
        Assert.areEqual('urn:li:share:7303199893400035328', posts[0].Linkedin_Post_Id__c, 'Post ID should match');
    }
    
    @isTest
    static void testInvalidInsertPostDataToCustomObject() {

        Test.setMock(HttpCalloutMock.class, new LinkedinDataServiceErrorMock());

        String response = LinkedinDataService.insertPostDataToCustomObject();

        Assert.isTrue(response.contains('Error:'));
    }

}