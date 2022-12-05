# Error Response

*Requests may result in an error response.*
```json
{
  "kind": "err-generic",
  "message": "some error message"
}
```

**NOTE:** `err-generic` and `err-json-decoder` aren't listed in Possible Errors. Because they may be returned to any request.

# /guest/

## user-register
### Request

```json
{
  "name": "Walter",
  "surname": "White",
  "email": "ww@albuquerque.us",
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

**NOTE:** `err-authorization` isn't listed in Possible Errors. Because it may be returned to any request.

## user-profile
### Request

empty

### Response

```json
{
  "name": "Jesse",
  "surname": "Pinkman",
  "email": "jesse@pinkman.com",
  "phone": "+123456789"
}
```

### Possible Errors

- err-user-id-not-exist

## change-user-name
### Request

```json
{
  "new-name": "Jonathan",
  "new-surname": "Wick"
}
```

### Response

empty

### Possible Errors

- err-user-id-not-exist

## change-user-email
### Request

```json
{
  "password": "123",
  "new-email": "example@example.com"
}
```

### Response

empty

### Possible Errors

- err-user-id-not-exist
- err-email-exist
- err-invalid-password

## change-user-phone
### Request

```json
{
  "password": "123",
  "new-phone": "+987654321"
}
```

### Response

empty

### Possible Errors

- err-user-id-not-exist
- err-invalid-password

## change-user-password
### Request

```json
{
  "old-password": "123",
  "new-password": "abc"
}
```

### Response

empty

### Possible Errors

- err-user-id-not-exist
- err-invalid-password

# /admin/

The client must put the token returned with admin-login response in the Authorization header using the Bearer schema.\
Refer to [JSON Web Token](https://jwt.io/introduction/)

**NOTE:** `err-authorization` isn't listed in Possible Errors. Because it may be returned to any request.

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

**NOTE:** `picture` should be a jpg image encoded with base64 with standard padding (`=`).

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

## user-profile-with-id
### Request

```json
{
  "id": "1"
}
```

### Response

```json
{
  "name": "john",
  "surname": "smith",
  "email": "js@example.com",
  "phone": "+123456789"
}
```

### Possible Errors

- err-user-id-not-exist


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
  "cutter-number": "G73",
  "per-page": "20",
  "page": "1"
}
```

**NOTE:** `year-start` and `year-end` are inclusive (`year-start <= year <= year-end`).\
**NOTE:** fields except `per-page` and `page` may be left empty or omitted entirely.\
**NOTE:** `per-page` will be the maximum number of entries per response. `page` is the index of the response (if `per-page` is 20, and current `page` is 3; pages 1 and 2 have been shown so far; current page will have entries starting at 41st entry.). Last page has less than `per-page` entries.

### Response 1

```json
{
  "isbn-list": [
    {
      "isbn": "0201558025",
      "name": "Concrete mathematics",
      "author": "Ronald L. Graham",
      "publisher": "Addison-Wesley",
      "class-number": "QA 39.2",
      "cutter-number": "G73",
      "picture": "eWVzc2ly"
    }
  ]
}
```

### Request 2

```json
{
  "name": "systems",
  "year-start": "1996",
  "year-end": "2007"
}
```

### Response 2

```json
{
  "isbn-list": [
    {
      "isbn": "9780471758235",
      "name": "Urban transit systems and technology",
      "author": "Vukan R. Vuchic",
      "publisher": "John Wiley & Sons",
      "publication-year": "2007",
      "class-number": "HE 308",
      "cutter-number": "V83",
      "picture": "eWVzc2ly"
    },
    {
      "isbn": "0132346265",
      "name": "Wireless and personal communications systems",
      "author": "Vijay Kumar. Garg",
      "publisher": "Prentice-Hall",
      "publication-year": "1996",
      "class-number": "TK 5103.2",
      "cutter-number": "G37",
      "picture": "eWVzc2ly"
    }
  ]
}
```

### Possible Errors

empty

## book-list
### Request

```json
{
  "isbn": "0201558025",
  "per-page": "20",
  "page": "1"
}
```

**NOTE:** `per-page` will be the maximum number of entries per response. `page` is the index of the response (if `per-page` is 20, and current `page` is 3; pages 1 and 2 have been shown so far; current page will have entries starting at 41st entry.). Last page has less than `per-page` entries.

### Response

```json
{
  "id-list": ["7", "123", "342"]
}
```

### Possible Errors

- err-isbn-not-exist

## isbn-profile
### Request

```json
{
  "isbn": "0201558025"
}
```

### Response

```json
{
  "name": "Concrete mathematics",
  "author": "Ronald L. Graham",
  "publisher": "Addison-Wesley",
  "publication-year": "1994",
  "class-number": "QA 39.2",
  "cutter-number": "G73",
  "picture": "eWVzc2ly"
}
```

### Possible Errors

- err-isbn-not-exist
