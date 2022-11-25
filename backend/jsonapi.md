# Error Response

*Requests may result in an error response.*
```json
{
  "kind": "err-generic",
  "message": "some error message"
}
```

**NOTE:** err-generic and err-json-decoder aren't listed in Possible Errors. Because they may be returned to any request.

# /guest/
## /guest/user-register
### Request

```json
{
  "name": "john",
  "surname": "smith",
  "email": "js@example.com",
  "phone": "+123456789",
  "password": "123"
}
```

### Response

empty

### Possible Errors

- err-email-exist

## /guest/user-login
### Request

```json
{
  "email": "js@example.com",
  "password": "123"
}
```

### Response

```json
{
  "token": "mgdHJK"
}
```

### Possible Errors

- err-email-not-exist
- err-invalid-password

## /guest/admin-login
### Request

```json
{
  "name": "spexso",
  "password": "123"
}
```

### Response

```json
{
  "token": "mgdHJK"
}
```

### Possible Errors

- err-name-not-exist
- err-invalid-password

# /admin/

The client must put the token returned with admin-login response in the Authorization header using the Bearer schema.\
Refer to [JSON Web Token](https://jwt.io/introduction/) 

## /admin/isbn-insert
### Request

```json
{
  "isbn": "0201558025",
  "name": "Concrete mathematics",
  "author": "Ronald L. Graham",
  "publisher": "Addison-Wesley",
  "publication-year": "1994",
  "class-number": "QA 39.2",
  "cutter-number": "G73",
  "picture": "eWVzc2ly"
}
```

**NOTE:** picture should be a jpg or png image encoded with base64 with standard padding (`=`).

### Response

empty

### Possible Errors

- err-base64-decoder
- err-isbn-exist

## /admin/book-add
### Request

```json
{
  "isbn": "0201558025"
}
```

### Response

empty

### Possible Errors

- err-isbn-not-exist
