# operation-notebook

## niicloudoperation/notebookとの差分

[niicloudoperation/notebook](https://hub.docker.com/r/niicloudoperation/notebook/)から以下の点が変わっています

- aws cliを導入
- gcloudを導入
- ansibleカーネルを導入
- powershellカーネルを導入
- sshカーネルを導入
- bashカーネルを削除

## powershell環境

マイクロソフト純正のコンテナイメージを参考にしています

https://github.com/PowerShell/PowerShell-Docker/blob/master/release/stable/ubuntu18.04/docker/Dockerfile

ansibleにwinrmモジュールを追加しています

