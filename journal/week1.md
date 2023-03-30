# Week 1 — App Containerization

## Required Homework

### 1) Frontend and Backend Containerization

Backend Containerization was completed by writing a dockerfile as depicted in figure below:

![Docker Images](https://user-images.githubusercontent.com/80562235/228883496-d1f3f93b-40cb-4047-b1d5-54f3f1aab9ed.png)

Frontend Containerization was completed by writing a dockerfile which is located [here](https://github.com/StavrosCaptain/aws-bootcamp-cruddur-2023/blob/main/frontend-react-js/Dockerfile).

Finally, we wrote a docker-compose.yml file which is located [here](https://github.com/StavrosCaptain/aws-bootcamp-cruddur-2023/blob/main/docker-compose.yml).

After the "compose up" command we have specific ports running as below (except from port 5432, which is for postgres and we configure it below):

![ports for dynamoDB and postgres](https://user-images.githubusercontent.com/80562235/228887256-ec0928b5-66c9-4032-8443-683562b201b0.png)

### 2) Notifications Page

Backend Response from Notifications Page:

![api_activities_notifications url](https://user-images.githubusercontent.com/80562235/228886219-c3fdb05a-6b21-456e-b938-cee963b904c5.png)

Fixed Notifications Page:

![end of implementation of notifications page](https://user-images.githubusercontent.com/80562235/228886661-910b949a-71e5-4dda-8283-f140384a8bcf.png)

### 3) DynamoDB and Postgres

a) Update of docker-compose.yml and .gitpod files as depicted below:

![postgres and dynamodb in docker compose](https://user-images.githubusercontent.com/80562235/228889075-3c51e84b-1657-42c8-ba54-64c1a89955bf.png)

![postgres and dynamodb in gitpod file](https://user-images.githubusercontent.com/80562235/228889613-3d647987-00bb-4082-ba57-335405ee20c9.png)

b) Creation a Table in DynamoDB and connected Postgres to a database:

![postgress connection](https://user-images.githubusercontent.com/80562235/228889790-8fb3edf5-8c36-4df9-845c-decc3279bbec.png)
