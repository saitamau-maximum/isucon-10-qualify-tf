# ISUCON10予選をさくらのクラウドでやるためのterraform

## 使い方

### envs/*.tfvarsを作って必要な情報を書く

```sh
cp envs/example.tfvars envs/<your_env_name>.tfvars
```

```txt
switch_name      = ""
benchmarker_name = ""
app_name         = ""
```

### terraformを実行する

```sh
terraform init
terraform workspace new <your_env_name> # or terraform workspace select <your_env_name>
terraform apply -var-file=envs/<your_env_name>.tfvars
```

ただし、実行には環境変数として`SAKURACLOUD_ACCESS_TOKEN`と`SAKURACLOUD_ACCESS_TOKEN_SECRET`が必要です。

### terraformを破棄する

```sh
terraform destroy -var-file=envs/<your_env_name>.tfvars
```

「ISUCON」は、LINE株式会社の商標または登録商標です。
