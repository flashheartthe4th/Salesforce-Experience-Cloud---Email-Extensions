import { LightningElement, api, track } from 'lwc';

export default class CustomLookup extends LightningElement {
    @api fieldLabel = 'Search';
    @api disabled = false;
    @api label = '';
    @api value = '';
    @api required = false;

    initialResults = [{value:1,label:"Bob"}];

    @track results = [];
    @track showResults = false;

    handleChange(event) {
        // Creates the event
        console.log('handleChange');
        console.log(event.target.value);
        
        if(event.target.value.length===0) {
            this.showResults = false;
        } else {
            //live we'll us a mockbin for the moment
            /*
            fetch(`https://apidojo-yahoo-finance-v1.p.rapidapi.com/auto-complete?q=${event.target.value}&region=GB`, {
                "method": "GET",
                "headers": {
                    "x-rapidapi-key": "a0968e01e9msh58c32b084e5c11ep15f175jsn02e89ccd838c",
                    "x-rapidapi-host": "apidojo-yahoo-finance-v1.p.rapidapi.com"
                }
            */
            fetch('https://c51490bd-ba3c-45c6-b41d-00c4e9f0d8e8.mock.pstmn.io/auto-complete', {
                "method": "GET",
                "headers": {}
            }).then((response) => {
                // The response is a Response instance.
                // You parse the data into a useable format using `.json()`
                return response.json();
            }).then((data) => {
                // `data` is the parsed version of the JSON returned from the above endpoint.
                //console.log(data.quotes);  // { "uservalue": 1, "value": 1, "title": "...", "body": "..." }
                this.results = [...data.quotes];

                this.results.forEach(stock => {
                    stock.label = stock.shortname;
                    stock.value = stock.symbol;
                })

                if(this.results.length === 0){
                    this.results = [{value:"",label:"No results found"}];
                }

                this.showResults = this.results.length > 0;
            }).catch((err) => {
                console.error(err);
            });
        }
    }

    handleFocus(event) {
        this.showResults = this.results.length > 0;
    }

    handleSelect(event) {
        console.log('handleSelect');

        console.log(event.toElement.innerText);
        console.log(event.target.dataset.rowId);

        this.label = event.toElement.innerText;
        this.value = event.target.dataset.rowId;

        const stockselected = new CustomEvent('stockselected', {detail: { stockTicker: this.value, stockName: this.label }});
        this.dispatchEvent(stockselected);

        console.log(stockselected);
        
        this.showResults = false;
    }

    @api isValid() {
        if (this.required) {
            this.template.querySelector('lightning-input-field').reportValidity();
        }
    }
}