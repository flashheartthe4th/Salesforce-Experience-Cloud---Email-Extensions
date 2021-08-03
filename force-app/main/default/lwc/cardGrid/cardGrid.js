import { LightningElement, track, wire, api } from 'lwc';
import AllBudgetItems from '@salesforce/apex/BudgetItem_Handler.getAllBudgetItems';

export default class CardGrid extends LightningElement {
    
    wireBudgetItemsResult;
    @track error;
    @track budgetItems;

    connectedCallback() {
        
    }

    renderedCallback() {
        
    }

    @wire(AllBudgetItems)
    wiredBudgetItems(result) {
        this.wireBudgetItemsResult = result;
        if (result.data) {
            this.budgetItems = result.data;
        } else if (result.error) {
            this.error = result.error;
        }
    }

    rowSelected(event) {
    }
}