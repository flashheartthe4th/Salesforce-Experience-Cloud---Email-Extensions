import { LightningElement, track, wire, api } from 'lwc';
import AllBudgetItems from '@salesforce/apex/BudgetItem_Handler.getAllBudgetItems';


export default class DataTable extends LightningElement {
    @track columns = JSON.parse('[{"label":"Name","fieldName":"name","type":"text"},{"label":"Jan-21","fieldName":"2021-01-31T23:59:59.999Z","type":"currency"},{"label":"Feb-21","fieldName":"2021-02-28T23:59:59.999Z"},{"label":"Mar-21","fieldName":"2021-03-31T23:59:59.999Z"},{"label":"Apr-21","fieldName":"2021-04-30T23:59:59.999Z"},{"label":"May-21","fieldName":"2021-05-31T23:59:59.999Z"},{"label":"Jun-21","fieldName":"2021-06-30T23:59:59.999Z"},{"label":"Jul-21","fieldName":"2021-07-31T23:59:59.999Z"},{"label":"Aug-21","fieldName":"2021-08-31T23:59:59.999Z"},{"label":"Sep-21","fieldName":"2021-09-30T23:59:59.999Z"},{"label":"Oct-21","fieldName":"2021-10-31T23:59:59.999Z"},{"label":"Nov-21","fieldName":"2021-11-30T23:59:59.999Z"},{"label":"Dec-21","fieldName":"2021-12-31T23:59:59.999Z"}]');
    
    /*[
        { label: 'Name', fieldName: 'name' },
        { label: 'Period End Date', fieldName: 'periodEndDate' },
        { label: 'Monthly', fieldName: 'monthly' }
    ];*/

    wireBudgetItemsResult;
    @track error;
    //@track budgetItems;

    connectedCallback() {
        
    }

    renderedCallback() {
        
    }

    budgetItems = JSON.parse('{"budgetStartDate":"2021-01-01T00:00:00.000Z","budgetItems":[{"name":"RTYC","amount":212,"frequencylabel":"Quarterly","frequency":3,"startDate":"2019-04-01T00:00:00Z","endDate":"2022-01-31T00:00:00Z","relativeStartMonth":-21,"relativeEndMonth":12,"periodEndDate":"2021-12-31T23:59:59.999Z","periodOffset":11,"monthly":0,"2021-01-31T23:59:59.999Z":212,"2021-02-28T23:59:59.999Z":212,"2021-03-31T23:59:59.999Z":212,"2021-04-30T23:59:59.999Z":212,"2021-05-31T23:59:59.999Z":212,"2021-06-30T23:59:59.999Z":212,"2021-07-31T23:59:59.999Z":212,"2021-08-31T23:59:59.999Z":212,"2021-09-30T23:59:59.999Z":212,"2021-10-31T23:59:59.999Z":212,"2021-11-30T23:59:59.999Z":212,"2021-12-31T23:59:59.999Z":212},{"name":"Nursery","amount":650,"frequencylabel":"Monthly","frequency":1,"startDate":"2020-08-01T00:00:00Z","endDate":"2028-01-31T00:00:00Z","relativeStartMonth":-5,"relativeEndMonth":84,"periodEndDate":"2021-12-31T23:59:59.999Z","periodOffset":11,"monthly":650,"2021-01-31T23:59:59.999Z":650,"2021-02-28T23:59:59.999Z":650,"2021-03-31T23:59:59.999Z":650,"2021-04-30T23:59:59.999Z":650,"2021-05-31T23:59:59.999Z":650,"2021-06-30T23:59:59.999Z":650,"2021-07-31T23:59:59.999Z":650,"2021-08-31T23:59:59.999Z":650,"2021-09-30T23:59:59.999Z":650,"2021-10-31T23:59:59.999Z":650,"2021-11-30T23:59:59.999Z":650,"2021-12-31T23:59:59.999Z":650}],"items":[{"name":"RTYC","amount":212,"frequencylabel":"Quarterly","frequency":3,"startDate":"2019-04-01T00:00:00Z","endDate":"2022-01-31T00:00:00Z","relativeStartMonth":-21,"relativeEndMonth":12},{"name":"Nursery","amount":650,"frequencylabel":"Monthly","frequency":1,"startDate":"2020-08-01T00:00:00Z","endDate":"2028-01-31T00:00:00Z","relativeStartMonth":-5,"relativeEndMonth":84}],"budgetPeriods":["2021-01-31T23:59:59.999Z","2021-02-28T23:59:59.999Z","2021-03-31T22:59:59.999Z","2021-04-30T22:59:59.999Z","2021-05-31T22:59:59.999Z","2021-06-30T22:59:59.999Z","2021-07-31T22:59:59.999Z","2021-08-31T22:59:59.999Z","2021-09-30T22:59:59.999Z","2021-10-31T23:59:59.999Z","2021-11-30T23:59:59.999Z","2021-12-31T23:59:59.999Z"],"columns":[{"label":"Jan-21","fieldName":"2021-01-31T23:59:59.999Z"},{"label":"Feb-21","fieldName":"2021-02-28T23:59:59.999Z"},{"label":"Mar-21","fieldName":"2021-03-31T23:59:59.999Z"},{"label":"Apr-21","fieldName":"2021-04-30T23:59:59.999Z"},{"label":"May-21","fieldName":"2021-05-31T23:59:59.999Z"},{"label":"Jun-21","fieldName":"2021-06-30T23:59:59.999Z"},{"label":"Jul-21","fieldName":"2021-07-31T23:59:59.999Z"},{"label":"Aug-21","fieldName":"2021-08-31T23:59:59.999Z"},{"label":"Sep-21","fieldName":"2021-09-30T23:59:59.999Z"},{"label":"Oct-21","fieldName":"2021-10-31T23:59:59.999Z"},{"label":"Nov-21","fieldName":"2021-11-30T23:59:59.999Z"},{"label":"Dec-21","fieldName":"2021-12-31T23:59:59.999Z"}]}').budgetItems;
/*
    @wire(AllBudgetItems)
    wiredBudgetItems(result) {
        this.wireBudgetItemsResult = result;
        if (result.data) {
            this.budgetItems = result.data;
        } else if (result.error) {
            this.error = result.error;
        }
    }
*/
    rowSelected(event) {
    }
}