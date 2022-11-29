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

## user-register
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

## user-login
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

## admin-login
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

# /user/

The client must put the token returned with user-login response in the Authorization header using the Bearer schema.\
Refer to [JSON Web Token](https://jwt.io/introduction/)

## TODO

# /admin/

The client must put the token returned with admin-login response in the Authorization header using the Bearer schema.\
Refer to [JSON Web Token](https://jwt.io/introduction/)

## isbn-insert
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

## book-add
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

# /user/ and /admin/

## isbn-list
### Request 1

```json
{
  "name": "Concrete mathematics",
  "author": "Ronald L. Graham",
  "publisher": "Addison-Wesley",
  "year-start": "1994",
  "year-end": "1994",
  "class-number": "QA 39.2",
  "cutter-number": "G73"
}
```

**NOTE:** year-start and year-end are inclusive (`year-start <= year <= year-end`).\
**NOTE:** any of these fields may be left empty or omitted entirely.

### Response 1

```json
{
  "isbn-list": ["0201558025"]
}
```

### Request 2

```json
{
  "name": "Mathematics",
  "class-number": "QA 37.2",
}
```

### Response 2

```json
{
  "isbn-list": ["0521406498", "0521406501", "0135641543"]
}
```

### Possible Errors

empty

## book-list
### Request

```json
{
  "isbn": "0201558025"
}
```

### Response

```json
{
  "id-list": ["7", "123", "342"]
}
```

### Possible Errors

- err-isbn-not-exist
