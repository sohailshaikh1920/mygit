## Service Principals

An Azure Active Directory application is used for deployment of resources in the target Azure tenant.

The application is added as an app registration with the following configuration:

* **Name:** [customername]-innofactor-vdc-deploy-app
* **Roles:**
  * **Directory readers**: The app need to read existing groups and to read users and apps that will be assigned as members of groups or subscriptions.
  * **Groups administrator**: The app need this to create new groups for use with role-based access control.
* **Account type**: Accounts in any organizational directory (Any Azure AD directory - Multi-tenant). This allows the app, once granted access, to download a deployment container image.
* A secret must be created for use by the deployment.

To allow to create Management Groups and move subscriptions to a specified Management Group, the application should be *Owner* of the **Virtual Data Centreroot** Management Group. This will allow the application to perform tasks like:

* Create child Management Groups.
* Move subscriptions to any child Management Group.
* Deploy resources to the Management Group and any child Management Group or subscription.
* Configure subscriptions with tags, diagnostic settings and resource providers.

Multiple deployment accounts can be created, e.g. one for each workload, to limit the impact one account can have.
