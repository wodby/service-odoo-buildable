# Buildable Odoo service for Kubernetes on Wodby

Run Odoo with your own modules on Kubernetes with Wodby.

This repository defines the Wodby service manifest for Odoo built from your Git
repository. Your repository holds your custom and community modules and their
Python packages; the build adds them to the prebuilt
[`wodby/odoo`](https://github.com/wodby/odoo) image.

- [Browse Wodby services](https://wodby.com/services)
- [Wodby service documentation](https://wodby.com/docs/2.0/services/)
- [Service manifest reference](https://wodby.com/docs/2.0/services/template/)

## Service overview

| Property | Manifest configuration |
| --- | --- |
| Service name | `odoo-buildable` |
| Based on | [`odoo`](https://github.com/wodby/service-odoo): versions, links, settings, volumes, actions and resources |
| Versions | Odoo `20`, `19`, `18` |
| Type | Application service |
| Image | Built from your repository on top of [`wodby/odoo`](https://github.com/wodby/odoo) |
| Application build | Your modules and `requirements.txt`; start from the [Odoo boilerplate](https://github.com/wodby/odoo-boilerplate) |
| Operations | Installs Odoo on the first deployment and updates the modules that changed on later ones |

Without your own modules, use the [Odoo service](https://github.com/wodby/service-odoo):
it needs no repository or build.

## Use this service

Reference `odoo-buildable` from a Wodby stack. A service is a reusable component
and does not deploy by itself. The stack defines its links, settings, versions,
resources, and relationship to the rest of the application.

## Maintain a custom version

1. Fork this repository.
2. Edit the service manifest and referenced files.
3. Import the repository as a [Git-backed service](https://wodby.com/docs/2.0/services/create/#create-a-git-backed-service).
4. Reference the service from a stack manifest.

Validate the manifest with:

```bash
wodby service validate-manifest service.yml --org <org-id>
```

See the [service manifest reference](https://wodby.com/docs/2.0/services/template/) and the [managed services index](https://github.com/wodby/services).
