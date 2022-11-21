# an error response
*requests may result in an error response*
```
{
  "kind": "err-generic",
  "message": "some error message"
}
```

---

# /guest/user-register
## request
```
{
  "name": "john",
  "surname": "smith",
  "email": "js@example.com",
  "phone": "+123456789",
  "password": "123"
}
```

## response
```
{
}
```

### possible errors
- err-email-exist
- err-json-decoder
- err-generic

---

# /guest/user-login
## request
```
{
  "email": "js@example.com",
  "password": "123"
}
```

## response
```
{
  "token": "mgdHJK",
}
```

### possible errors
- err-email-not-exist
- err-invalid-password
- err-json-decoder
- err-generic

---

# /guest/admin-login
## request
```
{
  "name": "spexso",
  "password": "123"
}
```

## response
```
{
  "token": "mgdHJK",
}
```

### possible errors
- err-name-not-exist
- err-invalid-password
- err-json-decoder
- err-generic
