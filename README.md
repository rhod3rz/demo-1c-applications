# Applications

## 1. Summary
---

This repository builds on the **Platform Landing Zone** and **Application Landing Zone**, which should be reviewed first to understand the foundation of this architecture:  
👉 https://github.com/rhod3rz/demo-1a-platform-landing-zone  
👉 https://github.com/rhod3rz/demo-1b-application-landing-zone

It provides sample code for a demo application called **Mango**, which includes two microservices, **cart** and **catalog**. It also configures cert-manager to issue **HTTPS** certificates for each micro service.

> **NOTE:** For the purposes of this demo, the solution is split across three repositories. In a real-world implementation, each demo repository would typically map to an Azure DevOps project, and each folder to an individual Azure DevOps repository.

The table below details what each folder covers.

| Folder              | Description                                                   |
|---------------------|---------------------------------------------------------------|
| `app-mango-cart`    | Code to build and deploy the **cart** microservice.           |
| `app-mango-catalog` | Code to build and deploy the **catalog** microservice.        |
| `core-cert-manager` | Deploys **cert-manager** and associated certificates configs. |
