@isTest
private class CredentialVerificationServiceTest {
    
    @testSetup
    static void setup() {
        Contact con = new Contact(LastName = 'Skywalker');
        insert con;
        
        Certification__c cert = new Certification__c(Name = 'Drone Pilot Pro');
        insert cert;
        
        Contact_Certification__c activeCert = new Contact_Certification__c(
            Contact__c = con.Id,
            Certification__c = cert.Id,
            isActive__c = true,
            Issue_Date__c = Date.today()
        );
        insert activeCert;
        
        Contact_Certification__c inactiveCert = new Contact_Certification__c(
            Contact__c = con.Id,
            Certification__c = cert.Id,
            isActive__c = false,
            Issue_Date__c = Date.today().addYears(-2)
        );
        insert inactiveCert;
    }
    
    @isTest
    static void testVerifyCredentialValid() {
        Contact con = [SELECT LastName FROM Contact WHERE LastName = 'Skywalker' LIMIT 1];
        Contact_Certification__c activeCert = [SELECT Name FROM Contact_Certification__c WHERE isActive__c = true LIMIT 1];
        
        Test.startTest();
        String result = CredentialVerificationService.verifyCredential(con.LastName, activeCert.Name);
        Test.stopTest();
        
        System.assertEquals('Valid', result, 'Debería devolver Valid');
    }
    
    @isTest
    static void testVerifyCredentialNeedsRenewal() {
        Contact con = [SELECT LastName FROM Contact WHERE LastName = 'Skywalker' LIMIT 1];
        Contact_Certification__c inactiveCert = [SELECT Name FROM Contact_Certification__c WHERE isActive__c = false LIMIT 1];
        
        Test.startTest();
        String result = CredentialVerificationService.verifyCredential(con.LastName, inactiveCert.Name);
        Test.stopTest();
        
        System.assertEquals('Needs Renewal', result, 'Debería devolver Needs Renewal');
    }
    
    @isTest
    static void testVerifyCredentialNoRecordFound() {
        Test.startTest();
        String result = CredentialVerificationService.verifyCredential('Vader', 'CC-9999');
        Test.stopTest();
        
        System.assertEquals('No record found', result, 'Debería devolver No record found');
    }
}