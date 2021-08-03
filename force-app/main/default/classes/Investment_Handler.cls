public with sharing class Investment_Handler {
    public static Investment__c[] getActiveInvestments(Date queryDate) {
        return [SELECT Id, 
                    CurrentValue__c,
                    PurchaseDate__c,
                    SoldDate__c,
                    CurrentValueRefreshDate__c,
                    (SELECT Value__c FROM History__r WHERE FromDate__c <= :queryDate AND ToDate__c >: queryDate ORDER BY ToDate__c DESC LIMIT 1)
                FROM Investment__c  
                WHERE PurchaseDate__c <= :queryDate
                AND (SoldDate__c >= :queryDate OR SoldDate__c = NULL) WITH SECURITY_ENFORCED];
    }
}
