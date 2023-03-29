FROM python:3.10-slim-buster

# Inside Container
WORKDIR /backend-flask

# Outside Container -> Inside Container
# This contains the libraries want to install to run the app
COPY requirements.txt requirements.txt

# Inside Container
# Install the python libraries used for the app
RUN pip3 install -r requirements.txt

# Outside Container -> Inside Container
# . means everything in current directory
# first period (.) means /backend-flask  (outside container)
# second period (.) means /backend-flask  (inside container)
COPY . .

# Set Environment Variables (env vars)
# Inside container and will remain set when the container is running
ENV FLASK_ENV=development

EXPOSE ${PORT}

# CMD (Command)
# python3 -m flask run --host=0.0.0.0 --port=4567
CMD [ "python3", "-m" , "flask", "run", "--host=0.0.0.0", "--port=4567"]