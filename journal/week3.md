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

4. ```HomeFeedPage.js```, ```SigninPage.js``` and ```ProfileInfo.js files were updated as below:

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


