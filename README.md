# Yarn Logs - Spark Streaming 
Spark running on Yarn - log aggregation tool for spark streaming applications running on yarn

#Issue
Yarn log aggregation does not work for streaming apps unless the apps completes successfullly or gets killed.


#Log4j Properties
You can create roll over logs by passing the log4j properties to the spark streaming app as shown below

log4j.rootLogger=INFO, rolling
log4j.appender.rolling=org.apache.log4j.rolling.RollingFileAppender
log4j.appender.rolling.layout=org.apache.log4j.PatternLayout
log4j.appender.rolling.layout.conversionPattern=[%d] %p %m (%c)%n
log4j.appender.rolling.rollingPolicy = org.apache.log4j.rolling.TimeBasedRollingPolicy
log4j.appender.rolling.rollingPolicy.FileNamePattern = ${spark.yarn.app.container.log.dir}/stderr%d{yyyyMMddHHmm}
log4j.appender.rolling.file=${spark.yarn.app.container.log.dir}/stderr
log4j.appender.rolling.rollingPolicy.ActiveFileName=${spark.yarn.app.container.log.dir}/stderr
log4j.appender.rolling.encoding=UTF-8

#Script
Given an applicationId and time range Script "yarncontainerlogs.sh" will aggregate logs from all the yarn containers for that
range of time and dump it in your current directory

#Script Usage
applicationid active_file_name start_date end_date in order
ex:
yarncontainerlogs.sh application_1452787512024_0090 stderr 201601141641 201601141643
