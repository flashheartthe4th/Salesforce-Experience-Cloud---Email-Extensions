# Community Email Extensions

This project fixes the issues where emails sent from the Case Feed in Service Cloud do not appear in the Case Feed for the end-user when viewing the Case in a Community.

This lack of visibility creates a disjointed user experience and results in the admin having to display related objects to provide the customer with total visibility.

The extension package looks at the Sender, the Recipient(s) and the CC list and if the Case Contact's email address is present, it marks the email as visible.

The package will not expose email messages where the email address of the Contact linked to the Case does not appear in the To, From or CC fields.