global class CredentialVerificationService {
    
    webservice static String verifyCredential(String lastName, String certificationName) {
        String response = 'No record found';
        
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName = :lastName LIMIT 1];
        
        if (!contacts.isEmpty()) {
            Contact contact = contacts[0];
            
            List<Contact_Certification__c> certifications = [
                SELECT Id, isActive__c 
                FROM Contact_Certification__c 
                WHERE Name = :certificationName AND Contact__c = :contact.Id 
                LIMIT 1
            ];
            
            if (!certifications.isEmpty()) {
                response = certifications[0].isActive__c ? 'Valid' : 'Needs Renewal';
            }
        }
        
        return response;
    }
}