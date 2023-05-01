# Week 3 — Decentralized Authentication

## Required Homework

### Steps to configure Cognito

1. Log in AWS and search Cognito.

2. Click *Create User Pool* and change the options below:

  a. Sign-in options: Email
  
  b. Multi-factor authentication: No MFA
  
  c. Additional required attributes: name, preferred_name
  
  d. Email: Send email with Cognito
  
  e. User pool name: <...name...>
  
  f. App client name: <...name...>
  
3. Review and click *Create user pool*.

![cognito 1](https://user-images.githubusercontent.com/80562235/235534148-fa85d53e-b7f2-4238-8565-4111f8382ee1.png)

The created pool is being showed below:

![cognito 2](https://user-images.githubusercontent.com/80562235/235534371-b417ae1d-d95a-447e-b4bc-5f5f15a929f3.png)

### Frontend Enviroment Variables and Sign In 

1. Installation of aws-aplify with ```npm i aws-amplify --save``` command.

2. Find in AWS Cognito the *User Pool ID* and *Client ID* variables.

3. ```app.js``` and ```docker-compose.yml``` files was updated as below:

app.js:

![Update app js file for Amplify 3](https://user-images.githubusercontent.com/80562235/235535474-07318b45-7011-4c88-b704-589b9a5ba958.png)

docker-compose.yml:

![Update docker-compose yml file for Amplify variables 4](https://user-images.githubusercontent.com/80562235/235535601-3e440062-aebf-4691-bab4-ad3e188d3fdf.png)

4. ```HomeFeedPage.js```, ```SigninPage.js``` and ```ProfileInfo.js``` files were updated as below:

HomeFeedPage.js:
```
//AWS Amplify
import { Auth } from 'aws-amplify';
...
// check if we are authenticated
const checkAuth = async () => {
Auth.currentAuthenticatedUser({
    // Optional, By default is false. 
    // If set to true, this call will send a 
    // request to Cognito to get the latest user data
    bypassCache: false 
})
.then((user) => {
    console.log('user',user);
    return Auth.currentAuthenticatedUser()
}).then((cognito_user) => {
    setUser({
        display_name: cognito_user.attributes.name,
        handle: cognito_user.attributes.preferred_username
    })
})
.catch((err) => console.log(err));
};
```

SigninPage.js:
```
import { Auth } from 'aws-amplify';
...
const onsubmit = async (event) => {
 event.preventDefault();

 Auth.signIn(email, password)
   .then(user => {
     localStorage.setItem("access_token", user.signInUserSession.accessToken.jwtToken)
     window.location.href = "/"
   })
   .catch(error => { if (error.code == 'UserNotConfirmedException') {
     window.location.href = "/confirm"
   }
   setErrors(error.message) });

 return false
}
```

ProfileInfo.js:
```
import { Auth } from 'aws-amplify';
...
const signOut = async () => {
 try {
     await Auth.signOut({ global: true });
     window.location.href = "/"
 } catch (error) {
     console.log('error signing out: ', error);
    }
}
```

### User Creation and Email Verification

1. User Creation:

![user creation 8](https://user-images.githubusercontent.com/80562235/235536975-af10d6a3-3fe1-4f49-9ad6-7c724ca40beb.png)

2. Email Verification:

![confirmation mail 7](https://user-images.githubusercontent.com/80562235/235537065-f2a5a907-961f-407c-8b13-8e148728f46e.png)

3. Status change:

![cognito change confirmation status 5](https://user-images.githubusercontent.com/80562235/235537119-ec2315bd-c037-41e8-8b9a-faa2a31285a0.png)

4. Logged-in User:

![homefeedpage with username 6](https://user-images.githubusercontent.com/80562235/235537202-406a650b-8286-4ea8-877d-d49b891b862e.png)

### Custom Signup, Confirmation, and Recovery pages update

SignuPage.js:

```
//Authenication
import { Auth } from 'aws-amplify';
...
const onsubmit = async (event) => {
  event.preventDefault();
  setErrors('')
  try {
      const { user } = await Auth.signUp({
        username: email,
        password: password,
        attributes: {
          name: name,
          email: email,
          preferred_username: username,
        },
        autoSignIn: { // optional - enables auto sign in after user is confirmed
          enabled: true,
        }
      });
      console.log(user);
      window.location.href = `/confirm?email=${email}`
  } catch (error) {
      console.log(error);
      setErrors(error.message)
  }
  return false
}
```

ConfirmationPage.js:
```
import { Auth } from 'aws-amplify';
...
const resend_code = async (event) => {
  setErrors('')
  try {
    await Auth.resendSignUp(email);
    console.log('code resent successfully');
    setCodeSent(true)
  } catch (err) {
    console.log(err)
    if (err.message == 'Username cannot be empty'){
      setErrors("You need to provide an email in order to send Resend Activiation Code")   
    } else if (err.message == "Username/client id combination not found."){
      setErrors("Email is invalid or cannot be found.")   
    }
  }
}

const onsubmit = async (event) => {
  event.preventDefault();
  setErrors('')
  try {
    await Auth.confirmSignUp(email, code);
    window.location.href = "/"
  } catch (error) {
    setErrors(error.message)
  }
  return false
}
```

RecoveryPage.js:
```
import { Auth } from 'aws-amplify';
...
const onsubmit_send_code = async (event) => {
  event.preventDefault();
  setErrors('')
  Auth.forgotPassword(username)
  .then((data) => setFormState('confirm_code') )
  .catch((err) => setErrors(err.message) );
  return false
}

const onsubmit_confirm_code = async (event) => {
  event.preventDefault();
  setErrors('')
  if (password == passwordAgain){
    Auth.forgotPasswordSubmit(username, code, password)
    .then((data) => setFormState('success'))
    .catch((err) => setErrors(err.message) );
  } else {
    setErrors('Passwords do not match')
  }
  return false
}
```

### Cognito JWT Token - Backend Server

1. Updated ```HomeFeedPage.js``` page, to include the JWT token as part of the request header:

```
const loadData = async () => {
    try {
      const backend_url = `${process.env.REACT_APP_BACKEND_URL}/api/activities/home`
      var startTime = performance.now()
      const res = await fetch(backend_url, {
        headers: {
          // ******Add JWT to request Header*******
          Authorization: `Bearer ${localStorage.getItem("access_token")}`
        },
        method: "GET"
      });
      // Other part of the method/function .....
  };
```

2. Updated ```app.py``` file for:

a. *CORS*:
```
cors = CORS(
  app, 
  resources={r"/api/*": {"origins": origins}},
  expose_headers="location,link",
  allow_headers="content-type,if-modified-since",
  expose_headers="location,link,Authorization",
  headers=['Content-Type', 'Authorization'], 
  methods="OPTIONS,GET,HEAD,POST"
)
```

b. Imports:

```
from lib.cognito_jwt_token import TokenVerifyError, CognitoJwtToken

app = Flask(__name__)

#JWT Token
cognito_jwt_token = CognitoJwtToken(
    user_pool_id = os.getenv("AWS_COGNITO_USER_POOLS_ID"), 
    user_pool_client_id = os.getenv("AWS_COGNITO_CLIENT_ID"), 
    region = os.getenv("AWS_DEFAULT_REGION")
    )
```

c. *data_home()*:

```
@app.route("/api/activities/home", methods=['GET'])
def data_home():

  access_token = cognito_jwt_token.extract_access_token(request.headers)
  if access_token == "null": #empty accesstoken
    data = HomeActivities.run()
    return data, 200
  
  # If token isn't null
  try:
    cognito_jwt_token.verify(access_token)
    app.logger.debug("Authenicated")
    app.logger.debug(f"User: {cognito_jwt_token.claims['username']}")
    data = HomeActivities.run(cognito_user=cognito_jwt_token.claims['username'])
  except TokenVerifyError as e:
    app.logger.debug("Authentication Failed")
    app.logger.debug(e)
    data = HomeActivities.run()

  return data, 200
```

3. Also, in order for ```home_activities.py``` to accept users, this file was update as follows:

```
class HomeActivities:
  def run(logger=None, cognito_user=None): # add cognito_user
    # logger.info("Test from Home Activities")
    with tracer.start_as_current_span("home-activities-mock-data"):
      
      # ... Other parts

      if cognito_user is not None:
        extra_crud = {
          'uuid': '248959df-3079-4947-b847-9e0892d1bab4',
          'handle':  'Abby',
          'message': 'Always ready to give it my all...',
          'created_at': (now - timedelta(hours=1)).isoformat(),
          'expires_at': (now + timedelta(hours=12)).isoformat(),
          'likes': 600,
          'replies': []
        }
        results.insert(0,extra_crud)
      span.set_attribute("app.result_length", len(results))
      return results
```

4. Furthermore, updated ```docker-compose.yml``` file with the enviroment variables:

![cognito jwt token verification 12](https://user-images.githubusercontent.com/80562235/235538806-a0d00cdc-81be-42d4-8f4a-47c23ad0cad2.png)

5. Finally, updated the ```ProfileInfo.js``` file, to force the deletion of JWT token, with the log out of a user:

![JWT 9](https://user-images.githubusercontent.com/80562235/235539036-8a4ca033-7eaa-4222-938e-54289a497c8e.png)

6. The final results are depicted below:

a. ![cognito jwt token verification 10](https://user-images.githubusercontent.com/80562235/235539349-abec6757-d2e2-49d9-bf5e-2aa61a538835.png)

b. ![cognito jwt token verification 11](https://user-images.githubusercontent.com/80562235/235539513-3f566453-6c38-4cd8-a121-dccd52a5e849.png)
