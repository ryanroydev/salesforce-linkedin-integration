public class LinkedinHelper {
    public static String getStaticResourceBody(String resourceName) {
        StaticResource sr = [SELECT Body FROM StaticResource WHERE Name = :resourceName LIMIT 1];
        String resourceBody = sr.Body.toString();
        return resourceBody;
    }
}