

#!/bin/bash



# Set the maximum number of connections desired

MAX_CONNECTIONS=${DESIRED_MAXIMUM_CONNECTIONS}



# Modify the postgresql.conf file to set the new maximum connections

sed -i "s/^max_connections = .*$/max_connections = ${MAX_CONNECTIONS}/" /etc/postgresql/${VERSION}/main/postgresql.conf



# Restart the Postgres service to apply the changes

systemctl restart postgresql.service