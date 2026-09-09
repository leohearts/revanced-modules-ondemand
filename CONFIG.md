# Config

Adding another app is as easy as this:
```toml
[Some-App]
apkmirror-dlurl = "https://www.apkmirror.com/apk/inc/app"
# or uptodown-dlurl = "https://app.en.uptodown.com/android"
```

## More about other options:

There exists an example below with all defaults shown and all the keys explicitly set.  
**All keys are optional** (except download urls) and are assigned to their default values if not set explicitly.  

```toml
parallel-jobs = 1                    # amount of cores to use for parallel patching, if not set $(nproc) is used
compression-level = 9                # module zip compression level

patches-source = "MorpheApp/morphe-patches" # where to fetch patches bundle (.mpp) from. default: "MorpheApp/morphe-patches"
cli-source = "MorpheApp/morphe-cli"         # where to fetch cli (morphe-desktop jar) from. default: "MorpheApp/morphe-cli"
# options like cli-source can also set per app
rv-brand = "Morphe" # rebrand from 'Morphe' to something different. default: "Morphe"

patches-version = "v1.41.0" # 'latest', 'dev', or a version number. default: "latest"
cli-version = "v1.15.0"     # 'latest', 'dev', or a version number. default: "latest"

[Some-App]
app-name = "SomeApp" # if set, release name becomes SomeApp instead of Some-App. default is same as table name, which is 'Some-App' here.
enabled = true       # whether to build the app. default: true
version = "auto"     # 'auto', 'latest', 'beta' or a version number (e.g. '17.40.41'). default: auto
build-mode = "apk"   # 'both', 'apk' or 'module'. default: apk

# optional args to be passed to cli. can be used to set patch options
# multiline strings in the config is supported
patcher-args = """\
  -OdarkThemeBackgroundColor=#FF0F0F0F \
  -Oanother-option=value \
  """

# 'auto' option gets the latest possible version supported by all the included patches
# 'latest' gets the latest stable without checking patches support. 'beta' gets the latest beta/alpha
# whitespace seperated list of patches to exclude. default: ""
excluded-patches = """\
  'Some Patch' \
  'Some Other Patch' \
  """

included-patches = "'Some Patch'"                          # whitespace seperated list of non-default patches to include. default: ""
include-stock = true                                       # includes stock apk in the module. default: true
exclusive-patches = false                                  # exclude all patches by default. default: false
apkmirror-dlurl = "https://www.apkmirror.com/apk/inc/app"
uptodown-dlurl = "https://spotify.en.uptodown.com/android"
direct-dlurl = "https://github.com/user/repo/releases/download/v1/app.apk" # direct download URL, takes priority
archive-dlurl = "https://archive.org/download/jhc-apks/apks/com.example.app"
module-prop-name = "some-app-morphe"                       # magisk module prop name.
dpi = "360-480dpi"                                         # used to select apk variant from apkmirror. default: nodpi
arch = "arm64-v8a"                                         # 'arm64-v8a', 'arm-v7a', 'all', 'both'. 'both' downloads both arm64-v8a and arm-v7a. default: all
```

## Using community patches

Set `patches-source` per app to any GitHub repo that publishes Morphe patches (.mpp files in releases):

```toml
[YouTube-Custom]
app-name = "YouTube"
patches-source = "username/morphe-patches-repo"
rv-brand = "CustomBrand"
build-mode = "both"
apkmirror-dlurl = "https://www.apkmirror.com/apk/google-inc/youtube"
```

Browse available community patches at [awesome-morphe](https://github.com/nvbangg/awesome-morphe).