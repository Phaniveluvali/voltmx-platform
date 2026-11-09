{{/*
Expand the name of the chart.
*/}}
{{- define "voltmx.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "voltmx.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "voltmx.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "voltmx.labels" -}}
helm.sh/chart: {{ include "voltmx.chart" . }}
{{ include "voltmx.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "voltmx.selectorLabels" -}}
app.kubernetes.io/name: {{ include "voltmx.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "voltmx.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "voltmx.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Determine the value of the db host service name
*/}}
{{- define "resolveDbHostName" -}}
{{- .Values.dbHost }}
{{- end -}}


{{/* This used to be the authconfigdb_url */}}
{{- define "authDbUrl" }}
{{- if eq .Values.dbType "mysql" -}}
{{- if .Values.dbPort -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbPrefix }}idconfigdb{{ .Values.dbSuffix }}?autoReconnect=true&prepStmtCacheSize=400&prepStmtCacheSqlLimit=2048&readOnlyPropagatesToServer=false&cachePrepStmts=true&useLocalSessionState=true&useLocalTransactionState=true&rewriteBatchedStatements=true"
{{- else -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}/{{ .Values.dbPrefix }}idconfigdb{{ .Values.dbSuffix }}?autoReconnect=true&prepStmtCacheSize=400&prepStmtCacheSqlLimit=2048&readOnlyPropagatesToServer=false&cachePrepStmts=true&useLocalSessionState=true&useLocalTransactionState=true&rewriteBatchedStatements=true"
{{- end -}}
{{- else if eq .Values.dbType "sqlserver" -}}
{{- if .Values.dbPort -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }};databasename={{ .Values.dbPrefix }}idconfigdb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- else -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }};databasename={{ .Values.dbPrefix }}idconfigdb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- end -}}
{{- else if eq .Values.dbType "oracle" -}}
{{- if .Values.dbPort -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbService }}"
{{- else -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}/{{ .Values.dbService }}"
{{- end -}}
{{- else if eq .Values.dbType "db2" -}}
{{- if .Values.dbPort -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbInstance }}:currentSchema=idconfigdb;"
{{- else -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}/{{ .Values.dbInstance }}:currentSchema=idconfigdb;"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "waasDbUrl" }}
{{- if eq .Values.dbType "mysql" -}}
{{- if .Values.dbPort -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbPrefix }}mfconsoledb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- else -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}/{{ .Values.dbPrefix }}mfconsoledb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- end -}}
{{- else if eq .Values.dbType "sqlserver" -}}
{{- if .Values.dbPort -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }};databasename={{ .Values.dbPrefix }}mfconsoledb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- else -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }};databasename={{ .Values.dbPrefix }}mfconsoledb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- end -}}
{{- else if eq .Values.dbType "oracle" -}}
{{- if .Values.dbPort -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbService }}"
{{- else -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}/{{ .Values.dbService }}"
{{- end -}}
{{- else if eq .Values.dbType "db2" -}}
{{- if .Values.dbPort -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbInstance }}:currentSchema=mfconsoledb;"
{{- else -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}/{{ .Values.dbInstance }}:currentSchema=mfconsoledb;"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "accountsDbUrl" }}
{{- if eq .Values.dbType "mysql" -}}
{{- if .Values.dbPort -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbPrefix }}mfaccountsdb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- else -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}/{{ .Values.dbPrefix }}mfaccountsdb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- end -}}
{{- else if eq .Values.dbType "sqlserver" -}}
{{- if .Values.dbPort -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }};databasename={{ .Values.dbPrefix }}mfaccountsdb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- else -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }};databasename={{ .Values.dbPrefix }}mfaccountsdb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- end -}}
{{- else if eq .Values.dbType "oracle" -}}
{{- if .Values.dbPort -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbService }}"
{{- else -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}/{{ .Values.dbService }}"
{{- end -}}
{{- else if eq .Values.dbType "db2" -}}
{{- if .Values.dbPort -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbInstance }}:currentSchema=mfaccountsdb;"
{{- else -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}/{{ .Values.dbInstance }}:currentSchema=mfaccountsdb;"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "reportsDbUrl" }}
{{- if eq .Values.dbType "mysql" -}}
{{- if .Values.dbPort -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbPrefix }}mfreportsdb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- else -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}/{{ .Values.dbPrefix }}mfreportsdb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- end -}}
{{- else if eq .Values.dbType "sqlserver" -}}
{{- if .Values.dbPort -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }};databasename={{ .Values.dbPrefix }}mfreportsdb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- else -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }};databasename={{ .Values.dbPrefix }}mfreportsdb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- end -}}
{{- else if eq .Values.dbType "oracle" -}}
{{- if .Values.dbPort -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbService }}"
{{- else -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}/{{ .Values.dbService }}"
{{- end -}}
{{- else if eq .Values.dbType "db2" -}}
{{- if .Values.dbPort -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbInstance }}:currentSchema=mfreportsdb;"
{{- else -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}/{{ .Values.dbInstance }}:currentSchema=mfreportsdb;"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "adminDbUrl" }}
{{- if eq .Values.dbType "mysql" -}}
{{- if .Values.dbPort -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbPrefix }}admindb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- else -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}/{{ .Values.dbPrefix }}admindb{{ .Values.dbSuffix }}?autoReconnect=true"
{{- end -}}
{{- else if eq .Values.dbType "sqlserver" -}}
{{- if .Values.dbPort -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }};databasename={{ .Values.dbPrefix }}admindb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- else -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }};databasename={{ .Values.dbPrefix }}admindb{{ .Values.dbSuffix }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- end -}}
{{- else if eq .Values.dbType "oracle" -}}
{{- if .Values.dbPort -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbService }}"
{{- else -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}/{{ .Values.dbService }}"
{{- end -}}
{{- else if eq .Values.dbType "db2" -}}
{{- if .Values.dbPort -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbInstance }}:currentSchema=admindb;"
{{- else -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}/{{ .Values.dbInstance }}:currentSchema=admindb;"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "kpnsDbUrl" }}
{{- if eq .Values.dbType "mysql" -}}
{{- if .Values.dbPort -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbPrefix }}kpnsdb{{ .Values.dbSuffix }}?autoReconnect=true&useUnicode=yes&characterEncoding=UTF-8&cachePrepStmts=true&cacheCallableStmts=true&cacheServerConfiguration=true&useLocalSessionState=true&elideSetAutoCommits=true&alwaysSendSetIsolation=false&enableQueryTimeouts=false&rewriteBatchedStatements=true&max_allowed_packet=104857600"
{{- else -}}
"jdbc:mysql://{{ template "resolveDbHostName" . }}/{{ .Values.dbPrefix }}kpnsdb{{ .Values.dbSuffix }}?autoReconnect=true&useUnicode=yes&characterEncoding=UTF-8&cachePrepStmts=true&cacheCallableStmts=true&cacheServerConfiguration=true&useLocalSessionState=true&elideSetAutoCommits=true&alwaysSendSetIsolation=false&enableQueryTimeouts=false&rewriteBatchedStatements=true&max_allowed_packet=104857600"
{{- end -}}
{{- else if eq .Values.dbType "sqlserver" -}}
{{- if .Values.dbPort -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }};databasename={{ .Values.dbPrefix }}kpnsdb{{ .Values.dbSuffix }};user={{ .Values.dbUser }};password={{ .Values.dbPass }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"
{{- else -}}
"jdbc:sqlserver://{{ template "resolveDbHostName" . }};databasename={{ .Values.dbPrefix }}kpnsdb{{ .Values.dbSuffix }};user={{ .Values.dbUser }};password={{ .Values.dbPass }};sendStringParametersAsUnicode=true;encrypt=true;trustServerCertificate=true;"

{{- end -}}
{{- else if eq .Values.dbType "oracle" -}}
{{- if .Values.dbPort -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbService }}"
{{- else -}}
"jdbc:oracle:thin:@{{ template "resolveDbHostName" . }}/{{ .Values.dbService }}"
{{- end -}}
{{- else if eq .Values.dbType "db2" -}}
{{- if .Values.dbPort -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}:{{ .Values.dbPort }}/{{ .Values.dbInstance }}:currentSchema=kpnsdb;"
{{- else -}}
"jdbc:db2://{{ template "resolveDbHostName" . }}/{{ .Values.dbInstance }}:currentSchema=kpnsdb;"
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "preInstallDbNameList" -}}
{{- printf "%s, %s, %s, %s, %s and %s" (include "mfconsoledbname" . ) (include "mfaccountsdbname" . ) (include "mfreportsdbname" . ) (include "idconfigdbname" . ) (include "admindbname" . ) (include "kpnsdbname" . ) -}}
{{- end -}}

{{- define "mySQLConnectionParms" -}}
{{- if eq .Values.dbType "mysql" -}}
?relaxAutoCommit=true&autoReconnect=true
{{- end -}}
{{- end -}}

{{- define "authDbDatasource" }}
{{- if eq .Values.dbType "mysql" -}}
"com.mysql.cj.jdbc.MysqlDataSource"
{{- else if eq .Values.dbType "sqlserver" -}}
"com.microsoft.sqlserver.jdbc.SQLServerDataSource"
{{- else if eq .Values.dbType "oracle" -}}
"oracle.jdbc.pool.OracleDataSource"
{{- else if eq .Values.dbType "db2" -}}
"com.ibm.db2.jcc.DB2DataSource"
{{- end -}}
{{- end -}}

{{- define "dbDriver" }}
{{- if eq .Values.dbType "mysql" -}}
"com.mysql.cj.jdbc.Driver"
{{- else if eq .Values.dbType "oracle" -}}
"oracle.jdbc.driver.OracleDriver"
{{- else if eq .Values.dbType "db2" -}}
"com.ibm.db2.jcc.DB2Driver"
{{- else if eq .Values.dbType "sqlserver" -}}
"com.microsoft.sqlserver.jdbc.SQLServerDriver"
{{- end -}}
{{- end -}}

{{- define "isMySQLCluster" }}
{{- if eq .Values.isCluster "cluster" -}}
true
{{- else -}}
false
{{- end -}}
{{- end -}}

{{- define "adminDbDialect" }}
{{- if eq .Values.dbType "mysql" -}}
"com.kony.console.admin.dialect.CustomMySQLDialect"
{{- else if eq .Values.dbType "oracle" -}}
"com.kony.console.admin.dialect.CustomOracleDialect"
{{- else if eq .Values.dbType "db2" -}}
"com.kony.console.admin.dialect.CustomDB2Dialect"
{{- else if eq .Values.dbType "sqlserver" -}}
"com.kony.console.admin.dialect.CustomSQLServerDialect"
{{- end -}}
{{- end -}}

{{- define "authDbDialect" }}
{{- if eq .Values.dbType "mysql" -}}
"org.hibernate.dialect.MySQLDialect"
{{- else if eq .Values.dbType "oracle" -}}
"org.hibernate.dialect.Oracle10gDialect"
{{- else if eq .Values.dbType "db2" -}}
"org.hibernate.dialect.DB2Dialect"
{{- else if eq .Values.dbType "sqlserver" -}}
"org.hibernate.dialect.SQLServerDialect"
{{- end -}}
{{- end -}}

{{- define "kpnsDbDialect" }}
{{- if eq .Values.dbType "mysql" -}}
"org.hibernate.dialect.MySQLDialect"
{{- else if eq .Values.dbType "oracle" -}}
"org.hibernate.dialect.Oracle10gDialect"
{{- else if eq .Values.dbType "db2" -}}
"org.hibernate.dialect.DB2Dialect"
{{- else if eq .Values.dbType "sqlserver" -}}
"com.kony.kms.dialect.KMSSQLServerDialect"
{{- end -}}
{{- end -}}

{{- define "dbDialect" }}
{{- if eq .Values.dbType "mysql" -}}
"org.hibernate.dialect.MySQLDialect"
{{- else if eq .Values.dbType "oracle" -}}
"org.hibernate.dialect.Oracle10gDialect"
{{- else if eq .Values.dbType "db2" -}}
"org.hibernate.dialect.DB2Dialect"
{{- else if eq .Values.dbType "sqlserver" -}}
"org.hibernate.dialect.SQLServerDialect"
{{- end -}}
{{- end -}}

{{- define "kpnsDbDelegateClass" }}
{{- if eq .Values.dbType "mysql" -}}
"org.quartz.impl.jdbcjobstore.StdJDBCDelegate"
{{- else if eq .Values.dbType "oracle" -}}
"org.quartz.impl.jdbcjobstore.StdJDBCDelegate"
{{- else if eq .Values.dbType "db2" -}}
"org.quartz.impl.jdbcjobstore.StdJDBCDelegate"
{{- else if eq .Values.dbType "sqlserver" -}}
"org.quartz.impl.jdbcjobstore.MSSQLDelegate"
{{- end -}}
{{- end -}}

{{- define "dbValidationQuery" }}
{{- if eq .Values.dbType "mysql" -}}
"SELECT 1"
{{- else if eq .Values.dbType "oracle" -}}
"select 1 from dual"
{{- else if eq .Values.dbType "db2" -}}
"SELECT 1 FROM sysibm.sysdummy1"
{{- else if eq .Values.dbType "sqlserver" -}}
"SELECT 1"
{{- end -}}
{{- end -}}

{{- define "metricsModuleName" }}
{{- if eq .Values.dbType "mysql" -}}
"com.mysql"
{{- else if eq .Values.dbType "oracle" -}}
"com.oracle"
{{- else if eq .Values.dbType "db2" -}}
"com.db2"
{{- else if eq .Values.dbType "sqlserver" -}}
"com.microsoft"
{{- end -}}
{{- end -}}

{{- define "dbJobName" -}}
voltmx-foundry-db-{{ now | date "20060102150405" }}
{{- end -}}

{{- /*
bad naming, but used to follow the old templates for consistency
*/ -}}
{{- define "db_choice" -}}
{{- if (eq .Values.dbType "sqlserver") -}}
{{- "MSSQL" -}}
{{- else -}}
{{- (upper .Values.dbType) -}}
{{- end -}}
{{- end -}}

{{- /*
bad naming, but used to follow the old templates for consistency
*/ -}}
{{- define "fabric_db_type" -}}
{{- if (eq .Values.dbType "sqlserver") -}}
{{- "mssql" -}}
{{- else -}}
{{- .Values.dbType -}}
{{- end -}}
{{- end -}}

{{- /*
bad naming, but used to follow the old templates for consistency
*/ -}}
{{- define "admin_db_type" -}}
{{- (lower .Values.dbType) -}}
{{- end -}}

{{- define "mfaccountsdbname" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- printf "%s%s%s" .Values.dbPrefix "mfaccountsdb" .Values.dbSuffix | upper -}}
{{- else  -}}
{{ .Values.dbPrefix }}mfaccountsdb{{ .Values.dbSuffix }}
{{- end -}}
{{- end -}}

{{- define "mfreportsdbname" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- printf "%s%s%s" .Values.dbPrefix "mfreportsdb" .Values.dbSuffix | upper -}}
{{- else  -}}
{{ .Values.dbPrefix }}mfreportsdb{{ .Values.dbSuffix }}
{{- end -}}
{{- end -}}

{{- define "idconfigdbname" -}}
{{- if eq .Values.dbType "oracle" -}}
{{ printf "%sidconfigdb%s" .Values.dbPrefix .Values.dbSuffix | upper -}}
{{- else  -}}
{{ printf "%sidconfigdb%s" .Values.dbPrefix .Values.dbSuffix }}
{{- end -}}
{{- end -}}

{{- define "mfconsoledbname" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- printf "%s%s%s" .Values.dbPrefix "mfconsoledb" .Values.dbSuffix | upper -}}
{{- else  -}}
{{ .Values.dbPrefix }}mfconsoledb{{ .Values.dbSuffix }}
{{- end -}}
{{- end -}}

{{- define "admindbname" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- printf "%s%s%s" .Values.dbPrefix "admindb" .Values.dbSuffix | upper -}}
{{- else  -}}
{{ .Values.dbPrefix }}admindb{{ .Values.dbSuffix }}
{{- end -}}
{{- end -}}

{{- define "kpnsdbname" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- printf "%s%s%s" .Values.dbPrefix "kpnsdb" .Values.dbSuffix | upper -}}
{{- else  -}}
{{ .Values.dbPrefix }}kpnsdb{{ .Values.dbSuffix }}
{{- end -}}
{{- end -}}

{{- define "mfaccountsdb_user_name" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- include "mfaccountsdbname" . -}}
{{- else  -}}
{{ .Values.dbUser }}
{{- end -}}
{{- end -}}

{{- define "mfconsoledb_user_name" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- include "mfconsoledbname" . -}}
{{- else  -}}
{{ .Values.dbUser }}
{{- end -}}
{{- end -}}

{{- define "kpnsdb_user_name" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- include "kpnsdbname" . -}}
{{- else  -}}
{{ .Values.dbUser }}
{{- end -}}
{{- end -}}

{{- define "admindb_user_name" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- include "admindbname" . -}}
{{- else  -}}
{{ .Values.dbUser }}
{{- end -}}
{{- end -}}

{{- define "idconfigdb_user_name" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- include "idconfigdbname" . -}}
{{- else  -}}
{{ .Values.dbUser }}
{{- end -}}
{{- end -}}

{{- define "mfreportsdb_user_name" -}}
{{- if eq .Values.dbType "oracle" -}}
{{- include "mfreportsdbname" . -}}
{{- else  -}}
{{ .Values.dbUser }}
{{- end -}}
{{- end -}}

{{- define "kpnsdb_defaultcatalog" -}}
{{- if eq .Values.dbType "oracle" -}}
""
{{- else  -}}
{{- include "kpnsdbname" . -}}
{{- end -}}
{{- end -}}

{{- define "apiportalImage" -}}
{{- if .Values.apiportal.imageTagOverride -}}
{{ .Values.apiportal.imageTagOverride }}
{{- else -}}
{{ .Values.foundryBuildVer }}
{{- end -}}
{{- end -}}

{{- define "consoleImage" -}}
{{- if .Values.console.imageTagOverride -}}
{{ .Values.console.imageTagOverride }}
{{- else -}}
{{ .Values.foundryBuildVer }}
{{- end -}}
{{- end -}}

{{- define "engagementImage" -}}
{{- if .Values.engagement.imageTagOverride -}}
{{ .Values.engagement.imageTagOverride }}
{{- else -}}
{{ .Values.foundryBuildVer }}
{{- end -}}
{{- end -}}

{{- define "identityImage" -}}
{{- if .Values.identity.imageTagOverride -}}
{{ .Values.identity.imageTagOverride }}
{{- else -}}
{{ .Values.foundryBuildVer }}
{{- end -}}
{{- end -}}

{{- define "integrationImage" -}}
{{- if .Values.integration.imageTagOverride -}}
{{ .Values.integration.imageTagOverride }}
{{- else -}}
{{ .Values.foundryBuildVer }}
{{- end -}}
{{- end -}}

{{- define "resolveDbUpdateVersion" -}}
{{- if .Values.dbupdate.advancedMode.enabled -}}
{{- required "The dbupdate.advancedMode.versionTag must be specified when dbupdate.advancedMode is enabled."  .Values.dbupdate.advancedMode.versionTag }}
{{- else -}}
{{- .Values.foundryBuildVer }}
{{- end -}}
{{- end -}}

{{- define "resolveDbUpdateIncludeIdentity" -}}
{{- if .Values.dbupdate.advancedMode.enabled -}}
{{- .Values.dbupdate.advancedMode.updateIdentitySchema }}
{{- else -}}
{{- .Values.identityEnabled }}
{{- end -}}
{{- end -}}

{{- define "resolveDbUpdateIncludeConsole" -}}
{{- if .Values.dbupdate.advancedMode.enabled -}}
{{- .Values.dbupdate.advancedMode.updateConsoleSchema }}
{{- else -}}
{{- .Values.consoleEnabled }}
{{- end -}}
{{- end -}}

{{- define "resolveDbUpdateIncludeIntegration" -}}
{{- if .Values.dbupdate.advancedMode.enabled -}}
{{- .Values.dbupdate.advancedMode.updateIntegrationSchema }}
{{- else -}}
{{- .Values.integrationEnabled }}
{{- end -}}
{{- end -}}

{{- /*
Legacy naming used to follow the old templates for consistency: Messaging is now Engagement
*/ -}}
{{- define "resolveDbUpdateIncludeMessaging" -}}
{{- if .Values.dbupdate.advancedMode.enabled -}}
{{- .Values.dbupdate.advancedMode.updateEngagementSchema }}
{{- else -}}
{{- .Values.engagementEnabled }}
{{- end -}}
{{- end -}}

{{- /*
Admin Database setting: KONY_SERVER_TRUSTSTORE_LOCATION
*/ -}}
{{- define "trustStoreLocation" -}}
{{- if .Values.enableCaCertsOverride -}}
/mnt/foundry-common-secrets/cacerts
{{- else -}}
/usr/local/openjdk-11/lib/security/cacerts
{{- end -}}
{{- end -}}

{{/*
Compute the foundry base url
*/}}
{{- define "foundryBaseUrl" -}}
{{- .Values.serverDomainName }}
{{- end -}}

{{/*
Compute the foundry console url
*/}}
{{- define "foundryConsoleUrl" -}}
{{ .Values.ingress.protocol }}://{{ template "foundryBaseUrl" .}}/mfconsole
{{- end -}}

{{/*
Compute the WAAS base url
*/}}
{{- define "waasBaseUrl" -}}
{{- .Values.ingress.protocol }}://{{ template "foundryBaseUrl" .}}:{{ .Values.ingress.port }}/workspace
{{- end }}