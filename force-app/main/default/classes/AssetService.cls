@RestResource(urlMapping='/lost/*')
global with sharing class AssetService {

    @HttpPost
    global static String reportLostDevice(String assetIdentifier) {
        // Validar que el identificador no venga vacío
        if (String.isBlank(assetIdentifier)) {
            return 'No device found.';
        }
        
        // 1. Buscar el dispositivo por su identificador
        List<Asset> assets = [SELECT Id, Status, ContactId FROM Asset WHERE Asset_Identifier__c = :assetIdentifier LIMIT 1];
        
        if (assets.isEmpty()) {
            return 'No device found.';
        }
        
        // 2. Ajustar el estado a 'Lost' y actualizar
        assets[0].Status = 'Lost';
        update assets[0];
        
        // 3. Buscar si tiene un seguro comprensivo activo
        List<Insurance__c> insurances = [SELECT Id FROM Insurance__c WHERE Asset__c = :assets[0].Id AND Coverage__c = 'Comprehensive' AND Active__c = true LIMIT 1];
        
        if (insurances.isEmpty()) {
            return 'No coverage. Asset status adjusted to Lost.';
        }
        
        // 4. Buscar si ya existe un reclamo de tipo 'Loss'
        List<Claim__c> existingClaims = [SELECT Id, Name FROM Claim__c WHERE Insurance__c = :insurances[0].Id AND Type__c = 'Loss' LIMIT 1];
        
        if (!existingClaims.isEmpty()) {
            return existingClaims[0].Name + ' already filed.';
        }
        
        // 5. Crear el nuevo reclamo si todo está en orden
        Claim__c newClaim = new Claim__c();
        newClaim.Insurance__c = insurances[0].Id;
        newClaim.Type__c = 'Loss';
        newClaim.Asset__c = assets[0].Id; // <--- ESTA ES LA LÍNEA QUE AGREGAMOS AQUÍ
        
        if (assets[0].ContactId != null) {
            newClaim.Contact__c = assets[0].ContactId; 
        }
        insert newClaim;
        
        // Retornar el número de reclamo autogenerado
        Claim__c insertedClaim = [SELECT Name FROM Claim__c WHERE Id = :newClaim.Id LIMIT 1];
        return insertedClaim.Name;
    }
}