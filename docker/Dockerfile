#FROM --platform=linux/amd64 ironmansoftware/universal:latest
#LABEL description="This is PSU in Docker"
#EXPOSE 5000
#VOLUME [ "/home/data" ]
#ENV Data_repositroryPath="/home/data/Repository"
#ENV Data_connectionString="/home/data/database.db"
#ENV universal_dashboardAssetsFolder="/home/data/universalDashboard"
#ENV logging_path="/home/data/logs/log.txt"
#ENTRYPOINT [ "./Universal/Universal.Server" ]
FROM ironmansoftware/universal:latest
LABEL description="This is PSU in Docker"
EXPOSE 5000
VOLUME [ "/home/data" ]
ENV Data_repositroryPath="/home/data/Repository"
ENV Data_connectionString="/home/data/database.db"
ENV universal_dashboardAssetsFolder="/home/data/universalDashboard"
ENV logging_path="/home/data/logs/log.txt"
ENTRYPOINT [ "./Universal/Universal.Server" ]