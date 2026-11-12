# Builds Odoo from the app repository on top of wodby/odoo, which has Odoo Community Edition and Wodby's setup: the
# repository's modules are copied to the application root, where Odoo finds them, and the Python packages in its
# requirements.txt are installed.
ARG WODBY_BASE_IMAGE
FROM ${WODBY_BASE_IMAGE}

ARG COPY_FROM

COPY --chown=wodby:wodby ${COPY_FROM}/ ${APP_ROOT}/

RUN set -e; \
    cd "${APP_ROOT}"; \
    if [ -f requirements.txt ]; then \
        pip install -r requirements.txt; \
    fi; \
    # A module named like one of Odoo's own would be ignored: Odoo loads its own first.
    core="$(python3 -c 'import odoo.addons; print(" ".join(odoo.addons.__path__))')"; \
    paths="$(odoo-addons-path "${APP_ROOT}")"; \
    modules=""; \
    for path in $(echo "${paths}" | tr ',' ' '); do \
        for manifest in "${path}"/*/__manifest__.py; do \
            [ -f "${manifest}" ] || continue; \
            dir="$(dirname "${manifest}")"; \
            name="$(basename "${dir}")"; \
            for core_path in ${core}; do \
                if [ -d "${core_path}/${name}" ]; then \
                    echo "${dir#${APP_ROOT}/} has the name of one of Odoo's own modules, so Odoo would ignore it; rename it" >&2; \
                    exit 1; \
                fi; \
            done; \
            case " ${modules} " in \
                *" ${name} "*) echo "Module ${name} is in more than one directory; Odoo uses the first: ${dir#${APP_ROOT}/} is ignored" >&2 ;; \
                *) modules="${modules} ${name}" ;; \
            esac; \
        done; \
    done; \
    echo "Addons path: ${paths:-none}"; \
    echo "Modules:${modules:- none}"
