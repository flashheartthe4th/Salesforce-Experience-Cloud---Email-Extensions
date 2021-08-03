public with sharing class BudgetItem_Handler {
    
    @AuraEnabled(cacheable=true)
    public static BudgetItem__c[] getAllBudgetItems() {
        return [SELECT Id, Name, StartDate__c, EndDate__c, Amount__c, PaymentFrequency__c, PerMonth__c, Interval__c FROM BudgetItem__c];
    }

    @AuraEnabled(cacheable=true)
    public static BudgetItem__c[] getIncomeBudgetItems() {
        return [SELECT Id, Name, StartDate__c, EndDate__c, Amount__c, PaymentFrequency__c, PerMonth__c, Interval__c FROM BudgetItem__c WHERE Type__c = 'Income'];
    }

    @AuraEnabled(cacheable=true)
    public static BudgetItem__c[] getExpenditureBudgetItems() {
        return [SELECT Id, Name, StartDate__c, EndDate__c, Amount__c, PaymentFrequency__c, PerMonth__c, Interval__c FROM BudgetItem__c WHERE Type__c = 'Expenditure'];
    }

    public static void validate(BudgetItem__c[] budgetItems) {
        for(BudgetItem__c budgetItem:budgetItems){
            validate(budgetItem);
        }
    }

    public static void validate(BudgetItem__c budgetItem) {
        if(budgetItem.StartDate__c > budgetItem.EndDate__c && budgetItem.EndDate__c != null) {
            budgetItem.addError('The item\'s End Date must be after the item\'s Start Date.');
        }
    }

    public static void setDefaults(BudgetItem__c[] budgetItems) {
        for(BudgetItem__c budgetItem:budgetItems){
            setDefaults(budgetItem);
        }
    }

    public static void setDefaults(BudgetItem__c budgetItem) {
        setInterval(budgetItem);
    }

    public static void setInterval(BudgetItem__c budgetItem) {
        switch on budgetItem.PaymentFrequency__c {
            when  'One Off' {
                budgetItem.Interval__c = 1;
            }
            when  'Monthly' {
                budgetItem.Interval__c = 1;
            }
            when  'Quarterly' {
                budgetItem.Interval__c = 3;
            }
            when  'Half Yearly' {
                budgetItem.Interval__c = 6;
            }
            when  'Yearly' {
                budgetItem.Interval__c = 12;
            }
            when else {
                budgetItem.Interval__c = budgetItem.Interval__c;
            }
        }
    } 
}
