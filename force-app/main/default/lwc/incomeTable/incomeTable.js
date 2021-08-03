import { LightningElement, track, wire, api } from 'lwc';
import budgetItemSelected from '@salesforce/messageChannel/budgetItemSelected__c';
import refreshAllDataTables from '@salesforce/messageChannel/refreshAllDataTables__c';
import { publish, subscribe, MessageContext } from 'lightning/messageService';
import { refreshApex } from '@salesforce/apex';
import IncomeBudgetItems from '@salesforce/apex/BudgetItem_Handler.getIncomeBudgetItems';


export default class DataTable extends LightningElement {
    @track columns = [
        { label: 'Name', fieldName: 'Name' },
        { label: 'Payment Frequency', fieldName: 'PaymentFrequency__c', type: 'string' },
        { label: 'Amount', fieldName: 'Amount__c', type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }}},
        { label: 'Per Month', fieldName: 'PerMonth__c', type: 'currency', typeAttributes: { currencyCode: { fieldName: 'CurrencyIsoCode' }} },
        { label: 'Start Date', fieldName: 'StartDate__c', type: 'date-local' },
        { label: 'End Date', fieldName: 'EndDate__c', type: 'date-local' }
    ];

    wireBudgetItemsResult;
    @track error;
    @track budgetItems;

    @wire(MessageContext)
    messageContext;

    subscription = null;

    connectedCallback() {
        this.subscribeToEvents();
    }

    @wire(IncomeBudgetItems)
    wiredBudgetItems(result) {
        this.wireBudgetItemsResult = result;
        if (result.data) {
            this.budgetItems = result.data;
        } else if (result.error) {
            this.error = result.error;
        }
    }

    rowSelected(event) {
        var selectedRow = event.detail.selectedRows[0];
        var payload = { recordId: selectedRow?.Id };
        publish(this.messageContext, budgetItemSelected, payload);
    }

    subscribeToEvents() {
        console.log('Refesh Received');
        subscribe(this.messageContext, refreshAllDataTables, (message) => {
            refreshApex(this.wireBudgetItemsResult);
            console.log('Refeshing');
        });
    }

}