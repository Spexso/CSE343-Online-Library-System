# Error Response

*Requests may result in an error response.*
```json
{
  "kind": "err-generic",
  "message": "some error message"
}
```

**NOTE:** err-generic and err-json-decoder aren't listed in Possible Errors. Because they may be returned to any request.

# /guest/user-register
## Request

```json
{
  "name": "john",
  "surname": "smith",
  "email": "js@example.com",
  "phone": "+123456789",
  "password": "123"
}
```

## Response

```json
{
}
```

### Possible Errors

- err-email-exist

# /guest/user-login
## Request

```json
{
  "email": "js@example.com",
  "password": "123"
}
```

## Response

```json
{
  "token": "mgdHJK"
}
```

### Possible Errors

- err-email-not-exist
- err-invalid-password

# /guest/admin-login
## Request

```json
{
  "name": "spexso",
  "password": "123"
}
```

## Response

```json
{
  "token": "mgdHJK"
}
```

### Possible Errors

- err-name-not-exist
- err-invalid-password
