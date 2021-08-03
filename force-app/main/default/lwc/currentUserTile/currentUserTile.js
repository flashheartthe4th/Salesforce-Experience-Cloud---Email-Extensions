import { LightningElement, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';

import USER_ID from '@salesforce/user/Id';
import NAME_FIELD from '@salesforce/schema/User.Name';
import PHONE_FIELD from '@salesforce/schema/User.Phone';
import EMAIL_FIELD from '@salesforce/schema/User.Email';
import SMALLPHOTO_FIELD from '@salesforce/schema/User.SmallPhotoUrl';


export default class CompositionParent extends LightningElement {

    @track contact;

    @wire(getRecord, {
        recordId: USER_ID,
        fields: [NAME_FIELD, EMAIL_FIELD, PHONE_FIELD,SMALLPHOTO_FIELD]
    }) wireuser({
        error,
        data
    }) {
        if (error) {
           this.error = error ; 
        } else if (data) {

            this.name = data.fields.Name.value;
            this.email = data.fields.Email.value;

            this.contact = {
                Name: data.fields.Name.value,
                Email: data.fields.Email.value,
                Phone: data.fields.Phone.value,
                Picture__c: data.fields.SmallPhotoUrl.value
            };
        }
    }
}