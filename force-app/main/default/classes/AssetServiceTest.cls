@isTest
private class AssetServiceTest {
    
    @testSetup
    static void setupData() {
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact', AccountId = acc.Id);
        insert con;
    }

    @isTest
    static void testAssetNotFound() {
        Test.startTest();
        String response = AssetService.reportLostDevice('INVALID_ID');
        Test.stopTest();
        System.assertEquals('No device found.', response);
    }
    
    @isTest
    static void testNoCoverage() {
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        Asset testAsset = new Asset(Name = 'Drone X', AccountId = con.AccountId, ContactId = con.Id, Asset_Identifier__c = 'AST-001', Status = 'Available');
        insert testAsset;
        
        Test.startTest();
        String response = AssetService.reportLostDevice('AST-001');
        Test.stopTest();
        
        System.assertEquals('No coverage. Asset status adjusted to Lost.', response);
    }
    
    @isTest
    static void testClaimAlreadyFiled() {
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        Asset testAsset = new Asset(Name = 'Drone Y', AccountId = con.AccountId, ContactId = con.Id, Asset_Identifier__c = 'AST-002', Status = 'Available');
        insert testAsset;
        
        Insurance__c insurance = new Insurance__c(Asset__c = testAsset.Id, Coverage__c = 'Comprehensive', Active__c = true);
        insert insurance;
        
        Claim__c claim = new Claim__c(Insurance__c = insurance.Id, Type__c = 'Loss', Contact__c = con.Id);
        insert claim;
        
        Claim__c insertedClaim = [SELECT Name FROM Claim__c WHERE Id = :claim.Id LIMIT 1];
        
        Test.startTest();
        String response = AssetService.reportLostDevice('AST-002');
        Test.stopTest();
        
        System.assertEquals(insertedClaim.Name + ' already filed.', response);
    }
    
    @isTest
    static void testNewClaimCreated() {
        Contact con = [SELECT Id, AccountId FROM Contact LIMIT 1];
        Asset testAsset = new Asset(Name = 'Drone Z', AccountId = con.AccountId, ContactId = con.Id, Asset_Identifier__c = 'AST-003', Status = 'Available');
        insert testAsset;
        
        Insurance__c insurance = new Insurance__c(Asset__c = testAsset.Id, Coverage__c = 'Comprehensive', Active__c = true);
        insert insurance;
        
        Test.startTest();
        String response = AssetService.reportLostDevice('AST-003');
        Test.stopTest();
        
        // Validamos que la respuesta no sea un mensaje de error, indicando que retornó un código de Claim válido
        System.assertNotEquals('No device found.', response);
        System.assertNotEquals('No coverage. Asset status adjusted to Lost.', response);
    }
}