# 步骤

1. 拷贝文件

`ansible cdh-wei -m copy -a "src=/Users/wei.qi/workspace/ansible/cdh dest=/root/"`

2. 初始化host

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 6"`

3. 替换yum

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 8"`

4. 安装软件

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 2"`

5. initSELINUX

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 4"`

6. initFirewalld

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 5"`

7. 拷贝jdk

`ansible cdh-wei -m copy -a "src=/Users/wei.qi/Downloads/jdk-8u201-linux-x64.rpm dest=/root/"`

8. 安装jdk

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 7"`

9. initsysconf

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 12"`

10. copy mysql driver

`ansible cdh-wei -m copy -a "src=/Users/wei.qi/Downloads/mysql-connector-java-5.1.47/mysql-connector-java-5.1.47-bin.jar dest=/usr/share/java/"`

11. 安装NTP

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 3"`

12. 安装数据库(注意修改数据库密码)

`ansible cdh-wei-master -m shell -a "sh /root/cdh/init.sh 1"`

`ansible cdh-wei-master -m shell -a "sh /root/cdh/init.sh 9"`

13. 初始化数据库

`ansible cdh-wei-master -m shell -a "sh /root/cdh/init.sh 10"`


14. 初始化CM

`ansible cdh-wei -m shell -a "sh /root/cdh/init.sh 14"`

15. 初始化CDH

`ansible cdh-wei-master -m shell -a "sh /root/cdh/init.sh 15"`

16. 安装kafka

`ansible cdh-wei-master -m shell -a "sh /root/cdh/init.sh 17"`

17. 安装spark2

`ansible cdh-wei-master -m shell -a "sh /root/cdh/init.sh 16"`

## 免密方法

1. 在主节点执行

```
ssh-keygen -t rsa
ssh-copy-id -i ~/.ssh/id_rsa.pub root@wei-data1

```
2. 将 authorized_keys 拷贝到本机.

3. 将 authorized_keys 分发到其他节点

`ansible cdh-wei -m copy -a "src=/authorized_keys dest=/root/.ssh/"`


# 启动

#### 数据库初始化
`ansible cdh-wei-master -a "/opt/cm-5.15.1/share/cmf/schema/scm_prepare_database.sh mysql  scm scm Bigdata@123"`

## 启动服务 server

`ansible cdh-wei-master -a "/opt/cm-5.15.1/etc/init.d/cloudera-scm-server start"`

## 启动服务 agent
`ansible cdh-wei -a "/opt/cm-5.15.1/etc/init.d/cloudera-scm-agent start"`