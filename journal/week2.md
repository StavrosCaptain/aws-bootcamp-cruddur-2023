# Week 2 — Distributed Tracing

## Required Homework

### Honeycomb Distributed Tracing

1) Created a new environment in my Honeycomb account with the name AWS-Bootcamp-2023

2) Parsed the API key and Service name and restarted gitpod: 
   ```
   gp env HONEYCOMB_API_KEY = "<API_KEY>"
   gp env HONEYCOMB_SERVICE_NAME = "<SERVICE_NAME>"
   ```

3) Updated the docker-compose.yml file:
   ```
   OTEL_SERVICE_NAME: 'backend-flask'
   OTEL_EXPORTER_OTLP_ENDPOINT: "https://api.honeycomb.io"
   OTEL_EXPORTER_OTLP_HEADERS: "x-honeycomb-team=${HONEYCOMB_API_KEY}"
   ```
4) Added python modules in requirements.txt for Open Telemetry:
   ```
   opentelemetry-api
   opentelemetry-sdk
   opentelemetry-exporter-otlp-proto-http
   opentelemetry-instrumentation-flask
   opentelemetry-instrumentation-requests
   ```
5) In app.py added the following:
   ```
   HoneyComb ------------
   from opentelemetry import trace
   from opentelemetry.instrumentation.flask import FlaskInstrumentor
   from opentelemetry.instrumentation.requests import RequestsInstrumentor
   from opentelemetry.exporter.otlp.proto.http.trace_exporter import OTLPSpanExporter
   from opentelemetry.sdk.trace import TracerProvider
   from opentelemetry.sdk.trace.export import BatchSpanProcessor
   from opentelemetry.sdk.trace.export import ConsoleSpanExporter, SimpleSpanProcessor
   ```
   ```
   # HoneyComb ------------
   # Initialize tracing and an exporter that can send data to Honeycomb
   provider = TracerProvider()
   processor = BatchSpanProcessor(OTLPSpanExporter())
   provider.add_span_processor(processor)
   ```
   ```
   # HoneyComb ------------
   # Initialize automatic instrumentation with Flask
   FlaskInstrumentor().instrument_app(app)
   RequestsInstrumentor().instrument()
   ```
6) In home_activities.py we must do the following:
   
   a) To acquire a tracer:
      ```
      from opentelemetry import trace
      tracer = trace.get_tracer("home.activities")
      ```
   b) To create a span and add attributes:
      ```
      with tracer.start_as_current_span("home-activities-mock-data"):
      span = trace.get_current_span()
      now = datetime.now(timezone.utc).astimezone()
      span.set_attribute("app.now", now.isoformat())
      ..........
      ```
7) After running docker compose up:
   ![honeycomb 1](https://user-images.githubusercontent.com/80562235/233451367-21132695-2f81-402d-a30b-64eeeec47279.png)
   ![honeycomb 2](https://user-images.githubusercontent.com/80562235/233451390-ba925ad2-695e-4781-8594-a6997c04ed32.png)

8) Also, to automatically have all ports open every time after the docker compose up:
   ```
   ports:
   - name: frontend
    port: 3000
    onOpen: open-browser
    visibility: public
   - name: backend
    port: 4567
    visibility: public
   - name: xray-daemon
    port: 2000
    visibility: public
   ```
### Instrument X-RAY

1) Added and installed python modules in requirements.txt.

2) Update backend-flask:
   ```
   # X-RAY -----------
   from aws_xray_sdk.core import xray_recorder
   from aws_xray_sdk.ext.flask.middleware import XRayMiddleware
   
   # X-RAY -----------
   xray_url = os.getenv("AWS_XRAY_URL")
   xray_recorder.configure(service='backend-flask', dynamic_naming=xray_url)
   
   X-RAY -----------
   XRayMiddleware(app, xray_recorder)
   ```
   
