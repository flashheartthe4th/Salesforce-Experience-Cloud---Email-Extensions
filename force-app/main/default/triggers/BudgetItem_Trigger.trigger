trigger BudgetItem_Trigger on BudgetItem__c (before insert, before update) {

    if(Trigger.isBefore) {
        BudgetItem_Handler.setDefaults(Trigger.New);
    } else if(Trigger.isAfter) {
        //after
    } else {
        //deleting
    }

}