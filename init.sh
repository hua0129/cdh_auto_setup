#scp cloudera-manager-centos7-cm5.15.1_x86_64.tar.gz root@wei-data2:/root/
#scp root@172.30.3.106:/opt/cloudera/parcel-repo/*.parcel ./opt/cloudera/parcel-repo/
#scp root@172.30.3.106:/opt/cloudera/parcel-repo/*.sha ./opt/cloudera/parcel-repo/
#scp root@172.30.3.106:/opt/cloudera/parcel-repo/manifest.json ./opt/cloudera/parcel-repo/
#wget -P /opt/cloudera/csd  http://archive.cloudera.com/spark2/csd/SPARK2_ON_YARN-2.3.0.cloudera4.jar

initAliYum(){
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
    curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
}

initSoft(){
    mkdir -p /usr/share/java/
    yum install -y net-tools vim  ntp wget httpd mod_ssl openssl
    yum install -y cyrus-sasl*

}

initHost(){
    echo "初始化hosts"
    cat /root/cdh/hosts > /etc/hosts
}

initFirewalld(){
    echo "关闭firewalld"
    systemctl stop firewalld.service
    systemctl disable firewalld.service
}

initSELINUX(){
   echo "关闭SELINUX"
   sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config
}

initNtp(){
  echo "安装ntp"
  sed -i 's/server 0.centos.pool.ntp.org iburst/#server 0.centos.pool.ntp.org iburst/' /etc/ntp.conf
  sed -i 's/server 1.centos.pool.ntp.org iburst/#server 0.centos.pool.ntp.org iburst/' /etc/ntp.conf
  sed -i 's/server 2.centos.pool.ntp.org iburst/#server 0.centos.pool.ntp.org iburst/' /etc/ntp.conf
  sed -i 's/server 3.centos.pool.ntp.org iburst/#server 0.centos.pool.ntp.org iburst/' /etc/ntp.conf
  echo server time.windows.com prefer >> /etc/ntp.conf
  systemctl enable ntpd
  systemctl start ntpd
}

initJava(){
    rpm -ivh /root/jdk-8u201-linux-x64.rpm
    cat /root/cdh/Java_home >> /etc/profile
    source /etc/profile
}

initMysql(){
    wget http://repo.mysql.com/mysql57-community-release-el7-10.noarch.rpm
    yum -y install mysql57-community-release-el7-10.noarch.rpm
    yum -y install mysql-community-server
    # 开机启动
    systemctl enable mysqld.service
    # 启动
    systemctl start mysqld.service
}

modifyMysql(){
    systemctl stop mysqld.service
    cat /root/cdh/my.cnf > /etc/my.cnf
    systemctl start mysqld.service
}

initsysconf(){
    # echo vm.swappiness = 0 >> /etc/sysctl.conf
    # sysctl -p
    # echo never > /sys/kernel/mm/transparent_hugepage/enabled
    # echo never > /sys/kernel/mm/transparent_hugepage/defrag
    sysctl -w vm.swappiness=1
    echo "vm.swappiness=1" >> /etc/sysctl.conf

    echo never > /sys/kernel/mm/transparent_hugepage/defrag
    echo never > /sys/kernel/mm/transparent_hugepage/enabled
    echo "echo never > /sys/kernel/mm/transparent_hugepage/defrag" >> /etc/rc.local
    echo "echo never > /sys/kernel/mm/transparent_hugepage/enabled" >> /etc/rc.local
}

initDB(){
    mysql -uroot -pBigdata@123 </root/cdh/initDB.sql
}

