#!/bin/bash
# fileに書いてあるipアドレスに対して、netplanを適用する
# このスクリプトは、ip.txtというファイルにipアドレスを書いておく必要がある
# また、ip.txtの中身は、ipアドレスと改行のみである必要がある
# 例:
#```ip.txt `
#000.000.000.000
#111.111.111.111
#222.222.222.222
#333.333.333.333
#444.444.444.444
#555.555.555.555
#```

num=2
while read line
do
    echo $line
    ssh -i ~/.ssh/isucon ubuntu@$line "sudo touch /etc/netplan/01-netcfg.yaml"
    ssh -i ~/.ssh/isucon ubuntu@$line "sudo sh -c \"echo \"
  ethernets:
    ens4:
      addresses:
        - 192.168.0.$num/24
      dhcp4: 'no'
      dhcp6: 'no'
  renderer: networkd
  version: 2
\" > /etc/netplan/01-netcfg.yaml\" "
    ssh -i ~/.ssh/isucon ubuntu@$line "sudo netplan apply"
    echo "$line $num" >> log.txt
    #numは2,3,4,5を循環する
    if [ $num -eq 5 ]; then
        num=2
    else
        num=$((num+1))
    fi
done < ip.txt

