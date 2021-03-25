#!/bin/bash
#=====================================#
#                                     #
#       OpenStack on Centos 7         #
#                                     #
#=====================================#

read -p "Create password login OpenStack Admin Dashboard : " passwd

yum install epel-release
yum update -y

setenforce 0
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
systemctl stop firewalld
systemctl stop NetworkManager
systemctl disable firewalld
systemctl disable NetworkManager

yum install -y centos-release-openstack-train
yum install -y openstack-packstack
packstack --gen-answer-file=/root/answer.txt

sed -i "s/^CONFIG_PROVISION_DEMO=.*/CONFIG_PROVISION_DEMO=n/g" /root/answer.txt
sed -i "s/^CONFIG_KEYSTONE_ADMIN_PW=.*/CONFIG_KEYSTONE_ADMIN_PW=${passwd}/g" /root/answer.txt
sed -i "s/^CONFIG_HORIZON_SSL=.*/CONFIG_HORIZON_SSL=n/g" /root/answer.txt
sed -i "s/^CONFIG_NTP_SERVERS=.*/CONFIG_NTP_SERVERS=0.pool.ntp.org,1.pool.ntp.org,2.pool.ntp.org/g" /root/answer.txt

packstack --answer-file /root/answer.txt
