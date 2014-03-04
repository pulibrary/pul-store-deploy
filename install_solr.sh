#!/usr/bin/env bash
set -e

if [ "$EUID" -ne "0" ] ; then
        echo "Script must be run as root." >&2
        exit 1
fi

# check necessary variables
#if $HYDRA_NAME doesn't exist solr-4.6.1
#then
#abort
#else
#continue
#fi

# get the solr installer
mkdir -p /opt/install && cd /opt/install
wget -c http://archive.apache.org/dist/lucene/solr/4.6.1/solr-4.6.1.tgz
tar xvzf solr-4.6.1.tgz

# check the /opt directory
ls -la /opt
# pull environment variables
source /etc/environment
# check that hydra_name exists
echo $HYDRA_NAME

# make the working solr directories
mkdir -p /opt/solr /opt/solr/$HYDRA_NAME /opt/solr/$HYDRA_NAME/lib
ls -la /opt/solr

# copy the .war and .jar files 
cp ./solr-4.6.1/dist/solr-4.6.1.war /opt/solr/$HYDRA_NAME
cp ./solr-4.6.1/dist/*.jar /opt/solr/$HYDRA_NAME/lib
cp -r ./solr-4.6.1/contrib /opt/solr/$HYDRA_NAME/lib
cp -r ./solr-4.6.1/example/solr/collection1 /opt/solr/$HYDRA_NAME/collection1
cp /opt/solr/$HYDRA_NAME/collection1/conf/lang/stopwords_en.txt /opt/solr/$HYDRA_NAME/collection1/conf/
# for v 4.3 
cp ./solr-4.6.1/example/lib/ext/*.jar /usr/share/tomcat7/lib/ 
cp ./solr-4.6.1/example/cloud-scripts/log4j.properties /usr/share/tomcat7/lib/

# create the project xml file
cat > /opt/solr/$HYDRA_NAME/$HYDRA_NAME.xml <<EOF
<?xml version="1.0" encoding="utf-8"?>  
<Context docBase="/opt/solr/pul-store/solr-4.6.1.war" debug="0" crossContext="true">  
    <Environment name="solr/home" type="java.lang.String" value="/opt/solr/pul-store" override="true"/>  
</Context>
EOF

# chown /opt/fedora and /opt/solr
chown -R tomcat7:tomcat7 /opt/fedora
chown -R tomcat7:tomcat7 /opt/solr

# simlink tomcat to the solr xml file
ln -s /opt/solr/$HYDRA_NAME/$HYDRA_NAME.xml /etc/tomcat7/Catalina/localhost/$HYDRA_NAME.xml

# restart tomcat
service tomcat7 restart

# check tomcat, fedora, and solr
# TODO write a test for this - expect? 

