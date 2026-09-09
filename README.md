# Morphe Modules On-Demand
[![CI](https://github.com/leohearts/revanced-modules-ondemand/actions/workflows/ci.yml/badge.svg?event=schedule)](https://github.com/leohearts/revanced-modules-ondemand/actions/workflows/ci.yml)

Extensive [Morphe](https://github.com/MorpheApp) builder, forked from [j-hc/revanced-magisk-module](https://github.com/j-hc/revanced-magisk-module).

Get the [latest CI release](https://github.com/leohearts/revanced-modules-ondemand/releases).

Uses [**zygisk-detach**](https://github.com/j-hc/zygisk-detach) to detach YouTube and YT Music from Play Store if you are using magisk modules.

<details><summary><big>Features</big></summary>
<ul>
 <li>Support all [Morphe](https://github.com/MorpheApp/morphe-patches) apps and community patches</li>
 <li>Can build Magisk modules and non-root APKs</li>
 <li>Updated daily with the latest versions of apps and patches</li>
 <li>Optimize APKs and modules for size</li>
 <li>Modules</li>
    <ul>
     <li>recompile invalidated odex for faster usage</li>
     <li>receive updates from Magisk app</li>
     <li>do not break safetynet or trigger root detections</li>
     <li>handle installation of the correct version of the stock app and all that</li>
     <li>support Magisk and KernelSU</li>
    </ul>
</ul>
Note that the <a href="../../actions/workflows/ci.yml">CI workflow</a> is scheduled to build the modules and APKs everyday using GitHub Actions if there is a change in Morphe patches. You may want to disable it.
</details>

## To include/exclude patches or patch other apps
 * Customize [`config.toml`](./config.toml)
 * Run the build [workflow](../../actions/workflows/build.yml)
 * Grab your modules and APKs from [releases](../../releases)

See also [`CONFIG.md`](./CONFIG.md)

## Building Locally
### On Termux
```console
bash <(curl -sSf https://raw.githubusercontent.com/leohearts/revanced-modules-ondemand/main/build-termux.sh)
```

### On Desktop
```console
$ git clone https://github.com/leohearts/revanced-modules-ondemand
$ cd revanced-modules-ondemand
$ ./build.sh
```

## Community Patches
To use community patches, set `patches-source` in `config.toml` per app:

```toml
[YouTube-Custom]
app-name = "YouTube"
patches-source = "username/morphe-patches-repo"
# rv-brand = "MyBrand"
build-mode = "both"
apkmirror-dlurl = "https://www.apkmirror.com/apk/google-inc/youtube"
```

Browse available community patches at [awesome-morphe](https://github.com/nvbangg/awesome-morphe).
