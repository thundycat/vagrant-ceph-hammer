#!/bin/bash
# add ceph repo
wget -q -O- 'https://ceph.com/git/?p=ceph.git;a=blob_plain;f=keys/release.asc' | sudo apt-key add -
echo deb http://ceph.com/debian-hammer/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
sleep 1
sudo apt-get update -y && sudo apt-get install -y ceph-deploy 
cat << EOF > /root/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAr8b7a/T76wh6sOOy3reNFzIJ9XVzSwCCfbFYrELTBkvQBx3W
26LOluPYBpt4mpgeEmy4b08ojHuKOgcgXdfpt9evlnj1sTvY91xPG4BGiiMS5IwG
JvCyxcRARGrREafkpljzNE9Ejn8Qk5GgZhB1Xfuz14oNgYu+qmflzuvnlpR42mzz
jBv2BSGqRi8ZwRsUv5t8JSOW+/363GqhdvmCJcfYzDYGUTseQarCTTw1ibHf93uW
pNrColWLItU2c4YgFTc35lYie8urMlU8VvZMhez8W22p0Ts3Psnn9+C8iEBUnkSM
Di0V7mBdK/6IdWf9ydqAUs/9B5U5EYfNW5VhzQIDAQABAoIBADJsclNVw654kDmO
GBGrtd2hjRnMx3YMf2JvLXC8+qwjs1lXRftbiMfgNGgw0TgHyxid94p2ursR9WUQ
BkjlVzZVuRkBOfnNoT/USx0ofxPBW/oT8O/avG3fDlCSE8ds0jql6Z5n3tLBwI+U
ht7Aeeqr+bsq7xTqcZeQlmv1YEnhc9UqAOe3qeqvgHVaGxls5rRXNvPADB1kx5jx
nspmodoDsJ0Jp9efNPR6ekFAebBBWvQS1FF/stejeVjHPMY8BTgSlVR4wa63ehxT
qDlXNObU/SDmNmbFx/OkERTvnXGEo6DEVSWIQcoa0h0JT+zR+scBOlKJZdy3eKIB
GrI75EECgYEA1DSgaBgOJCL+Y3jrKV+0q1q0KCLXie+rqMJpTX2NSLhIM5Mn34tJ
tDDtQVf52TLymWMj7t9RDQk913Uss3yoI4T8619y01JZZC6pKTRwijdKVjCEE7yw
rIp/Y1s1isetcONcoNsSUfabABVej8IMhXBueC/lbAIczlKDvhRnpSMCgYEA1A3A
6jRRjk+ZbfPnHoV1OanHlTirexvHQAyW5qgVIF0VLdGk2khaQe08GtWFiMZdhCnV
QOB/2JNXhml0zNuDaeErhNwaIRbNchns8FDv4wPFPKMh6nAZe8K5kY/OBYI743BJ
AmCs268MOUAVOmogUsC/dXUA5JngtHnRVyFlpE8CgYBE0PA38Z0cYPDIR11TpILN
kvOblHj7dWrgpnNJuu6HZ6Oafh1PJDd5pOg76ZDPu/LqhTkQ7QC2zolshsZBSqqo
Iid3GRP+rdTpZSxcfXIFkJqdysv6LpXIzn0zNk/tuoVnd4QBcinFxMhNRaDN0+sF
lwlsFnQ7C5BV5HJuwOU/qwKBgGzfYtzcX8MhOzUotNEG1Fj2wnHq1qAucu5/iDqE
sdQb9nO/31PzMeQHWYStfBHtRrZEhCj7GqinfZiVLFLBoYcLBL0CBKhYfMLIbM41
v/ReSzYGy7MCOxM/tub1XmGVrAnp7JI78IQaK7x5Gm0Tb+UM8T/tArhcCPKgWMrT
aswhAoGBAMfo+mF+aieNeRU/7Ny7Ix6ZPW19CTX3fizhw9EXtJM4abcThpeVvjVy
aeKO3J3P7qgO3GzHk0/W3TMXKznY2T4iuL1HXPDwreZjlhqz4khbAhaVG5EvZmcy
NYHPtenZRMWvQnMJRWeSQSLBIA4Qq15wnyMseKHBns6w86XadKlk
-----END RSA PRIVATE KEY-----
EOF
chmod 0600 /root/.ssh/id_rsa
cat << EOF >> /root/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile /dev/null
EOF
cat << EOF >> /etc/hosts
10.0.2.2	master1.ceph.cluster master1
10.12.0.61      storage1.ceph.cluster storage1
10.12.0.62      storage2.ceph.cluster storage2
10.12.0.63      storage3.ceph.cluster storage3
10.12.0.64      storage4.ceph.cluster storage4
10.12.0.41      monitor1.ceph.cluster monitor1
10.12.0.42      monitor2.ceph.cluster monitor2
10.12.0.43      monitor3.ceph.cluster monitor3
EOF
for i in `seq 1 4`; do
                ssh storage1 mkdir -p /var/local/osd$i;
        done
for i in `seq 5 8`; do
                ssh storage2 mkdir -p /var/local/osd$i;
        done
for i in `seq 9 12`; do
                ssh storage3 mkdir -p /var/local/osd$i;
        done
for i in `seq 13 16`; do
                ssh storage4 mkdir -p /var/local/osd$i;
        done
ceph-deploy new monitor1 monitor2 monitor3
ceph-deploy install master1 monitor1 monitor2 monitor3 storage1 storage2 storage3 storage4
ceph-deploy mon create-initial
for i in `seq 1 4`; do
		ceph-deploy osd prepare storage1:/var/local/osd$i;
	done
for i in `seq 5 8`; do
	ceph-deploy osd prepare storage2:/var/local/osd$i;
	done
for i in `seq 9 12`; do
	ceph-deploy osd prepare storage3:/var/local/osd$i;
	done
for i in `seq 13 16`; do
	ceph-deploy osd prepare storage4:/var/local/osd$i;
	done
for i in `seq 1 4`; do
	ceph-deploy osd activate storage1:/var/local/osd$i;
	done
for i in `seq 5 8`; do
	ceph-deploy osd activate storage2:/var/local/osd$i;
	done
for i in `seq 9 12`; do
	ceph-deploy osd activate storage3:/var/local/osd$i;
	done
for i in `seq 13 16`; do
	ceph-deploy osd activate storage4:/var/local/osd$i;
	done
ceph-deploy admin master1 storage1 storage2 storage3 storage4 monitor1 monitor2 monitor3
sudo chmod +r /vagrant/ceph.client.admin.keyring
echo "osd pool default size = 2" >> /vagrant/ceph.conf
echo "osd pool default min size = 1" >> /vagrant/ceph.conf
echo "osd pool default pg num = 256" >> /vagrant/ceph.conf
echo "osd pool default pgp num = 256" >> /vagrant/ceph.conf
ceph-deploy --overwrite-conf config push monitor1 monitor2 monitor3 storage1 storage2 storage3 storage4
