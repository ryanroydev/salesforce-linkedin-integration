global class LinkedinDataServiceErrorMock implements HttpCalloutMock {
     global HttpResponse respond(HttpRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
     		res.setStatusCode(400);
            res.setBody('Error: ****');
           
            return res;
      
    }
   
}