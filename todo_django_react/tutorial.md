# Admin Login
localhost:8000/admin <br>
name: developer <br>
pass: todo

# React frontend
localhost:3000

# Tutorial doesn't mention
Add this to <br>
`backend/settings.py`
```py
ALLOWED_HOSTS = [
    '127.0.0.1',
    'localhost'
]
```
as well as
```py
CORS_ORIGIN_WHITELIST = [
     'http://127.0.0.1:3000',
     'http://localhost:3000',
]
```


# Url
https://www.digitalocean.com/community/tutorials/build-a-to-do-application-using-django-and-react