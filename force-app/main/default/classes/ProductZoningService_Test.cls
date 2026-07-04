@isTest
private class ProductZoningService_Test {

    @isTest
    static void testPermissibleFlyZone() {
        Product2 testProd = new Product2(Name = 'Drone Test', ProductCode = 'DRONE-123', Family = 'Drones', IsActive = true);
        insert testProd;
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/ProductZoning/';
        request.httpMethod = 'GET';
        request.addParameter('ProductCode', 'DRONE-123');
        request.addHeader('CountryCode', 'US');
        RestContext.request = request;
        
        Test.startTest();
        String response = ProductZoningService.getProductZoning();
        Test.stopTest();
        
        System.assertNotEquals(null, response);
    }
    
    @isTest
    static void testCheckWithLocalAuthorities() {
        Product2 testProd = new Product2(Name = 'Drone Unknown', ProductCode = 'DRONE-999', Family = 'UnknownFamily', IsActive = true);
        insert testProd;
        
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/ProductZoning/';
        request.httpMethod = 'GET';
        request.addParameter('ProductCode', 'DRONE-999');
        request.addHeader('CountryCode', 'FR');
        RestContext.request = request;
        
        Test.startTest();
        String response = ProductZoningService.getProductZoning();
        Test.stopTest();
        
        System.assertEquals('Confirm with the local authorities', response);
    }
    
    @isTest
    static void testMissingOrInvalidProductCode() {
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/ProductZoning/';
        request.httpMethod = 'GET';
        request.addParameter('ProductCode', 'INVALID-CODE');
        RestContext.request = request;
        
        Test.startTest();
        String response = ProductZoningService.getProductZoning();
        Test.stopTest();
        
        System.assertEquals('ProductCode is missing or doesn\'t exist', response);
    }
    
    // ¡ESTE ES EL MÉTODO NUEVO QUE NOS DA EL 100%!
    @isTest
    static void testMissingHeadersAndParams() {
        RestRequest request = new RestRequest();
        request.requestUri = '/services/apexrest/ProductZoning/';
        request.httpMethod = 'GET';
        // No agregamos ni CountryCode ni ProductCode a propósito
        RestContext.request = request;
        
        Test.startTest();
        String response = ProductZoningService.getProductZoning();
        Test.stopTest();
        
        System.assertEquals('ProductCode is missing or doesn\'t exist', response);
    }
}