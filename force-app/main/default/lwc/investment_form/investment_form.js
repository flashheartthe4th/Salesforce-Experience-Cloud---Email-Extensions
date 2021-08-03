import { LightningElement, api, wire } from 'lwc';
import NAME_FIELD from '@salesforce/schema/Investment__c.Name';
import TYPE_FIELD from '@salesforce/schema/Investment__c.Type__c';
import TICKERSYMBOL_FIELD from '@salesforce/schema/Investment__c.TickerSymbol__c';
import PURCHASEDATE_FIELD from '@salesforce/schema/Investment__c.PurchaseDate__c';
import UNITPURCHASEPRICE_FIELD from '@salesforce/schema/Investment__c.UnitPurchasePrice__c';
import QUANTITY_FIELD from '@salesforce/schema/Investment__c.Quantity__c';
import CURRENTVALUEUNIT_FIELD from '@salesforce/schema/Investment__c.CurrentValueUnit__c';
import CURRENTVALUEREFRESHDATE_FIELD from '@salesforce/schema/Investment__c.CurrentValueRefreshDate__c';

export default class investment_form extends LightningElement {
    
    nameField = NAME_FIELD;
    tickerSymbolField = TICKERSYMBOL_FIELD;
    typeField = TYPE_FIELD;
    purchaseDate = PURCHASEDATE_FIELD;
    unitPricePurchasePrice = UNITPURCHASEPRICE_FIELD;
    quantity = QUANTITY_FIELD;
    
    stockTicker = '';
    stockName = '';

    // Flexipage provides recordId and objectApiName
    @api recordId;
    @api objectApiName = 'Investment__c';

    showName = false;
    hideStockLookup = false;

    stockselected(event) {

        this.stockTicker = event.detail.stockTicker;
        this.stockName = event.detail.stockName;

        this.nameFieldVal = this.stockName;
    }

    handleSubmit(event){
        event.preventDefault();       // stop the form from submitting
        const fields = event.detail.fields;
        fields.TickerSymbol__c = this.stockTicker;
        fields.Name = this.stockName;
        this.template.querySelector('lightning-record-edit-form').submit(fields);
        console.log('submitted')
     }

     changedType(event){
        this.showName = event.target.value === 'Unlisted';
        this.hideStockLookup = this.showName;
     }

}