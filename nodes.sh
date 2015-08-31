#!/bin/bash
sudo apt-get install -y ssh
sudo sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sudo service ssh restart
cat << EOF >> /etc/hosts
10.12.0.5       master1.ceph.cluster master1
10.12.0.61      storage1.ceph.cluster storage1
10.12.0.62      storage2.ceph.cluster storage2
10.12.0.63      storage3.ceph.cluster storage3
10.12.0.64      storage4.ceph.cluster storage4
10.12.0.41      monitor1.ceph.cluster monitor1
10.12.0.42      monitor2.ceph.cluster monitor2
10.12.0.43      monitor3.ceph.cluster monitor3
EOF
cat << EOF >> /root/.ssh/authorized_keys
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCvxvtr9PvrCHqw47Let40XMgn1dXNLAIJ9sVisQtMGS9AHHdbbos6W49gGm3iamB4SbLhvTyiMe4o6ByBd1+m316+WePWxO9j3XE8bgEaKIxLkjAYm8LLFxEBEatERp+SmWPM0T0SOfxCTkaBmEHVd+7PXig2Bi76qZ+XO6+eWlHjabPOMG/YFIapGLxnBGxS/m3wlI5b7/frcaqF2+YIlx9jMNgZROx5BqsJNPDWJsd/3e5ak2sKiVYsi1TZzhiAVNzfmViJ7y6syVTxW9kyF7PxbbanROzc+yef34LyIQFSeRIwOLRXuYF0r/oh1Z/3J2oBSz/0HlTkRh81blWHN root@master1
EOF
