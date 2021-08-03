import { LightningElement, api, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/BudgetItem__c.Name';
import PAYMENT_FREQUENCY_FIELD from '@salesforce/schema/BudgetItem__c.PaymentFrequency__c';
import AMOUNT_FIELD from '@salesforce/schema/BudgetItem__c.Amount__c';
import START_DATE_FIELD from '@salesforce/schema/BudgetItem__c.StartDate__c';
import END_DATE_FIELD from '@salesforce/schema/BudgetItem__c.EndDate__c';
import TYPE_FIELD from '@salesforce/schema/BudgetItem__c.Type__c';
import budgetItemSelected from '@salesforce/messageChannel/budgetItemSelected__c';
import refreshAllDataTables from '@salesforce/messageChannel/refreshAllDataTables__c';
import { publish, subscribe, MessageContext } from 'lightning/messageService';

export default class RecordFormExample extends LightningElement {
    // Expose a field to make it available in the template
    fields = [NAME_FIELD,PAYMENT_FREQUENCY_FIELD,AMOUNT_FIELD,START_DATE_FIELD,END_DATE_FIELD,TYPE_FIELD];

    @wire(MessageContext)
    messageContext;

    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api objectApiName = 'BudgetItem__c';

    subscription = null;

    connectedCallback() {
        this.handleSubscribe();
    }

    handleSubscribe() {
        if (this.subscription) {
            return;
        }
        this.subscription = subscribe(this.messageContext, budgetItemSelected, (message) => {
            this.recordId = message.recordId;
        });
    }

    handleSuccess(event){
        var payload = {};
        publish(this.messageContext, refreshAllDataTables, payload);
     }

     handleError(event) {
        console.log("handleError event");
        console.log(JSON.stringify(event.detail));
    }
}