#!/bin/sh

bash "${STEAMCMDDIR}/steamcmd.sh" \
	+force_install_dir ${STEAMAPPDIR} \
	+login ${STEAMLOGIN} \
	+app_license_request ${STEAMAPPID} \
	+app_update ${STEAMAPPID} -beta ${STEAMBETA} -betapassword ${STEAMBETAPASSWORD} validate \
	+quit
find ${STEAMAPPDIR}/Headless/Data/Assets -type f -atime +7 -delete
find ${STEAMAPPDIR}/Headless/Data/Cache -type f -atime +7 -delete
find /Logs -type f -name *.log -atime +30 -delete
mkdir -p Headless/Migrations Headless/Migrations

# If Mods flag is enabled, do the setup for mods.
if [ $ALLOWMODS -eq 1 ]; then
	# Make sure the Resonite user owns the RML volume we mounted.
	chown -R resonite:resonite /RML

	# Create required directories
	mkdir -p Headless/rml_mods \
			Headless/rml_libs \
			Headless/rml_config \
			Headless/Libraries

	# copy any mods and associated files from our mounted volume
	cp -a /RML/rml_mods/. ${STEAMAPPDIR}/Headless/rml_mods/
	cp -a /RML/rml_libs/. ${STEAMAPPDIR}/Headless/rml_libs/
	cp -a /RML/rml_config/. ${STEAMAPPDIR}/Headless/rml_config/

	# From: https://gist.github.com/steinwaywhw/a4cd19cda655b8249d908261a62687f8?permalink_comment_id=5097031#gistcomment-5097031
	# Fetch the latest release version number for ResoniteModLoader
	latest_version=$(curl -s https://api.github.com/repos/resonite-modding-group/ResoniteModLoader/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
	# Remove the 'v' prefix from the version number
	version=${latest_version#v}
	# Construct the download URLs for RML and Harmony
	harmonydll_url="https://github.com/resonite-modding-group/ResoniteModLoader/releases/download/${latest_version}/0Harmony-Net8.dll"
	rmldll_url="https://github.com/resonite-modding-group/ResoniteModLoader/releases/download/${latest_version}/ResoniteModLoader.dll"

	# Download the required DLLs
	curl -L -o "Headless/rml_libs/0Harmony-Net8.dll" "$harmonydll_url"
	curl -L -o "Headless/Libraries/ResoniteModLoader.dll" "$rmldll_url"
fi

exec $*
