public with sharing class Networth_Handler {
    
    public static Double calculateInvestmentValue(date queryDate) {
        Double returnValue = 0;

        Investment__c[] investments = Investment_Handler.getActiveInvestments(queryDate);

        for(Investment__c investment:investments) {
            if(investment.History__r.size() == 1) {
                returnValue += investment.History__r[0].Value__c;
            } else {
                returnValue += investment.CurrentValue__c;
            }
        }

        return returnValue;
    }
}