3) Created the aws/json/xray.json file and imported the "SamplingRule":
   ```
   {
    "SamplingRule": {
        "RuleName": "Cruddur",
        "ResourceARN": "*",
        "Priority": 9000,
        "FixedRate": 0.1,
        "ReservoirSize": 5,
        "ServiceName": "backend-flask",
        "ServiceType": "*",
        "Host": "*",
        "HTTPMethod": "*",
        "URLPath": "*",
        "Version": 1
    }
   }
   ```
   With the command:
   
   ![creation of sampling rule 2](https://user-images.githubusercontent.com/80562235/233455647-8ffefa83-4b77-47a8-bb37-cd7a47894472.png)
   ![creation of sampling rule](https://user-images.githubusercontent.com/80562235/233455664-ab3703a5-59c5-4e4b-8883-21600f167791.png)

4) Created a group with the command:
   ```
   aws xray create-group \
   --group-name "Cruddur" \
   --filter-expression "service(\"backend-flask\")"
   ```
   ![group creation in xray - cloudwatch 2](https://user-images.githubusercontent.com/80562235/233455721-3f97c2bd-8af8-4b35-b199-55007a0f7706.png)
   ![group creation in xray - cloudwatch](https://user-images.githubusercontent.com/80562235/233455941-1277c3e8-17ab-4941-97af-1c902d1a004e.png)

5) Update the docker-compose.yml file:

   ![docker-compose update with envs](https://user-images.githubusercontent.com/80562235/233457477-5a9069b6-1928-471e-be28-25a266c50978.png)
   ![docker-compose update fro xray](https://user-images.githubusercontent.com/80562235/233457489-68efd90b-a922-4228-8f4e-cfaa363904e2.png)


6) After docker compose up:

   ![first traces](https://user-images.githubusercontent.com/80562235/233457307-e8f3580f-b520-42a6-ba50-6ea90951d0c1.png)

7) Fixed subsegments for X-Ray:

   ![fixed segments in xray](https://user-images.githubusercontent.com/80562235/233457877-2d092874-a6aa-415c-94b2-b982299b2372.png)

8) Example of sending batch segments:

   ![sent batch segments](https://user-images.githubusercontent.com/80562235/233458025-0cf63e42-e569-4ebe-9eea-3d758685290a.png)
   ![sent batch segments 2](https://user-images.githubusercontent.com/80562235/233458039-00888303-bc73-4474-936f-432ac3ed2942.png)

### CloudWatch Logs

1) Added watchtower to requirements.txt and installed it.

2) Imported python libraries and configured Logger to use CloudWatch in app.py in backend-flask:
   
   ![cloudwatch logger in app py 0](https://user-images.githubusercontent.com/80562235/233465778-25ac1954-7111-4c66-93a9-e715b1f420c6.png)

3) Also added in app.py:

   ![logger backend cloudwatch in aws 3](https://user-images.githubusercontent.com/80562235/233466162-d72bb514-ef45-437c-be35-c85f0c3900cb.png)
   
4) Updated the home_activities.py as follows:

   ![cloudwatch logger in home_activities](https://user-images.githubusercontent.com/80562235/233466217-d78c4870-5180-4e1a-91fd-d2d31cfad14a.png)

   Passed the LOGGER variable in HomeActivities class:
   
   ```
   @app.route("/api/activities/home", methods=['GET'])
   def data_home():
      data = HomeActivities.run(LOGGER) <-----<<-
      return data, 200
   ```

5) Added env variables in docker-compose.yml file:
   
   ```
   AWS_DEFAULT_REGION: "${AWS_DEFAULT_REGION}"
   AWS_ACCESS_KEY_ID: "${AWS_ACCESS_KEY_ID}"
   AWS_SECRET_ACCESS_KEY: "${AWS_SECRET_ACCESS_KEY}"
   ```

6) After docker compose up:

   ![logger backend cloudwatch in aws 2](https://user-images.githubusercontent.com/80562235/233467362-0f737faa-2248-4248-93da-aba889881712.png)

### Rollbar

1) Added and installed add-ons in requirements.txt in backend-flask.

2) Exported Rollbar access token for flask SDK:

   ```
   export ROLLBAR_ACCESS_TOKEN: "..."
   gp env ROLLBAR_ACCESS_TOKEN: "..."
   ```
   and added to docker-compose.yml file.
   
3) Updated app.py in backend-flask as follows:

   ![rollbar 2](https://user-images.githubusercontent.com/80562235/233470767-6a9a9ecf-e82a-45fc-9865-461fc88f0461.png)

   ![rollbar 3](https://user-images.githubusercontent.com/80562235/233470783-38b16e49-8b09-4d8c-be20-faa76856dddb.png)

4) After docker compose up, if i visit <the url of opened port 4567>/rollbar/test:

   ![rollbar 4](https://user-images.githubusercontent.com/80562235/233471660-71c0c880-6181-4bef-a9ff-882c4fae2e71.png)
   
5) Also, when I visited my Rollbar account results had started to appear:

   ![rollbar 1](https://user-images.githubusercontent.com/80562235/233471885-a13eeb8a-07ca-489d-908b-87d9e560c6a3.png)

6) To check the function of Rollbar we can make a mistake on purpose, for example by removing ```return``` from ```return results``` in ```home_activities.py```. So, when i visit the same url, but with /api/activities/home, and alert is appeared in Rollbar:

   ![rollbar 5](https://user-images.githubusercontent.com/80562235/233473013-bc718f3d-063b-4f0b-9e43-9b3a2f1fe9c1.png)

   

   
