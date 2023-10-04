
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Postgres Connection Limit Reached
---

This incident type occurs when the maximum number of connections allowed to a Postgres database has been reached. This prevents new connections from being established and can result in errors or downtime. It is important to monitor connection usage and adjust the maximum connection limit as needed to prevent this issue from occurring.

### Parameters
```shell
export VERSION="PLACEHOLDER"

export DATABASE_NAME="PLACEHOLDER"

export DESIRED_MAXIMUM_CONNECTIONS="PLACEHOLDER"
```

## Debug

### Check current Postgres connections
```shell
sudo su - postgres -c "psql -c 'select count(*) from pg_stat_activity;'"
```

### Check Postgres configuration file for connection settings
```shell
sudo cat /etc/postgresql/${VERSION}/main/postgresql.conf | grep 'max_connections'
```

### Check logs for any connection errors
```shell
sudo tail -n 100 /var/log/postgresql/postgresql-${VERSION}-main.log | grep -i 'connection'
```

### Check Postgres connection limit
```shell
sudo su - postgres -c "psql -c 'show max_connections;'"
```

### Check for any idle connections and terminate them
```shell
sudo su - postgres -c "psql -c 'SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = ${DATABASE_NAME} AND pid <> pg_backend_pid();'"
```

## Repair

### Increase the maximum number of connections allowed by the Postgres database. This can be done in the postgresql.conf file by modifying the max_connections parameter.
```shell


#!/bin/bash



# Set the maximum number of connections desired

MAX_CONNECTIONS=${DESIRED_MAXIMUM_CONNECTIONS}



# Modify the postgresql.conf file to set the new maximum connections

sed -i "s/^max_connections = .*$/max_connections = ${MAX_CONNECTIONS}/" /etc/postgresql/${VERSION}/main/postgresql.conf



# Restart the Postgres service to apply the changes

systemctl restart postgresql.service


```