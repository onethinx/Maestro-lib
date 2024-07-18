# OTX-Maestro lib

## Update project
- Use the 'Update project' button to update your project to match the latest OTX-Maestro.<br><br>
 ![](https://raw.githubusercontent.com/onethinx/Readme_assets/main/OTX-Maestro-update-project.png)

- The process if fully automated, no need to manually copy these files.

## I don't see the update button!?
That can happen for projects OTX-Maestro <= V1.0.1.

Please install the [otx-maestro extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=onethinx.otx-maestro) which gives the option to update at project startup.

## How does it work?

The `.vscode/project.json` file specifies the the project version and the location for the update package (update.json). The update package lists files which will be replaced and/or removed at update process.
To maintain / exclude certain files from the update process, these files can be specified in your `project.json` file.

Example (excluding `launch.json` from the update process):
```
{
    "version": "1.0.2",
    "updatePackage":"https://raw.githubusercontent.com/onethinx/Maestro-lib/main/.vscode/update.json",
    "excludeFiles": [
        "./.vscode/launch.json"
    ]
}
```
