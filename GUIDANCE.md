# Buildable Odoo on Wodby

This service is the [odoo](https://github.com/wodby/service-odoo) service built from the app's repository: its guidance
applies to settings, data, processes, installation and updates. This page covers what differs.

## Image

The image is built from the app's Git repository on top of the same [wodby/odoo](https://github.com/wodby/odoo) image
the odoo service runs, so the service's versions are Odoo versions (18, 19, 20). Start the repository from the
[Odoo boilerplate](https://github.com/wodby/odoo-boilerplate). The build copies the repository to `/usr/src/app` and:

- installs the Python packages listed in `requirements.txt`, when the repository has one, for the `wodby` user. Lines
  like `git+https://...` work: Git is in the image. There is no compiler, so packages need prebuilt wheels;
- finds the repository's modules: every directory up to three levels deep that holds modules (directories with a
  `__manifest__.py`) is added to Odoo's addons path. Modules can be at the root, in `addons/`, or in one directory per
  module collection copied from a community repository. The build log shows the addons path and the module list;
- fails when a module has the name of one of Odoo's own modules, because Odoo would ignore it. A module found in two
  directories is reported: Odoo uses the first.

Odoo's exact build comes from the wodby/odoo image revision the service uses, not from the repository: it moves
forward with service updates, and the app's next build uses it.

## Modules

- **First deployment:** installs `base` and the `init-modules` setting's apps, which can include the repository's own
  modules.
- **Later deployments:** the **Install or update Odoo** action updates installed modules whose files changed in the
  repository, or whose manifest `version` went up. New modules appear in the Apps menu but are not installed: install
  them there. A module removed from the repository while installed stops Odoo from loading it: uninstall it in Odoo
  first.

Odoo Enterprise modules go in the repository like any other module; they need an Odoo Enterprise subscription.
