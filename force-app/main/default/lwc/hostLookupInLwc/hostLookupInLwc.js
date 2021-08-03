import { LightningElement } from 'lwc';

export default class HostLookupInLwc extends LightningElement {
    selectedRecordId; //store the record id of the selected 
    handleValueSelected(event) {
        this.selectedRecordId = event.detail;
    }

    validateLookupField() {
        this.template.querySelector('c-custom-lookup').isValid();
}
}