initCDH(){
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/cdh5/parcels/5.15.1/CDH-5.15.1-1.cdh5.15.1.p0.4-el7.parcel
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/cdh5/parcels/5.15.1/CDH-5.15.1-1.cdh5.15.1.p0.4-el7.parcel.sha1
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/cdh5/parcels/5.15.1/manifest.json

    mv /opt/cloudera/parcel-repo/CDH-5.15.1-1.cdh5.15.1.p0.4-el7.parcel.sha1 /opt/cloudera/parcel-repo/CDH-5.15.1-1.cdh5.15.1.p0.4-el7.parcel.sha
    cp /usr/share/java/mysql-connector-java.jar /opt/cm-5.15.1/share/cmf/lib/
    chown -R cloudera-scm:cloudera-scm /opt/**
}

initCM(){
    wget https://archive.cloudera.com/cm5/cm/5/cloudera-manager-centos7-cm5.15.1_x86_64.tar.gz
    tar zxvf cloudera-manager-centos7-cm5.15.1_x86_64.tar.gz -C /opt  
    useradd --comment "Cloudera SCM User" cloudera-scm
    chown -R cloudera-scm:cloudera-scm /opt/**
    mv /usr/share/java/mysql-connector-java-5.1.47-bin.jar /usr/share/java/mysql-connector-java.jar
    sed -i 's/server_host=localhost/server_host=wei-data1/' /opt/cm-5.15.1/etc/cloudera-scm-agent/config.ini
}

install_spark2(){
    mv /opt/cloudera/parcel-repo/manifest.json /opt/cloudera/parcel-repo/manifest.json.spark2 
    wget -P /opt/cloudera/csd  http://archive.cloudera.com/spark2/csd/SPARK2_ON_YARN-2.3.0.cloudera4.jar

    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/spark2/parcels/latest/SPARK2-2.3.0.cloudera4-1.cdh5.13.3.p0.611179-el7.parcel
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/spark2/parcels/latest/SPARK2-2.3.0.cloudera4-1.cdh5.13.3.p0.611179-el7.parcel.sha1
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/spark2/parcels/latest/manifest.json

    mv /opt/cloudera/parcel-repo/SPARK2-2.3.0.cloudera4-1.cdh5.13.3.p0.611179-el7.parcel.sha1 /opt/cloudera/parcel-repo/SPARK2-2.3.0.cloudera4-1.cdh5.13.3.p0.611179-el7.parcel.sha
   
    chown -R cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/**

}

install_kafka(){
    mv /opt/cloudera/parcel-repo/manifest.json /opt/cloudera/parcel-repo/manifest.json.kafka 
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/kafka/parcels/latest/KAFKA-3.1.1-1.3.1.1.p0.2-el7.parcel
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/kafka/parcels/latest/KAFKA-3.1.1-1.3.1.1.p0.2-el7.parcel.sha1
    wget -P /opt/cloudera/parcel-repo https://archive.cloudera.com/kafka/parcels/latest/manifest.json

    mv /opt/cloudera/parcel-repo/KAFKA-3.1.1-1.3.1.1.p0.2-el7.parcel.sha1 /opt/cloudera/parcel-repo/KAFKA-3.1.1-1.3.1.1.p0.2-el7.parcel.sha
   
    chown -R cloudera-scm:cloudera-scm /opt/cloudera/parcel-repo/**
}

case $1 in
    1)  echo '安装mysql'
        initMysql
    ;;
    2)  echo '安装软件'
        initSoft
    ;;
    3)  echo 'initNtp'
        initNtp
    ;;
    4)  echo 'initSELINUX'
        initSELINUX
    ;;
    5)  echo 'initFirewalld'
        initFirewalld
    ;;
    6)  echo 'initHost'
        initHost
    ;;
    7)  echo '安装Java'
        initJava
    ;; 
    8)  echo 'initAliYum'
        initAliYum
    ;; 
    9)  echo 'modifyMysql'
        modifyMysql
    ;;
    10)  echo 'initDB'
        initDB
    ;;
    11)  echo 'initCM'
        initCM
    ;;
    12)  echo 'initsysconf'
        initsysconf
    ;;
    14)  echo 'initCM'
        initCM
    ;;
    15)  echo 'initCDH'
        initCDH  
    ;; 
    16)  echo 'install_spark2'
        install_spark2
    ;;
    17)  echo 'install_kafka'
        install_kafka
    ;;     
    *)  echo '你没有输入 1 到 15 之间的数字'
    ;;
esac