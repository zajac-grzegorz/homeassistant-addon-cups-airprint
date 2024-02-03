# homeassistant addon cups airprint pdf
CUPS addon with working Avahi in reflector mode and PDF output mirrored to host.  Based on the work of zajac-grzegorz.

Tested with Home Assistant version **2023.9**

CUPS administrator login: **print**, password: **print** (can be changed in the Dockerfile)

Configuration data is stored in **/data/cups** folder

Any PDFs generated are returned to /share/cups-pdf folder on HA

Post-processing of PDFs within the container can be ac hieved via /config/cups-pdf/postprocess.sh on HA

[![Open your Home Assistant instance and show the add add-on repository dialog with a specific repository URL pre-filled.](https://my.home-assistant.io/badges/supervisor_add_addon_repository.svg)](https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fpetermce42%2Fhomeassistant-addon-cups-airprint%2Ftree%2Fwith-PDF-support)
