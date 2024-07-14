# resonite-headless-net8
Docker image of a Resonite headless server using the newly available net8.0 build based on [ShadowPanther's resonite-headless image](https://github.com/shadowpanther/resonite-headless).

## Mod Configuration
This also includes the environment variable `$ALLOWMODS` as a flag to enable/disable the use of [ResoniteModLoader](https://github.com/resonite-modding-group/ResoniteModLoader) mods. If set to `1`, on running `setup_resonite.sh` the appropriate directories for RML will be generated. Mods and their associated libs/configs will be copied from the `RML` folder into the Resonite installation directory. The script will automatically grab the latest `0Harmony-Net8.dll` and `ResoniteModLoader.dll`  from GitHub and install them as well.

## General Use/Configuration
Send the command `/headlessCode` to **Resonite** bot (the one that sends you messages about Patreon and storage) in Resonite to get the beta key.

Steam login is required to download the client. You'll have to disable SteamGuard, so probably create a separate Steam account for your headless server.

Sample docker-compose:
```yaml
version: "3.3"
services:
  resonite:
    image: pointeroffset/resonite-headless-net8:latest
    container_name: resonite-headless
    # Optionally define a hostname. Useful for log file naming.
    #hostname: resonite-headless 
    tty: true
    stdin_open: true
    environment:
      ALLOWMODS: 0
      STEAMBETA: headless
      STEAMBETAPASSWORD: CHANGEME
      STEAMLOGIN: "USER PASSWORD"
    volumes:
      - "./Config:/Config:ro"
      - "./Logs:/Logs"
      - "./RML:/RML"
      - "/etc/localtime:/etc/localtime:ro"
    restart: unless-stopped
```

Place your `Config.json` into `Config` folder. Logs would be stored in `Logs` folder.

You probably need to set `vm.max_map_count=262144` by doing `echo "vm.max_map_count=262144" >> /etc/sysctl.conf` lest you end up with frequent GC crashes.
